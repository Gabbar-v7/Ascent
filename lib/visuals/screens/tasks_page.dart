import 'package:ascent/visuals/components/app_styles.dart';
import 'package:flutter/material.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  Widget _taskTile() {
    return GestureDetector(
      onTap: () {},
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

  void _showModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(maxWidth: double.infinity),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Text('asd'),
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
        _showModalBottomSheet();
      }),
    );
  }
}
