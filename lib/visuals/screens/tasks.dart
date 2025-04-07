import 'package:ascent/visuals/components/app_styles.dart';
import 'package:ascent/visuals/components/theme_extensions/task_decoration.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ascent/database/app_database.dart';
import 'package:drift/drift.dart' as drift;
import 'dart:async';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  // Database instance
  final database = AppDatabase();

  // Controllers and state
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

  // Database Operations
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
        _categorizedTasksCache = null; // Invalidate cache
      });
    }
  }

  Future<void> _addTask(
    String taskTitle,
    String taskBody,
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
    String newTaskBody,
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
    // Update UI immediately for better responsiveness
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = Task(
          id: task.id,
          taskTitle: task.taskTitle,
          taskBody: task.taskBody,
          dueDate: task.dueDate,
          doneOn: isDone ? DateTime.now() : null,
        );
      }
      _categorizedTasksCache = null; // Invalidate cache
    });

    await (database.update(database.tasks)
      ..where((tbl) => tbl.id.equals(task.id))).write(
      TasksCompanion(doneOn: drift.Value(isDone ? DateTime.now() : null)),
    );
  }

  // Task Organization
  Map<String, List<Task>> _categorizeTasks() {
    // Return cached categories if available
    if (_categorizedTasksCache != null) {
      return _categorizedTasksCache!;
    }

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final tomorrow = todayDate.add(const Duration(days: 1));

    final categorizedTasks = {
      "Today": <Task>[],
      "Previous": <Task>[],
      "Future": <Task>[],
      "Completed": <Task>[],
    };

    for (final task in _tasks) {
      if (task.doneOn != null) {
        categorizedTasks["Completed"]!.add(task);
      } else if (task.dueDate.isBefore(todayDate)) {
        categorizedTasks["Previous"]!.add(task);
      } else if (task.dueDate.isBefore(tomorrow)) {
        categorizedTasks["Today"]!.add(task);
      } else {
        categorizedTasks["Future"]!.add(task);
      }
    }

    // Cache the results
    _categorizedTasksCache = categorizedTasks;
    return categorizedTasks;
  }

  // UI Components
  Widget _taskTile(Task task) {
    final isCompleted = task.doneOn != null;
    final isOverdue = task.dueDate.isBefore(DateTime.now()) && !isCompleted;
    final hasBody = task.taskBody?.isNotEmpty ?? false;

    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onDoubleTap: () => _toggleTaskCompletion(task, !isCompleted),
          onLongPress: () => _showTaskBottomSheet(task, "Edit Task"),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration:
                Theme.of(
                  context,
                ).extension<TaskDecoration>()?.borderedContainer,
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Top row with checkbox, title, and date
                Row(
                  children: <Widget>[
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
                        style: Theme.of(
                          context,
                        ).extension<TaskDecoration>()?.taskTitleStyle.copyWith(
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
                      decoration:
                          Theme.of(
                            context,
                          ).extension<TaskDecoration>()?.dateTagContainer,
                      child: Text(
                        "${task.dueDate.day}/${task.dueDate.month}",
                        style: TextStyle(
                          color: isOverdue ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),

                // Body text with conditional divider
                if (hasBody)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 6,
                    ),
                    child: Text(
                      task.taskBody!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).extension<TaskDecoration>()?.taskBodyStyle.copyWith(
                        decoration:
                            isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    final categorizedTasks = _categorizeTasks();

    return ListView.builder(
      itemCount:
          categorizedTasks.entries
              .where((entry) => entry.value.isNotEmpty)
              .length,
      itemBuilder: (context, index) {
        final entry = categorizedTasks.entries
            .where((entry) => entry.value.isNotEmpty)
            .elementAt(index);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategoryHeader(entry.key),
            ...entry.value.map(_taskTile),
          ],
        );
      },
    );
  }

  // Bottom Sheet
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
                          top: 3.0,
                          right: 3,
                          left: 3,
                        ),
                        child: AppStyles.appBar(
                          label,
                          context,
                          actions:
                              task != null
                                  ? [
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: () {
                                        _deleteTask(task);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ]
                                  : [],
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        child: Column(
                          children: <Widget>[
                            TextField(
                              controller: _taskTitleController,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: const InputDecoration(
                                hintText: "Enter title task:",
                              ),
                            ),
                            const Gap(20),
                            TextFormField(
                              controller: _taskBodyController,
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText: "Enter task body:",
                              ),
                              keyboardType: TextInputType.multiline,
                            ),
                            const Gap(20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              spacing: 10,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: selectedDate,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2200),
                                    );
                                    if (picked != null) {
                                      setModalState(
                                        () => selectedDate = picked,
                                      );
                                    }
                                  },
                                  child: Text(
                                    "${selectedDate.day}/${selectedDate.month}",
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_taskTitleController.text.isNotEmpty) {
                                      if (task != null) {
                                        _updateTask(
                                          task,
                                          _taskTitleController.text,
                                          _taskBodyController.text,
                                          selectedDate,
                                        );
                                      } else {
                                        _addTask(
                                          _taskTitleController.text,
                                          _taskBodyController.text,
                                          selectedDate,
                                        );
                                      }
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text("Save"),
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
      floatingActionButton: AppStyles.floatingActionButton(
        Icons.add,
        () => _showTaskBottomSheet(null, "Add Task"),
      ),
    );
  }
}
