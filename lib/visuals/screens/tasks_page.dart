import 'package:ascent/visuals/components/app_styles.dart';
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
  final TextEditingController _taskController = TextEditingController();
  List<Task> _tasks = [];
  Map<String, List<Task>>? _categorizedTasksCache;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  @override
  void dispose() {
    _taskController.dispose();
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
              (tbl.doneOn.isBiggerThan(drift.Constant(todayDate)) |
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

  Future<void> _addTask(String taskName, DateTime dueDate) async {
    await database
        .into(database.tasks)
        .insert(TasksCompanion.insert(task: taskName, dueDate: dueDate));
    await _fetchTasks();
  }

  Future<void> _updateTask(
    Task task,
    String newTaskName,
    DateTime newDueDate,
  ) async {
    await (database.update(database.tasks)
      ..where((tbl) => tbl.id.equals(task.id))).write(
      TasksCompanion(
        task: drift.Value(newTaskName),
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
          task: task.task,
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
  Widget _buildTaskTile(Task task) {
    final isCompleted = task.doneOn != null;
    return RepaintBoundary(
      child: GestureDetector(
        onLongPress: () => _showTaskBottomSheet(task, "Edit Task"),
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            _toggleTaskCompletion(task, !isCompleted);
          }
        },
        child: ListTile(
          leading: Checkbox(
            value: isCompleted,
            onChanged: (value) => _toggleTaskCompletion(task, value!),
          ),
          title: Text(
            task.task,
            style:
                isCompleted
                    ? const TextStyle(decoration: TextDecoration.lineThrough)
                    : null,
          ),
          trailing: Text(
            "${task.dueDate.day}/${task.dueDate.month}",
            style: TextStyle(
              color:
                  task.dueDate.isBefore(DateTime.now()) && !isCompleted
                      ? Colors.red
                      : Colors.grey,
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
            ...entry.value.map(_buildTaskTile),
          ],
        );
      },
    );
  }

  // Bottom Sheet
  void _showTaskBottomSheet(Task? task, String label) {
    _taskController.text = task?.task ?? "";
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
                      AppStyles.appBar(
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
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        child: Column(
                          children: <Widget>[
                            TextField(
                              controller: _taskController,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: const InputDecoration(
                                hintText: "Enter Task:",
                              ),
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
                                    if (_taskController.text.isNotEmpty) {
                                      if (task != null) {
                                        _updateTask(
                                          task,
                                          _taskController.text,
                                          selectedDate,
                                        );
                                      } else {
                                        _addTask(
                                          _taskController.text,
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
      appBar: AppStyles.appBar("ToDo List", context),
      body: _buildTaskList(),
      floatingActionButton: AppStyles.floatingActionButton(
        Icons.add,
        () => _showTaskBottomSheet(null, "Add Task"),
      ),
    );
  }
}
