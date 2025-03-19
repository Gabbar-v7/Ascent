import 'package:ascent/visuals/components/app_style.dart';
import 'package:flutter/material.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  late final AppStyle appStyle = AppStyle(context: context);

  @override
  void initState() {
    super.initState();
    appStyle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appStyle.appBar("ToDo List"));
  }
}
