import 'package:ascent/visuals/components/widgets/transition_builder.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BaseTheme {
  static const _kSeedColor = Colors.indigo;

  static final _kShimmerEffect = ShimmerEffect(
    highlightColor: Colors.white.withValues(alpha: 0.6),
    baseColor: Colors.grey.withValues(alpha: 0.3),
  );

  /// Custom transition for page routes
  static const _kPageTransitionTheme = PageTransitionsTheme(
    builders: {TargetPlatform.android: DefaultPageTransitionsBuilder()},
  );

  static TextTheme _buildTextTheme(ColorScheme colorScheme) => TextTheme(
        displayMedium: TextStyle(
          fontSize: 92,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
        displaySmall: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
        titleMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
        bodyMedium: TextStyle(
          fontSize: 17,
          color: colorScheme.onSurface,
        ),
        bodySmall: TextStyle(
          fontSize: 14,
          color: colorScheme.onSurfaceVariant,
        ),
      );

  static final materialColors = <String, MaterialColor>{
    'Amber': Colors.amber,
    'Blue': Colors.blue,
    'Blue Grey': Colors.blueGrey,
    'Brown': Colors.brown,
    'Cyan': Colors.cyan,
    'Deep Orange': Colors.deepOrange,
    'Deep Purple': Colors.deepPurple,
    'Green': Colors.green,
    'Grey': Colors.grey,
    'Indigo': Colors.indigo,
    'Light Blue': Colors.lightBlue,
    'Light Green': Colors.lightGreen,
    'Lime': Colors.lime,
    'Orange': Colors.orange,
    'Pink': Colors.pink,
    'Purple': Colors.purple,
    'Red': Colors.red,
    'Teal': Colors.teal,
    'Yellow': Colors.yellow,
  };

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
      extensions: [SkeletonizerConfigData(effect: _kShimmerEffect)],
    );
  }

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
      extensions: [SkeletonizerConfigData(effect: _kShimmerEffect)],
    );
  }
}
