// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get title_tasks => 'कार्य';

  @override
  String get title_notes => 'नोट्स';

  @override
  String get title_timer => 'टाइमर';

  @override
  String get title_menu => 'मेनू';

  @override
  String get title_settings => 'सेटिंग्स';

  @override
  String get navigation_label_tasks => 'कार्य';

  @override
  String get navigation_label_notes => 'नोट्स';

  @override
  String get navigation_label_timer => 'टाइमर';

  @override
  String get navigation_label_menu => 'मेनू';

  @override
  String get navigation_label_settings_general => 'सामान्य';

  @override
  String get navigation_label_settings_database => 'डेटाबेस';

  @override
  String get navigation_label_settings_about => 'के बारे में';

  @override
  String get page_tasks_label_today => 'आज';

  @override
  String get page_tasks_label_pending => 'लंबित';

  @override
  String get page_tasks_label_future => 'भविष्य';

  @override
  String get page_tasks_title_create_task => 'कार्य बनाएं';

  @override
  String get page_tasks_title_update_task => 'कार्य अपडेट करें';

  @override
  String get page_tasks_form_title_placeholder => 'कार्य का शीर्षक';

  @override
  String get page_tasks_form_description_placeholder => 'विवरण जोड़ें (वैकल्पिक)';

  @override
  String get page_tasks_form_label_due => 'नियत तिथि';

  @override
  String get page_tasks_form_label_cancel => 'रद्द करें';

  @override
  String get page_tasks_form_label_save => 'सहेजें';
}
