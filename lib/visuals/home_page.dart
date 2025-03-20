import 'package:ascent/visuals/screens/in_progress.dart';
import 'package:flutter/material.dart';
import 'package:ascent/visuals/screens/tasks_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _pageIndex = 0;
  late List<Widget> pageList = [
    const TasksPage(),
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
        return Padding(padding: EdgeInsets.all(20), child: InProgressPage());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _pageIndex, children: pageList),
      bottomNavigationBar: NavigationBar(
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.checklist), label: "Tasks"),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined, size: 23),
            label: "Timer",
          ),
          NavigationDestination(
            icon: Icon(Icons.sticky_note_2_outlined, size: 21),
            label: "Notes",
          ),
          NavigationDestination(
            icon: Icon(Icons.bubble_chart_outlined, size: 27),
            label: "Menu",
          ),
        ],
        onDestinationSelected: (value) {
          if (value == 3) {
            _showModalBottomSheet();
          } else {
            setState(() {
              _pageIndex = value;
            });
          }
        },
        selectedIndex: _pageIndex,
      ),
    );
  }
}
