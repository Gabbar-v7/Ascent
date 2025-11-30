import 'package:ascent/l10n/generated/app_localizations.dart';
import 'package:ascent/visuals/components/widgets/in_progress.dart';
import 'package:ascent/visuals/components/scaffold_shell.dart';
import 'package:ascent/visuals/home/menu.dart';
import 'package:ascent/visuals/home/tasks/index.dart';
import 'package:ascent/visuals/home/timer/index.dart';
import 'package:flutter/material.dart';

class HomeIndex extends StatefulWidget {
  const HomeIndex({super.key});

  @override
  State<HomeIndex> createState() => _HomeIndexState();
}

class _HomeIndexState extends State<HomeIndex> {
  late final List<NavigationItem> pages = [
    NavigationItem(
      icon: Icons.checklist_rounded,
      navBarTitle: AppLocalizations.of(context)!.tasks_page_title,
      appBarTitle: "Tasks",
      body: TasksIndex(),
    ),
    NavigationItem(
      icon: Icons.timer_outlined,
      navBarTitle: "Timer",
      appBarTitle: "Pomodoro Timer",
      body: TimerIndex(),
      actions: timerActions(),
    ),
    NavigationItem(
      icon: Icons.timer_outlined,
      navBarTitle: "Routine",
      appBarTitle: "Routine",
      body: InProgressPage(),
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
        icon: Icon(Icons.bubble_chart_outlined),
        label: "Menu",
      ),
      onAuxiliaryTap: showAuxiliaryMenu,
    );
  }
}
