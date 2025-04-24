import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ascent/database/app_database.dart';
import 'package:ascent/visuals/screens/in_progress.dart';
import 'package:flutter/material.dart';
import 'package:ascent/visuals/screens/tasks/index.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';

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
  AppDatabase database = AppDatabase();

  StreamSubscription? _intentDataStreamSubscription;

  @override
  void initState() {
    super.initState();
    pageList;

    // For app in memory
    _intentDataStreamSubscription = FlutterSharingIntent.instance
        .getMediaStream()
        .listen((List<SharedFile> value) {
          _handleSharedFiles(value);
        });

    // For app cold start
    FlutterSharingIntent.instance.getInitialSharing().then((
      List<SharedFile> value,
    ) {
      _handleSharedFiles(value);
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription?.cancel();
    super.dispose();
  }

  void _handleSharedFiles(List<SharedFile> files) {
    for (var file in files) {
      if (file.value.toString().endsWith(".aso")) {
        dynamic fileContent = File(file.value.toString()).readAsStringSync();
        fileContent = jsonDecode(fileContent);
        database
            .into(database.tasks)
            .insert(
              TasksCompanion.insert(
                taskTitle: fileContent['taskTitle'],
                taskBody: drift.Value(fileContent['taskBody']),
                dueDate: DateTime.parse(fileContent['dueDate']),
              ),
            );
      }
    }
  }

  void _showModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(maxWidth: double.infinity),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(padding: EdgeInsets.all(10), child: InProgressPage());
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
