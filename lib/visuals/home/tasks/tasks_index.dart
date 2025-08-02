import 'package:flutter/material.dart';

FloatingActionButton tasksFloatingActionButton() => FloatingActionButton(
      onPressed: () {},
      child: Icon(Icons.add),
    );

class TasksIndex extends StatefulWidget {
  const TasksIndex({super.key});

  @override
  State<TasksIndex> createState() => _TasksIndexState();
}

class _TasksIndexState extends State<TasksIndex> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_taskTile()],
    );
  }
}

Widget _taskTile() {
  return Card(
    child: ListTile(
      visualDensity: VisualDensity.compact,
      title: Text("data"),
      subtitle: Text(
        "data\nawd  awdawdasdfghjksdfghjksdfghjk\nawdawd",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      leading: Checkbox(value: true, onChanged: (value) {}),
    ),
  );
}
