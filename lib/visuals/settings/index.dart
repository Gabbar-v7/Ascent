import 'package:ascent/visuals/components/widgets/in_progress.dart';
import 'package:ascent/visuals/components/scaffold_shell.dart';
import 'package:ascent/visuals/settings/general/index.dart';
import 'package:flutter/material.dart';

class SettingsIndex extends StatefulWidget {
  const SettingsIndex({super.key});

  @override
  State<SettingsIndex> createState() => _SettingsIndexState();
}

class _SettingsIndexState extends State<SettingsIndex> {
  final List<NavigationItem> pages = [
    NavigationItem(
      icon: Icons.color_lens_outlined,
      navBarTitle: "General",
      appBarTitle: "Settings",
      body: GeneralIndex(),
    ),
    NavigationItem(
      icon: Icons.commit,
      navBarTitle: "Database",
      appBarTitle: "Settings",
      body: InProgressPage(),
    ),
    NavigationItem(
      icon: Icons.info_outline,
      navBarTitle: "About",
      appBarTitle: "Settings",
      body: InProgressPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ScaffoldShell(pages: pages);
  }
}
