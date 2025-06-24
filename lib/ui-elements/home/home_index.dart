import 'package:ascent/ui-elements/components/scaffold_shell.dart';
import 'package:ascent/ui-elements/home/notes.dart';
import 'package:flutter/material.dart';

class HomeIndex extends StatefulWidget {
  const HomeIndex({super.key});

  @override
  State<HomeIndex> createState() => _HomeIndexState();
}

class _HomeIndexState extends State<HomeIndex> {
  final List<NavigationItem> pages = [
    NavigationItem(
        icon: Icons.checklist_rounded,
        navBarTitle: "Tasks",
        appBarTitle: "Tasks",
        body: Text("data")),
    NavigationItem(
        icon: Icons.timer_outlined,
        navBarTitle: "Timer",
        appBarTitle: "Pomodoro Timer",
        body: Container()),
    NavigationItem(
        icon: Icons.sticky_note_2_outlined,
        navBarTitle: "Notes",
        appBarTitle: "Notes",
        body: NotesIndex()),
    NavigationItem(
        icon: Icons.bubble_chart_outlined,
        navBarTitle: "Menu",
        appBarTitle: "Menu",
        body: Container())
  ];

  @override
  Widget build(BuildContext context) {
    return ScaffoldShell(pages: pages);
  }
}
