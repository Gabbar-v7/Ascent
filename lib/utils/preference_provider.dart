import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Enumeration of available theme modes for the application.
///
/// Provides three standard Flutter theme modes with user-friendly names.
enum AppThemeMode {
  light(name: 'Light', mode: ThemeMode.light),
  dark(name: 'Dark', mode: ThemeMode.dark),
  system(name: 'System', mode: ThemeMode.system);

  const AppThemeMode({required this.name, required this.mode});

  /// User-friendly display name for the theme mode
  final String name;

  /// Corresponding Flutter ThemeMode
  final ThemeMode mode;
}

/// Enumeration of available color schemes for the application.
///
/// Provides a comprehensive set of Material Design color options
/// that can be used throughout the app for consistent theming.
enum AppColorSchemeEnum {
  amber(name: 'Amber', color: Colors.amber),
  blue(name: 'Blue', color: Colors.blue),
  blueGrey(name: 'Blue Grey', color: Colors.blueGrey),
  brown(name: 'Brown', color: Colors.brown),
  cyan(name: 'Cyan', color: Colors.cyan),
  deepOrange(name: 'Deep Orange', color: Colors.deepOrange),
  deepPurple(name: 'Deep Purple', color: Colors.deepPurple),
  green(name: 'Green', color: Colors.green),
  grey(name: 'Grey', color: Colors.grey),
  indigo(name: 'Indigo', color: Colors.indigo),
  lightBlue(name: 'Light Blue', color: Colors.lightBlue),
  lightGreen(name: 'Light Green', color: Colors.lightGreen),
  lime(name: 'Lime', color: Colors.lime),
  orange(name: 'Orange', color: Colors.orange),
  pink(name: 'Pink', color: Colors.pink),
  purple(name: 'Purple', color: Colors.purple),
  red(name: 'Red', color: Colors.red),
  teal(name: 'Teal', color: Colors.teal),
  yellow(name: 'Yellow', color: Colors.yellow);

  const AppColorSchemeEnum({required this.name, required this.color});

  /// User-friendly display name for the color
  final String name;

  /// Material color for the theme
  final MaterialColor color;
}

/// Enumeration of supported languages in the application.
///
/// Currently supports English only, but designed to be easily extensible
/// for additional languages in the future.
enum AppLanguageEnum {
  english(name: "English", code: "en");

  const AppLanguageEnum({required this.name, required this.code});

  /// User-friendly display name for the language
  final String name;

  /// ISO 639-1 language code
  final String code;
}

/// Strongly-typed preference keys.
enum PreferenceKey {
  themeMode(string: "theme_mode"),
  colorScheme(string: "color_scheme"),
  languageCode(string: "language_code");

  const PreferenceKey({required this.string});

  final String string;
}

/// AppPreference Service (singleton)
///
/// Provides:
///  - Centralized access to SharedPreferences
///  - Type-safe APIs using enums instead of raw strings
///  - Clean getters/setters for common preference types
class AppPreferencesService {
  AppPreferencesService._();

  static final AppPreferencesService instance = AppPreferencesService._();

  late final SharedPreferences _prefs;

  /// MUST be called once at startup: e.g., in main()
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Preference getters
  AppThemeMode get themeMode {
    int index = _prefs.getInt(PreferenceKey.themeMode.string) ?? 2;
    return AppThemeMode.values[index];
  }

  AppColorSchemeEnum get colorScheme {
    int index = _prefs.getInt(PreferenceKey.colorScheme.string) ?? 1;
    return AppColorSchemeEnum.values[index];
  }

  AppLanguageEnum get language {
    int index = _prefs.getInt(PreferenceKey.languageCode.string) ?? 0;
    return AppLanguageEnum.values[index];
  }
}

class AppPreferencesNotifier extends Notifier<AppPreferencesService> {
  @override
  AppPreferencesService build() {
    return AppPreferencesService.instance;
  }

  // Preference setters
  set themeMode(AppThemeMode mode) {
    state._prefs.setInt(PreferenceKey.themeMode.string, mode.index);
    ref.notifyListeners();
  }

  set colorScheme(AppColorSchemeEnum colorScheme) {
    state._prefs.setInt(PreferenceKey.colorScheme.string, colorScheme.index);
    ref.notifyListeners();
  }

  set language(AppLanguageEnum language) {
    state._prefs.setInt(PreferenceKey.languageCode.string, language.index);
    ref.notifyListeners();
  }
}

final preferenceProvider =
    NotifierProvider<AppPreferencesNotifier, AppPreferencesService>(
      () => AppPreferencesNotifier(),
    );
