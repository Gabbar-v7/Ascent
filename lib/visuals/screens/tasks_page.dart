import 'package:ascent/database/tables/tasks_table.dart';
import 'package:ascent/visuals/components/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ascent/database/app_database.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final database = AppDatabase();
  TextEditingController controller = TextEditingController();
  late List<Task> allTasks;

  void initialise() async {
    await database
        .into(database.tasks)
        .insert(
          TasksCompanion.insert(
            task: 'todo: finish drift setup',
            dueDate: DateTime.now(),
          ),
        );
    allTasks = await database.select(database.tasks).get();
  }

  @override
  void initState() {
    super.initState();
    initialise();
  }

  Widget _taskTile() {
    return GestureDetector(
      onLongPress: () {
        print("asdasdad");
      },
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          print("Right");
        } else if (details.primaryVelocity! < 0) {
          print("Left");
        }
      },
      child: ListTile(
        leading: Checkbox(value: false, onChanged: (value) {}),
        title: Text("Hello World!"),
        trailing: Text("21/02"),
      ),
    );
  }

  Widget pageBody() {
    return ListView.separated(
      itemCount: 20, // Number of items
      itemBuilder: (context, index) {
        return _taskTile();
      },
      separatorBuilder: (context, index) {
        return Divider(indent: 20, endIndent: 20); // Custom separator
      },
    );
  }

  void _showModalBottomSheet(Task task, String label) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppStyles.appBar(label, context),
              TextField(
                controller: ,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(hintText: "Enter Task:"),
              ),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 20,
                children: <Widget>[
                  ElevatedButton(onPressed: () {}, child: Text("27/02")),
                  ElevatedButton.icon(
                    onPressed: () {},
                    label: Icon(Icons.send),
                  ),
                ],
              ),
              const Gap(30),
              Gap(MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
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
         }),
    );
  }
}
