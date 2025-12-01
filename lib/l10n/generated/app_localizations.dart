import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'Ascent'**
  String get common_appName;

  /// Label for features under development
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get common_comingSoon;

  /// Title of Tasks page
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks_title;

  /// Navigation label for Tasks
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks_navTitle;

  /// Label for create task form
  ///
  /// In en, this message translates to:
  /// **'Create Task:'**
  String get tasks_label_createTasks;

  /// Label for update task form
  ///
  /// In en, this message translates to:
  /// **'Update Task:'**
  String get tasks_label_updateTasks;

  /// Placeholder for task title input field
  ///
  /// In en, this message translates to:
  /// **'Task Title'**
  String get tasks_input_title;

  /// Placeholder for task description input field
  ///
  /// In en, this message translates to:
  /// **'Add Description (Optional)'**
  String get tasks_input_description;

  /// Button to set task due date
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get tasks_button_due;

  /// Cancel button in task form
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get tasks_button_cancel;

  /// Save button in task form
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get tasks_button_save;

  /// Label for today's tasks section
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get tasks_label_today;

  /// Label for previous/overdue tasks section
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get tasks_label_previous;

  /// Label for future tasks section
  ///
  /// In en, this message translates to:
  /// **'Future'**
  String get tasks_label_future;

  /// Label for completed tasks section
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get tasks_label_completed;

  /// Placeholder text when task has no description
  ///
  /// In en, this message translates to:
  /// **'No Description'**
  String get tasks_label_noDescription;

  /// Title of Timer page
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timer_title;

  /// Navigation label for Timer
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timer_navTitle;

  /// Label for focus timer mode
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get timer_label_focus;

  /// Title of Routine page
  ///
  /// In en, this message translates to:
  /// **'Routine'**
  String get routine_title;

  /// Navigation label for Routine
  ///
  /// In en, this message translates to:
  /// **'Routine'**
  String get routine_navTitle;

  /// Title of Menu page
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu_title;

  /// Navigation label for Menu
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu_navTitle;

  /// Title for features under development
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress_title;

  /// Description message for features under development
  ///
  /// In en, this message translates to:
  /// **'This page is currently under development.\nPlease check GitHub for updates.'**
  String get inProgress_description;

  /// Button to visit GitHub repository
  ///
  /// In en, this message translates to:
  /// **'Visit GitHub'**
  String get inProgress_button_visitGitHub;

  /// Title of Settings page
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get setting_title;

  /// Navigation label for General settings
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get setting_general_navTitle;

  /// Section label for appearance settings
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get setting_label_appearance;

  /// Label for theme mode setting
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get setting_themeMode;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get setting_themeMode_light;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get setting_themeMode_dark;

  /// System theme option (follows device setting)
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get setting_themeMode_system;

  /// Label for color scheme setting
  ///
  /// In en, this message translates to:
  /// **'Color Scheme'**
  String get setting_colorScheme;

  /// Section label for default settings
  ///
  /// In en, this message translates to:
  /// **'Defaults'**
  String get setting_label_defaults;

  /// Label for language setting
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get setting_language;

  /// Navigation label for Database settings
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get setting_database_navTitle;

  /// Section label for database settings
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get setting_label_database;

  /// Label for import database option
  ///
  /// In en, this message translates to:
  /// **'Import database'**
  String get setting_database_import;

  /// Description for import database feature
  ///
  /// In en, this message translates to:
  /// **'Import database from a file'**
  String get setting_database_importDescription;

  /// Label for export database option
  ///
  /// In en, this message translates to:
  /// **'Export database'**
  String get setting_database_export;

  /// Description for export database feature
  ///
  /// In en, this message translates to:
  /// **'Export database to a file'**
  String get setting_database_exportDescription;

  /// Navigation label for About page
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get setting_about_navTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
