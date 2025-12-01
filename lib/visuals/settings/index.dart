import 'package:ascent/l10n/generated/app_localizations.dart';
import 'package:ascent/visuals/components/scaffold_shell.dart';
import 'package:ascent/visuals/settings/about/index.dart';
import 'package:ascent/visuals/settings/database/index.dart';
import 'package:ascent/visuals/settings/general/index.dart';
import 'package:flutter/material.dart';

class SettingsIndex extends StatefulWidget {
  const SettingsIndex({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsIndexState();
}

class _SettingsIndexState extends State<SettingsIndex> {
  late final List<NavigationItem> pages = [
    NavigationItem(
      icon: Icons.color_lens_outlined,
      navBarTitle: AppLocalizations.of(context)!.setting_general_navTitle,
      appBarTitle: AppLocalizations.of(context)!.setting_title,
      body: GeneralIndex(),
    ),
    NavigationItem(
      icon: Icons.commit,
      navBarTitle: AppLocalizations.of(context)!.setting_database_navTitle,
      appBarTitle: AppLocalizations.of(context)!.setting_title,
      body: DatabaseIndex(),
    ),
    NavigationItem(
      icon: Icons.info_outline,
      navBarTitle: AppLocalizations.of(context)!.setting_about_navTitle,
      appBarTitle: AppLocalizations.of(context)!.setting_title,
      body: AboutIndex(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ScaffoldShell(pages: pages);
  }
}
