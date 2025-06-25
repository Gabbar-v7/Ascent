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
    return Container(
      child: _taskTile(),
    );
  }
}

Widget _taskTile() {
  return Card(
    child: ListTile(
      title: Text("data"),
      subtitle: Text("data\n\nawdawd"),
      leading: Checkbox(value: true, onChanged: (value) {}),
    ),
  );
}
