import 'package:ascent/l10n/generated/app_localizations.dart';
import 'package:ascent/visuals/components/in_progress.dart';
import 'package:ascent/visuals/components/scaffold_shell.dart';
import 'package:ascent/visuals/home/home_menu.dart';
import 'package:ascent/visuals/home/notes/notes_index.dart';
import 'package:ascent/visuals/home/tasks/tasks_index.dart';
import 'package:ascent/visuals/home/timer/timer_index.dart';
import 'package:flutter/material.dart';

class HomeIndex extends StatefulWidget {
  const HomeIndex({super.key});

  @override
  State<HomeIndex> createState() => _HomeIndexState();
}

class _HomeIndexState extends State<HomeIndex> {
  late final List<NavigationItem> pages = [
    NavigationItem(
        icon: Icons.sticky_note_2_outlined,
        navBarTitle: "Notes",
        appBarTitle: "Notes",
        body: NotesIndex()),
    NavigationItem(
        icon: Icons.checklist_rounded,
        navBarTitle: AppLocalizations.of(context)!.tasks_page_title,
        appBarTitle: "Tasks",
        body: InProgressPage(),
        floatingActionButton: tasksFloatingActionButton()),
    NavigationItem(
      icon: Icons.timer_outlined,
      navBarTitle: "Timer",
      appBarTitle: "Pomodoro Timer",
      body: TimerIndex(),
      actions: timerActions(),
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldShell(
      pages: pages,
      auxiliaryDestination: NavigationDestination(
          icon: Icon(Icons.bubble_chart_outlined), label: "Menu"),
      onAuxiliaryTap: showAuxiliaryMenu,
    );
  }
}
