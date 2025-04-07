import 'package:ascent/visuals/components/theme_extensions/task_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  appBarTheme: AppBarTheme(
    scrolledUnderElevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(size: 27),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  ),
  navigationBarTheme: NavigationBarThemeData(backgroundColor: Colors.white),
  bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),

  extensions: <ThemeExtension>[
    TaskDecoration(
      dateTagContainer: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      borderedContainer: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: .5), width: 1),
      ),
      taskBodyStyle: TextStyle(
        fontSize: 14,
        color: Colors.black,
        height: 1.4,
        decorationThickness: 4,
        decorationColor: Colors.black54,
      ),
    ),
  ],
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.white,
    brightness: Brightness.dark,
  ),
  appBarTheme: AppBarTheme(
    scrolledUnderElevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
    backgroundColor: Colors.black,
    iconTheme: IconThemeData(size: 27),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  ),
  navigationBarTheme: NavigationBarThemeData(backgroundColor: Colors.black),
  bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.black),

  extensions: <ThemeExtension>[
    TaskDecoration(
      dateTagContainer: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      borderedContainer: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3), width: 1),
      ),
      taskBodyStyle: TextStyle(
        fontSize: 14,
        color: Colors.grey[400],
        height: 1.4,
        decorationThickness: 4,
        decorationColor: Colors.grey[600],
      ),
    ),
  ],
);
