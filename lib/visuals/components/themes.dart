import 'package:ascent/visuals/components/widgets/transition_builder.dart';
import 'package:flutter/material.dart';

class BaseTheme {
  static const _kSeedColor = Colors.indigo;

  /// Custom transition for page routes
  static const _kPageTransitionTheme = PageTransitionsTheme(
    builders: {TargetPlatform.android: DefaultPageTransitionsBuilder()},
  );

  static final _kInputDecorationTheme = InputDecorationTheme(
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );

  static TextTheme _buildTextTheme(ColorScheme colorScheme) => TextTheme(
    // Display styles - for large headlines and hero text
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      height: 1.12,
      color: colorScheme.onSurface,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.16,
      color: colorScheme.onSurface,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.22,
      color: colorScheme.onSurface,
    ),

    // Headline styles - for section headers and important titles
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.25,
      color: colorScheme.onSurface,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.29,
      color: colorScheme.onSurface,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.33,
      color: colorScheme.onSurface,
    ),

    // Title styles - for card titles, dialog headers, toolbar titles
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      letterSpacing: 0,
      height: 1.27,
      color: colorScheme.onSurface,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      height: 1.50,
      color: colorScheme.onSurface,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
      color: colorScheme.onSurface,
    ),

    // Label styles - for buttons, tabs, form labels
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.1,
      height: 1.43,
      color: colorScheme.onSurface,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.33,
      color: colorScheme.onSurface,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.45,
      color: colorScheme.onSurfaceVariant,
    ),

    // Body styles - for main content text
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
      height: 1.50,
      color: colorScheme.onSurface,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.43,
      color: colorScheme.onSurface,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
      color: colorScheme.onSurfaceVariant,
    ),
  );

  static ThemeData lightTheme({Color? seedColor}) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor ?? _kSeedColor,
      brightness: Brightness.light,
    );

    return ThemeData.from(
      useMaterial3: true,
      colorScheme: colorScheme,
    ).copyWith(
      pageTransitionsTheme: _kPageTransitionTheme,
      textTheme: _buildTextTheme(colorScheme),
      inputDecorationTheme: _kInputDecorationTheme,
    );
  }

  static ThemeData darkTheme({Color? seedColor}) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor ?? _kSeedColor,
      brightness: Brightness.dark,
    );

    return ThemeData.from(
      useMaterial3: true,
      colorScheme: colorScheme,
    ).copyWith(
      pageTransitionsTheme: _kPageTransitionTheme,
      textTheme: _buildTextTheme(colorScheme),
      inputDecorationTheme: _kInputDecorationTheme,
    );
  }
}
