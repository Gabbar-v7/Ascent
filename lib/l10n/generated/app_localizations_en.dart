// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get common_appName => 'Ascent';

  @override
  String get common_comingSoon => 'Coming Soon';

  @override
  String get tasks_title => 'Tasks';

  @override
  String get tasks_navTitle => 'Tasks';

  @override
  String get tasks_label_createTasks => 'Create Task:';

  @override
  String get tasks_label_updateTasks => 'Update Task:';

  @override
  String get tasks_input_title => 'Task Title';

  @override
  String get tasks_input_description => 'Add Description (Optional)';

  @override
  String get tasks_button_due => 'Due';

  @override
  String get tasks_button_cancel => 'Cancel';

  @override
  String get tasks_button_save => 'Save';

  @override
  String get tasks_label_today => 'Today';

  @override
  String get tasks_label_previous => 'Previous';

  @override
  String get tasks_label_future => 'Future';

  @override
  String get tasks_label_completed => 'Completed';

  @override
  String get tasks_label_noDescription => 'No Description';

  @override
  String get timer_title => 'Timer';

  @override
  String get timer_navTitle => 'Timer';

  @override
  String get timer_label_focus => 'Focus';

  @override
  String get routine_title => 'Routine';

  @override
  String get routine_navTitle => 'Routine';

  @override
  String get menu_title => 'Menu';

  @override
  String get menu_navTitle => 'Menu';

  @override
  String get inProgress_title => 'In Progress';

  @override
  String get inProgress_description =>
      'This page is currently under development.\nPlease check GitHub for updates.';

  @override
  String get inProgress_button_visitGitHub => 'Visit GitHub';

  @override
  String get setting_title => 'Settings';

  @override
  String get setting_general_navTitle => 'General';

  @override
  String get setting_label_appearance => 'Appearance';

  @override
  String get setting_themeMode => 'Theme Mode';

  @override
  String get setting_themeMode_light => 'Light';

  @override
  String get setting_themeMode_dark => 'Dark';

  @override
  String get setting_themeMode_system => 'System';

  @override
  String get setting_colorScheme => 'Color Scheme';

  @override
  String get setting_label_defaults => 'Defaults';

  @override
  String get setting_language => 'App language';

  @override
  String get setting_database_navTitle => 'Database';

  @override
  String get setting_label_database => 'Database';

  @override
  String get setting_database_import => 'Import database';

  @override
  String get setting_database_importDescription =>
      'Import database from a file';

  @override
  String get setting_database_export => 'Export database';

  @override
  String get setting_database_exportDescription => 'Export database to a file';

  @override
  String get setting_about_navTitle => 'About';
}
