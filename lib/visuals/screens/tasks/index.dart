import 'dart:convert';
import 'dart:io';

import 'package:ascent/visuals/components/app_styles.dart';
import 'package:ascent/visuals/components/theme_extensions/general_decoration.dart';
import 'package:ascent/visuals/components/theme_extensions/task_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:ascent/database/app_database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final database = AppDatabase();
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskBodyController = TextEditingController();
  List<Task> _tasks = [];
  Map<String, List<Task>>? _categorizedTasksCache;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  @override
  void dispose() {
    _taskTitleController.dispose();
    _taskBodyController.dispose();
    super.dispose();
  }

  // Database operations
  Future<void> _fetchTasks() async {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final tomorrow = todayDate.add(const Duration(days: 1));

    final tasks =
        await (database.select(database.tasks)..where(
          (tbl) =>
              tbl.doneOn.isNull() |
              (tbl.doneOn.isBiggerThan(drift.Constant(todayDate)) &
                  tbl.doneOn.isSmallerThan(drift.Constant(tomorrow))),
        )).get();

    tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    if (mounted) {
      setState(() {
        _tasks = tasks;
        _categorizedTasksCache = null;
      });
    }
  }

  Future<void> _addTask(
    String taskTitle,
    String? taskBody,
    DateTime dueDate,
  ) async {
    await database
        .into(database.tasks)
        .insert(
          TasksCompanion.insert(
            taskTitle: taskTitle,
            taskBody: drift.Value(taskBody),
            dueDate: dueDate,
          ),
        );
    await _fetchTasks();
  }

  Future<void> _updateTask(
    Task task,
    String newTaskTitle,
    String? newTaskBody,
    DateTime newDueDate,
  ) async {
    await (database.update(database.tasks)
      ..where((tbl) => tbl.id.equals(task.id))).write(
      TasksCompanion(
        taskTitle: drift.Value(newTaskTitle),
        taskBody: drift.Value(newTaskBody),
        dueDate: drift.Value(newDueDate),
      ),
    );
    await _fetchTasks();
  }

  Future<void> _deleteTask(Task task) async {
    await (database.delete(database.tasks)
      ..where((tbl) => tbl.id.equals(task.id))).go();
    await _fetchTasks();
  }

  Future<void> _toggleTaskCompletion(Task task, bool isDone) async {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task.copyWith(
          doneOn: isDone ? drift.Value(DateTime.now()) : drift.Value(null),
        );
      }

      _categorizedTasksCache = null;
    });

    await (database.update(database.tasks)
      ..where((tbl) => tbl.id.equals(task.id))).write(
      TasksCompanion(doneOn: drift.Value(isDone ? DateTime.now() : null)),
    );
  }

  // Task sharing utilities
  Future<void> _shareTaskAsFile(Task task) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/${task.taskTitle}.aso');
    await file.writeAsString(
      jsonEncode({
        "secret": "eMR3C2e",
        "taskTitle": task.taskTitle,
        "taskBody": task.taskBody,
        "dueDate": task.dueDate.toIso8601String(),
      }),
    );

    final params = ShareParams(
      files: [XFile(file.path)],
      subject: "Task: ${task.taskTitle}",
      text:
          "${task.taskTitle}\n"
          "${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}\n\n"
          "${task.taskBody ?? "No description"}",
    );

    await SharePlus.instance.share(params);
  }

  void _copyTaskToClipboard(Task task) {
    Clipboard.setData(
      ClipboardData(
        text:
            "${task.taskTitle}\n"
            "${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}\n\n"
            "${task.taskBody ?? "No description"}",
      ),
    );
  }

  // Task organization
  Map<String, List<Task>> _categorizeTasks() {
    if (_categorizedTasksCache != null) return _categorizedTasksCache!;

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final tomorrow = todayDate.add(const Duration(days: 1));

    return _categorizedTasksCache = {
      "Today":
          _tasks
              .where(
                (task) =>
                    task.doneOn == null &&
                    !task.dueDate.isBefore(todayDate) &&
                    task.dueDate.isBefore(tomorrow),
              )
              .toList(),
      "Previous":
          _tasks
              .where(
                (task) =>
                    task.doneOn == null && task.dueDate.isBefore(todayDate),
              )
              .toList(),
      "Future":
          _tasks
              .where(
                (task) =>
                    task.doneOn == null && !task.dueDate.isBefore(tomorrow),
              )
              .toList(),
      "Completed": _tasks.where((task) => task.doneOn != null).toList(),
    };
  }

  // UI Components
  Widget _buildTaskList() {
    final categorizedTasks = _categorizeTasks();

    return ListView.builder(
      itemCount:
          categorizedTasks.entries.where((e) => e.value.isNotEmpty).length,
      itemBuilder: (context, index) {
        final entry = categorizedTasks.entries
            .where((e) => e.value.isNotEmpty)
            .elementAt(index);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                entry.key,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...entry.value.map(_buildTaskTile),
          ],
        );
      },
    );
  }

  Widget _buildTaskTile(Task task) {
    final isCompleted = task.doneOn != null;
    final isOverdue = task.dueDate.isBefore(DateTime.now()) && !isCompleted;
    final taskDecoration = Theme.of(context).extension<TaskDecoration>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onDoubleTap: () => _toggleTaskCompletion(task, !isCompleted),
        onLongPress: () => _showTaskBottomSheet(task, "Edit Task"),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: taskDecoration?.borderedContainer,
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: isCompleted,
                    onChanged: (value) => _toggleTaskCompletion(task, value!),
                  ),
                  const Gap(6),
                  Expanded(
                    child: Text(
                      task.taskTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: taskDecoration?.taskTitleStyle.copyWith(
                        decoration:
                            isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                  const Gap(10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: taskDecoration?.dateTagContainer,
                    child: Text(
                      "${task.dueDate.day}/${task.dueDate.month}",
                      style: TextStyle(
                        color:
                            isOverdue
                                ? taskDecoration?.overdueColor
                                : taskDecoration?.dueColor,
                      ),
                    ),
                  ),
                ],
              ),
              if (task.taskBody?.isNotEmpty ?? false)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 6,
                  ),
                  child: Text(
                    task.taskBody!,
                    style: taskDecoration?.taskBodyStyle.copyWith(
                      decoration:
                          isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTaskBottomSheet(Task? task, String label) {
    _taskTitleController.text = task?.taskTitle ?? "";
    _taskBodyController.text = task?.taskBody ?? "";
    DateTime selectedDate = task?.dueDate ?? DateTime.now();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      isScrollControlled: true,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setModalState) => SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 3,
                          right: 3,
                          left: 3,
                        ),
                        child: AppStyles.appBar(
                          label,
                          context,
                          actions:
                              task != null
                                  ? <Widget>[
                                    IconButton(
                                      icon: const Icon(
                                        Icons.copy_outlined,
                                        size: 20,
                                      ),
                                      onPressed:
                                          () => _copyTaskToClipboard(task),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.share, size: 22),
                                      onPressed: () => _shareTaskAsFile(task),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        size: 26,
                                      ),
                                      onPressed: () {
                                        _deleteTask(task);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ]
                                  : <Widget>[],
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        child: Column(
                          children: [
                            TextField(
                              controller: _taskTitleController,
                              textCapitalization: TextCapitalization.sentences,
                              style: const TextStyle(fontSize: 16),
                              decoration: const InputDecoration(
                                hintText: "Task Title",
                              ),
                            ),
                            const Gap(16),
                            TextFormField(
                              controller: _taskBodyController,
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: 4,
                              style: const TextStyle(fontSize: 16),
                              decoration: const InputDecoration(
                                hintText: "Add Description (Optional)",
                              ),
                              keyboardType: TextInputType.multiline,
                            ),
                            const Gap(16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      final picked = await showDatePicker(
                                        context: context,
                                        initialDate: selectedDate,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2200),
                                      );
                                      if (picked != null)
                                        setModalState(
                                          () => selectedDate = picked,
                                        );
                                    },
                                    icon: const Icon(Icons.calendar_today),
                                    label: Text(
                                      "Due: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                                    ),
                                    style:
                                        Theme.of(context)
                                            .extension<GeneralDecoration>()
                                            ?.secondaryButton,
                                  ),
                                ),
                                const Gap(16),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.abc),
                                    label: const Text("Coming Soon"),
                                    style:
                                        Theme.of(context)
                                            .extension<GeneralDecoration>()
                                            ?.secondaryButton,
                                  ),
                                ),
                              ],
                            ),
                            const Gap(16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancel"),
                                  ),
                                ),
                                const Gap(12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_taskTitleController
                                          .text
                                          .isNotEmpty) {
                                        if (task != null) {
                                          _updateTask(
                                            task,
                                            _taskTitleController.text,
                                            _taskBodyController.text.isNotEmpty
                                                ? _taskBodyController.text
                                                : null,
                                            selectedDate,
                                          );
                                        } else {
                                          _addTask(
                                            _taskTitleController.text,
                                            _taskBodyController.text.isNotEmpty
                                                ? _taskBodyController.text
                                                : null,
                                            selectedDate,
                                          );
                                        }
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text("Save"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Gap(MediaQuery.of(context).viewInsets.bottom),
                    ],
                  ),
                ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppStyles.appBar("Tasks", context),
      body: _buildTaskList(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showTaskBottomSheet(null, "Add Task"),
      ),
    );
  }
}
