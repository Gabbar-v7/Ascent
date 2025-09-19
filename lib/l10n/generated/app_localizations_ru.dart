// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get title_tasks => 'Задачи';

  @override
  String get title_notes => 'Заметка';

  @override
  String get title_timer => 'Таймер \"Помидор\"';

  @override
  String get title_menu => 'Меню';

  @override
  String get title_settings => 'Настройки';

  @override
  String get navigation_label_tasks => 'Задачи';

  @override
  String get navigation_label_notes => 'Заметка';

  @override
  String get navigation_label_timer => 'Таймер';

  @override
  String get navigation_label_menu => 'Меню';

  @override
  String get navigation_label_settings_general => 'Общее';

  @override
  String get navigation_label_settings_database => 'База данных';

  @override
  String get navigation_label_settings_about => 'Подробно';

  @override
  String get page_tasks_label_today => 'Сегодня';

  @override
  String get page_tasks_label_pending => 'Ожидают';

  @override
  String get page_tasks_label_future => 'Будущее';

  @override
  String get page_tasks_label_complete => 'Выполнен';

  @override
  String get page_tasks_title_create_task => 'Создание Задачи';

  @override
  String get page_tasks_title_update_task => 'Сохранить';

  @override
  String get page_tasks_form_title_placeholder => 'Название Задания';

  @override
  String get page_tasks_form_description_placeholder =>
      'Добавь описание (опционально)';

  @override
  String get page_tasks_form_label_due => 'До';

  @override
  String get page_tasks_form_label_cancel => 'Отменить';

  @override
  String get page_tasks_form_label_save => 'Сохранить';

  @override
  String get page_tasks_label_no_description => 'Описания нет';

  @override
  String get common_label_coming_soon => 'Скоро';
}
