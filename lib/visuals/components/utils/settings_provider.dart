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
  english(name: "English", code: "en"),
  russian(name: "Русский", code: "ru");

  const AppLanguageEnum({required this.name, required this.code});

  /// User-friendly display name for the language
  final String name;

  /// ISO 639-1 language code
  final String code;
}

/// Immutable data class representing the application's settings state.
///
/// This class encapsulates all user preferences including theme mode,
/// color scheme, and language settings. It provides methods for serialization
/// and deserialization from SharedPreferences.
@immutable
class AppSettings {
  /// Creates an instance of AppSettings with the specified configuration.
  const AppSettings({
    required this.themeMode,
    required this.colorScheme,
    required this.languageCode,
  });

  /// The current theme mode setting (light, dark, or system)
  final AppThemeMode themeMode;

  /// The current color scheme setting
  final AppColorSchemeEnum colorScheme;

  /// The current language setting
  final AppLanguageEnum languageCode;

  // SharedPreferences keys for persistent storage
  static const String _keyThemeMode = "theme_mode";
  static const String _keyColorScheme = "color_scheme";
  static const String _keyLanguageCode = "language_code";

  // Default values for settings
  static const AppThemeMode _defaultThemeMode = AppThemeMode.system;
  static const AppColorSchemeEnum _defaultColorScheme = AppColorSchemeEnum.blue;
  static const AppLanguageEnum _defaultLanguage = AppLanguageEnum.english;

