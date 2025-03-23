import 'package:ascent/visuals/components/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ascent/database/app_database.dart';
import 'package:drift/drift.dart' as drift;

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final database = AppDatabase();
  TextEditingController controller = TextEditingController();
  List<Task> allTasks = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  /// Fetch tasks from the database and update the UI
  Future<void> fetchTasks() async {
    final tasks = await database.select(database.tasks).get();
    tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate)); // Sort by date

    setState(() {
      allTasks = tasks;
    });
  }

  /// Insert a new task into the database
  Future<void> addTask(String taskName, DateTime dueDate) async {
    await database
        .into(database.tasks)
        .insert(TasksCompanion.insert(task: taskName, dueDate: dueDate));
    fetchTasks(); // Refresh the UI
  }

  /// Update task completion status
  Future<void> toggleTaskCompletion(Task task, bool isDone) async {
    await (database.update(database.tasks)..where(
      (tbl) => tbl.id.equals(task.id),
    )).write(TasksCompanion(isDone: drift.Value(isDone)));
    fetchTasks();
  }

  /// Categorize tasks
  Map<String, List<Task>> categorizeTasks() {
    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day); // Remove time part
    DateTime tomorrow = today.add(Duration(days: 1));

    List<Task> todayTasks = [];
    List<Task> previousTasks = [];
    List<Task> futureTasks = [];
    List<Task> completedTasks = [];

    for (var task in allTasks) {
      if (task.isDone) {
        completedTasks.add(task);
      } else if (task.dueDate.isBefore(today)) {
        previousTasks.add(task);
      } else if (task.dueDate.isBefore(tomorrow)) {
        todayTasks.add(task);
      } else {
        futureTasks.add(task);
      }
    }

    return {
      "Today": todayTasks,
      "Previous": previousTasks,
      "Future": futureTasks,
      "Completed": completedTasks,
    };
  }

  Widget _taskTile(Task task) {
    return GestureDetector(
      onLongPress: () {
        _showModalBottomSheet(task, "Edit Task");
      },
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          // Right swipe: Toggle isDone
          toggleTaskCompletion(task, !task.isDone);
        }
      },
      child: ListTile(
        leading: Checkbox(
          value: task.isDone,
          onChanged: (value) {
            toggleTaskCompletion(task, value!);
          },
        ),
        title: Text(
          task.task,
          style:
              task.isDone
                  ? TextStyle(decoration: TextDecoration.lineThrough)
                  : null,
        ),
        trailing: Text("${task.dueDate.day}/${task.dueDate.month}"),
      ),
    );
  }

  Widget pageBody() {
    final categorizedTasks = categorizeTasks();

    return ListView(
      children:
          categorizedTasks.entries
              .where((entry) => entry.value.isNotEmpty) // Hide empty categories
              .map(
                (entry) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...entry.value.map((task) => _taskTile(task)),
                  ],
                ),
              )
              .toList(),
    );
  }

  void _showModalBottomSheet(Task? task, String label) {
    controller.text = task?.task ?? "";
    DateTime selectedDate = task?.dueDate ?? DateTime.now();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AppStyles.appBar(label, context),
                  TextField(
                    controller: controller,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(hintText: "Enter Task:"),
                  ),
                  const Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2200),
                          );
                          if (picked != null) {
                            setModalState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                        child: Text(
                          "${selectedDate.day}/${selectedDate.month}",
                        ),
                      ),
                      const Gap(10),
                      ElevatedButton(
                        onPressed: () {
                          if (controller.text.isNotEmpty) {
                            addTask(controller.text, selectedDate);
                            Navigator.pop(context);
                          }
                        },
                        child: Text("Save"),
                      ),
                    ],
                  ),
                  const Gap(30),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppStyles.appBar("ToDo List", context),
      body: pageBody(),
      floatingActionButton: AppStyles.floatingActionButton(Icons.add, () {
        _showModalBottomSheet(null, "Add Task");
      }),
    );
  }
}
