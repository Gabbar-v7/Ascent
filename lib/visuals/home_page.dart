import 'package:ascent/visuals/screens/in_progress.dart';
import 'package:flutter/material.dart';
import 'package:ascent/visuals/components/app_style.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:ascent/visuals/screens/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late final AppStyle appStyle = AppStyle(context: context);

  int _pageIndex = 0;
  late List<Widget> pageList = [
    const ToDoPage(),
    InProgressPage(),
    InProgressPage(),
  ];

  @override
  void initState() {
    super.initState();
    pageList;
  }

  void _showModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(maxWidth: double.infinity),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return const Padding(
          padding: EdgeInsets.all(20),
          child: InProgressPage(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _pageIndex, children: pageList),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FluentIcons.apps_list_detail_20_regular, size: 25),
            activeIcon: Icon(FluentIcons.apps_list_detail_20_filled, size: 25),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(FluentIcons.timer_48_regular, size: 23),
            activeIcon: Icon(FluentIcons.timer_48_filled),
            label: "Pomodoro Timer",
          ),
          BottomNavigationBarItem(
            icon: Icon(FluentIcons.edit_12_regular, size: 21),
            activeIcon: Icon(FluentIcons.edit_12_filled, size: 21),
            label: "Notes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bubble_chart, size: 27),
            label: "Menu",
          ),
        ],
        onTap: (value) {
          if (value == 3) {
            _showModalBottomSheet();
          } else {
            setState(() {
              _pageIndex = value;
            });
          }
        },
        currentIndex: _pageIndex,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        enableFeedback: false,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