  /// Creates a copy of this AppSettings with optionally updated values.
  ///
  /// This method follows the immutable pattern by returning a new instance
  /// rather than modifying the existing one.
  ///
  /// Example:
  /// ```dart
  /// final newSettings = currentSettings.copyWith(
  ///   themeMode: AppThemeMode.dark,
  /// );
  /// ```
  AppSettings copyWith({
    AppThemeMode? themeMode,
    AppColorSchemeEnum? colorScheme,
    AppLanguageEnum? languageCode,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      colorScheme: colorScheme ?? this.colorScheme,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  /// Converts the settings to a Map for serialization.
  ///
  /// Returns a Map containing the enum indices for storage in SharedPreferences.
  Map<String, dynamic> toMap() {
    return {
      _keyThemeMode: themeMode.index,
      _keyColorScheme: colorScheme.index,
      _keyLanguageCode: languageCode.index,
    };
  }

  /// Creates an AppSettings instance from SharedPreferences.
  ///
  /// If any setting is not found in preferences, the corresponding default
  /// value will be used. This ensures the app always has valid settings
  /// even on first launch.
  ///
  /// Parameters:
  /// - [prefs]: SharedPreferences instance to read from
  ///
  /// Returns: AppSettings instance with values from preferences or defaults
  factory AppSettings.fromPrefs(SharedPreferences prefs) {
    try {
      final themeIndex = prefs.getInt(_keyThemeMode);
      final colorIndex = prefs.getInt(_keyColorScheme);
      final languageIndex = prefs.getInt(_keyLanguageCode);

      return AppSettings(
        themeMode: _getThemeModeByIndex(themeIndex),
        colorScheme: _getColorSchemeByIndex(colorIndex),
        languageCode: _getLanguageByIndex(languageIndex),
      );
    } catch (e) {
      // Log the error in a real app
      debugPrint('Error loading settings from preferences: $e');
      return AppSettings.defaultSettings();
    }
  }

  /// Creates an AppSettings instance with default values.
  ///
  /// Useful for fallback scenarios or initial app setup.
  factory AppSettings.defaultSettings() {
    return const AppSettings(
      themeMode: _defaultThemeMode,
      colorScheme: _defaultColorScheme,
      languageCode: _defaultLanguage,
    );
  }

  /// Safely retrieves a theme mode by index with fallback to default.
  static AppThemeMode _getThemeModeByIndex(int? index) {
    if (index == null || index < 0 || index >= AppThemeMode.values.length) {
      return _defaultThemeMode;
    }
    return AppThemeMode.values[index];
  }

  /// Safely retrieves a color scheme by index with fallback to default.
  static AppColorSchemeEnum _getColorSchemeByIndex(int? index) {
    if (index == null ||
        index < 0 ||
        index >= AppColorSchemeEnum.values.length) {
      return _defaultColorScheme;
    }
    return AppColorSchemeEnum.values[index];
  }

  /// Safely retrieves a language by index with fallback to default.
  static AppLanguageEnum _getLanguageByIndex(int? index) {
    if (index == null || index < 0 || index >= AppLanguageEnum.values.length) {
      return _defaultLanguage;
    }
    return AppLanguageEnum.values[index];
  }

  /// Saves all current settings to SharedPreferences.
  ///
  /// This method persists all settings atomically. If any save operation
  /// fails, the error is logged but doesn't prevent other settings from
  /// being saved.
  ///
  /// Parameters:
  /// - [prefs]: SharedPreferences instance to save to
  ///
  /// Returns: Future that completes when all save operations are done
  Future<void> saveToPrefs(SharedPreferences prefs) async {
    try {
      final futures = <Future<bool>>[
        prefs.setInt(_keyThemeMode, themeMode.index),
        prefs.setInt(_keyColorScheme, colorScheme.index),
        prefs.setInt(_keyLanguageCode, languageCode.index),
      ];

      await Future.wait(futures);
    } catch (e) {
      // Log the error in a real app
      debugPrint('Error saving settings to preferences: $e');
      rethrow;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettings &&
        other.themeMode == themeMode &&
        other.colorScheme == colorScheme &&
        other.languageCode == languageCode;
  }

  @override
  int get hashCode {
    return Object.hash(themeMode, colorScheme, languageCode);
  }

  @override
  String toString() {
    return 'AppSettings('
        'themeMode: $themeMode, '
        'colorScheme: $colorScheme, '
        'languageCode: $languageCode'
        ')';
  }
}

/// StateNotifier that manages the application settings state.
///
/// This class handles all settings-related state changes and persistence.
/// It ensures that any changes to settings are immediately saved to
/// SharedPreferences and the UI is notified of the changes.
class SettingsNotifier extends StateNotifier<AppSettings> {
  /// Creates a SettingsNotifier with the given SharedPreferences instance.
  ///
  /// The initial state is loaded from SharedPreferences, falling back to
  /// default values if no saved settings are found.
  SettingsNotifier(this._prefs) : super(AppSettings.fromPrefs(_prefs));

  final SharedPreferences _prefs;

  /// Updates the theme mode setting.
  ///
  /// This method creates a new state with the updated theme mode and
  /// persists the change to SharedPreferences.
  ///
  /// Parameters:
  /// - [mode]: The new theme mode to set
  Future<void> setThemeMode(AppThemeMode mode) async {
    final newSettings = state.copyWith(themeMode: mode);
    state = newSettings;

    try {
      await _prefs.setInt('theme_mode', mode.index);
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
  }

  /// Updates the color scheme setting.
  ///
  /// This method creates a new state with the updated color scheme and
  /// persists the change to SharedPreferences.
  ///
  /// Parameters:
  /// - [colorScheme]: The new color scheme to set
  Future<void> setColorScheme(AppColorSchemeEnum colorScheme) async {
    final newSettings = state.copyWith(colorScheme: colorScheme);
    state = newSettings;

    try {
      await _prefs.setInt('color_scheme', colorScheme.index);
    } catch (e) {
      debugPrint('Error saving color scheme: $e');
    }
  }

  /// Updates the language setting.
  ///
  /// This method creates a new state with the updated language and
  /// persists the change to SharedPreferences.
  ///
  /// Parameters:
  /// - [language]: The new language to set
  Future<void> setLanguage(AppLanguageEnum language) async {
    final newSettings = state.copyWith(languageCode: language);
    state = newSettings;

    try {
      await _prefs.setInt('language_code', language.index);
    } catch (e) {
      debugPrint('Error saving language: $e');
    }
  }

  /// Resets all settings to their default values.
  ///
  /// This is useful for providing a "reset to defaults" functionality
  /// in the settings UI.
  Future<void> resetToDefaults() async {
    final defaultSettings = AppSettings.defaultSettings();
    state = defaultSettings;

    try {
      await defaultSettings.saveToPrefs(_prefs);
    } catch (e) {
      debugPrint('Error resetting settings to defaults: $e');
    }
  }
}

/// Provider for SharedPreferences instance.
///
/// This should be overridden in main app initialization with the
/// actual SharedPreferences instance.
final sharedPrefsProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(
    'SharedPreferences provider must be overridden in main()',
  ),
);

/// Provider for the settings state notifier and current settings.
///
/// This provider manages the app settings state and provides access to
/// both the current settings and methods to update them.
///
/// Usage:
/// ```dart
/// // To read current settings
/// final settings = ref.watch(settingsNotifierProvider);
///
/// // To update settings
/// ref.read(settingsNotifierProvider.notifier).setThemeMode(AppThemeMode.dark);
/// ```
final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>(
  (ref) => SettingsNotifier(ref.watch(sharedPrefsProvider)),
);

/// Convenience provider for accessing just the current theme mode.
///
/// This is useful when you only need the theme mode and want to minimize
/// rebuilds when other settings change.
final themeModeProvider = Provider<ThemeMode>(
  (ref) => ref.watch(settingsNotifierProvider).themeMode.mode,
);

/// Convenience provider for accessing just the current color scheme.
///
/// This is useful when you only need the color scheme and want to minimize
/// rebuilds when other settings change.
final colorSchemeProvider = Provider<MaterialColor>(
  (ref) => ref.watch(settingsNotifierProvider).colorScheme.color,
);

/// Convenience provider for accessing just the current language code.
///
/// This is useful for internationalization when you only need the language
/// and want to minimize rebuilds when other settings change.
final languageCodeProvider = Provider<String>(
  (ref) => ref.watch(settingsNotifierProvider).languageCode.code,
);
