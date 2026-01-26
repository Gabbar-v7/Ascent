import 'package:ascent/database/app_database.dart';
import 'package:ascent/l10n/generated/app_localizations.dart';
import 'package:ascent/services/drift_service.dart';
import 'package:ascent/visuals/components/utils/navigator_utils.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class TasksIndex extends StatefulWidget {
  const TasksIndex({super.key});

  @override
  State<TasksIndex> createState() => TasksIndexState();
}

class TasksIndexState extends State<TasksIndex> {
  final database = DriftService.instance.driftDB;
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();
  List<Task> _tasks = [];
  Map<String, List<Task>>? _categorizedTasksCache;

  final dateContainer = BoxDecoration(
    color: Colors.grey.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(8),
  );

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  @override
  void dispose() {
    _taskTitleController.dispose();
    _taskDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categorizedTasks = _categorizeTasks();

    return ListView.builder(
      itemCount: categorizedTasks.entries
          .where((e) => e.value.isNotEmpty)
          .length,
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
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onDoubleTap: () => _toggleTaskCompletion(task, !isCompleted),
        onLongPress: () => showTaskBottomSheet(task: task),
        borderRadius: BorderRadius.circular(12),
        child: Container(
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
                      task.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  const Gap(10),
                  Container(
                    decoration: dateContainer,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Text(
                      "${task.dueDate.day}/${task.dueDate.month}",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isOverdue ? Colors.red : Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              if (task.description?.isNotEmpty ?? false)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 18,
                    right: 20,
                    bottom: 6,
                  ),
                  child: Text(
                    task.description!,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, List<Task>> _categorizeTasks() {
    if (_categorizedTasksCache != null) return _categorizedTasksCache!;

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final tomorrow = todayDate.add(const Duration(days: 1));

    return _categorizedTasksCache = {
      AppLocalizations.of(context)!.tasks_label_today: _tasks
          .where(
            (task) =>
                task.doneOn == null &&
                !task.dueDate.isBefore(todayDate) &&
                task.dueDate.isBefore(tomorrow),
          )
          .toList(),
      AppLocalizations.of(context)!.tasks_label_previous: _tasks
          .where(
            (task) => task.doneOn == null && task.dueDate.isBefore(todayDate),
          )
          .toList(),
      AppLocalizations.of(context)!.tasks_label_future: _tasks
          .where(
            (task) => task.doneOn == null && !task.dueDate.isBefore(tomorrow),
          )
          .toList(),
      AppLocalizations.of(context)!.tasks_label_completed: _tasks
          .where((task) => task.doneOn != null)
          .toList(),
    };
  }

  void showTaskBottomSheet({Task? task}) {
    _taskTitleController.text = task?.title ?? "";
    _taskDescriptionController.text = task?.description ?? "";
    DateTime selectedDate = task?.dueDate ?? DateTime.now();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header AppBar
              Padding(
                padding: const EdgeInsets.only(top: 3, right: 3, left: 3),
                child: AppBar(
                  title: Text(
                    task != null
                        ? AppLocalizations.of(context)!.tasks_label_updateTasks
                        : AppLocalizations.of(context)!.tasks_label_createTasks,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  leading: IconButton(
                    onPressed: () => NavigatorUtils.popPage(context),
                    icon: Icon(Icons.arrow_back_ios_rounded),
                    tooltip: "Cancel",
                  ),
                  actions: task != null
                      ? <Widget>[
                          IconButton(
                            icon: const Icon(Icons.copy_outlined, size: 20),
                            tooltip: "Copy Task",
                            onPressed: () => Clipboard.setData(
                              ClipboardData(
                                text:
                                    "${task.title}\n"
                                    "    ${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}\n"
                                    "${task.description ?? AppLocalizations.of(context)!.tasks_label_noDescription}",
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 26),
                            tooltip: "Delete Task",
                            onPressed: () {
                              _deleteTask(task);
                              Navigator.pop(context);
                            },
                          ),
                          const Gap(5),
                        ]
                      : <Widget>[],
                  backgroundColor: Colors.transparent,
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    // Title Input
                    TextField(
                      controller: _taskTitleController,
                      textCapitalization: TextCapitalization.sentences,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(
                          context,
                        )!.tasks_input_title,
                      ),
                    ),
                    const Gap(16),

                    // Description Input
                    TextFormField(
                      controller: _taskDescriptionController,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 4,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(
                          context,
                        )!.tasks_input_description,
                      ),
                      keyboardType: TextInputType.multiline,
                    ),
                    const Gap(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: FilledButton(
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              backgroundColor: WidgetStatePropertyAll<Color>(
                                Theme.of(context).colorScheme.primaryContainer,
                              ),
                              foregroundColor: WidgetStatePropertyAll<Color>(
                                Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                              textStyle: WidgetStatePropertyAll(
                                Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2200),
                              );
                              if (picked != null && picked != selectedDate) {
                                setModalState(() {
                                  selectedDate = picked;
                                });
                              }
                            },
                            child: Text(
                              "${AppLocalizations.of(context)!.tasks_button_due}: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                            ),
                          ),
                        ),
                        const Gap(16),
                        Expanded(
                          child: FilledButton(
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              backgroundColor: WidgetStatePropertyAll<Color>(
                                Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                              ),
                              foregroundColor: WidgetStatePropertyAll<Color>(
                                Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                              textStyle: WidgetStatePropertyAll(
                                Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              AppLocalizations.of(context)!.common_comingSoon,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              backgroundColor: WidgetStatePropertyAll(
                                Theme.of(context).colorScheme.surface,
                              ),
                              foregroundColor: WidgetStatePropertyAll(
                                Theme.of(context).colorScheme.onSurface,
                              ),
                              textStyle: WidgetStatePropertyAll(
                                Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              AppLocalizations.of(context)!.tasks_button_cancel,
                            ),
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              backgroundColor: WidgetStatePropertyAll(
                                Theme.of(context).colorScheme.primary,
                              ),
                              foregroundColor: WidgetStatePropertyAll(
                                Theme.of(context).colorScheme.onPrimary,
                              ),
                              textStyle: WidgetStatePropertyAll(
                                Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            onPressed: () {
                              if (_taskTitleController.text.isNotEmpty) {
                                if (task != null) {
                                  _updateTask(
                                    task,
                                    _taskTitleController.text,
                                    _taskDescriptionController.text.isNotEmpty
                                        ? _taskDescriptionController.text
                                        : null,
                                    selectedDate,
                                  );
                                  Navigator.pop(context);
                                } else {
                                  _addTask(
                                    _taskTitleController.text,
                                    _taskDescriptionController.text.isNotEmpty
                                        ? _taskDescriptionController.text
                                        : null,
                                    selectedDate,
                                  );
                                  FocusScope.of(context).unfocus();
                                  _taskTitleController.clear();
                                  _taskDescriptionController.clear();
                                }
                              }
                            },
                            child: Text(
                              AppLocalizations.of(context)!.tasks_button_save,
                            ),
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

  Future<void> _fetchTasks() async {
    final current = DateTime.now();
    final todayDate = DateTime(current.year, current.month, current.day);
    final tomorrow = todayDate.add(const Duration(days: 1));

    final tasks =
        await (database.select(database.tasks)..where(
              (tbl) =>
                  tbl.doneOn.isNull() |
                  (tbl.doneOn.isBiggerThan(drift.Constant(todayDate)) &
                      tbl.doneOn.isSmallerThan(drift.Constant(tomorrow))),
            ))
            .get();

    tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    if (mounted) {
      setState(() {
        _tasks = tasks;
      });
      _categorizedTasksCache = null;
    }
  }

  Future<void> _addTask(
    String taskTitle,
    String? taskDescription,
    DateTime dueDate,
  ) async {
    await database
        .into(database.tasks)
        .insert(
          TasksCompanion.insert(
            title: taskTitle,
            description: drift.Value(taskDescription),
            dueDate: dueDate,
          ),
        );
    await _fetchTasks();
  }

  Future<void> _updateTask(
    Task task,
    String newTaskTitle,
    String? newTaskDescription,
    DateTime newDueDate,
  ) async {
    await (database.update(
      database.tasks,
    )..where((tbl) => tbl.id.equals(task.id))).write(
      TasksCompanion(
        title: drift.Value(newTaskTitle),
        description: drift.Value(newTaskDescription),
        dueDate: drift.Value(newDueDate),
      ),
    );
    await _fetchTasks();
  }

  Future<void> _toggleTaskCompletion(Task task, bool isDone) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    setState(() {
      if (index != -1) {
        _tasks[index] = task.copyWith(
          doneOn: isDone ? drift.Value(DateTime.now()) : drift.Value(null),
        );
      }
    });
    _categorizedTasksCache = null;

    await (database.update(
      database.tasks,
    )..where((tbl) => tbl.id.equals(task.id))).write(
      TasksCompanion(doneOn: drift.Value(isDone ? DateTime.now() : null)),
    );
  }

  Future<void> _deleteTask(Task task) async {
    await (database.delete(
      database.tasks,
    )..where((tbl) => tbl.id.equals(task.id))).go();
    await _fetchTasks();
  }
}
