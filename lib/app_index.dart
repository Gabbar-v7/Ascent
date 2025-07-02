import 'package:ascent/l10n/generated/app_localizations.dart';
import 'package:ascent/visuals/components/utils/settings_provider.dart';
import 'package:ascent/visuals/components/themes.dart';
import 'package:ascent/visuals/home/home_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppIndex extends ConsumerStatefulWidget {
  const AppIndex({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppIndexState();
}

class _AppIndexState extends ConsumerState<AppIndex> {
  @override
  void initState() {
    super.initState();

    /// Apply transparent color to system ui background
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          systemNavigationBarContrastEnforced: true,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsNotifierProvider);
    final ThemeMode themeMode = settings.themeMode.mode;
    final Color colorScheme = settings.colorScheme.color;
    final String languageCode = settings.languageCode.code;

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      /// Themes
      themeAnimationCurve: Curves.ease,
      themeMode: themeMode,
      darkTheme: BaseTheme.darkTheme(seedColor: colorScheme),
      theme: BaseTheme.lightTheme(seedColor: colorScheme),

      /// Localization
      locale: Locale(languageCode),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],

      home: HomeIndex(),
    );
  }
}

// Widget build(BuildContext context) {
//   final themeMode = ref.watch(settingsProvider.select((v) => v.themeMode));

//   final accentColor = ref.watch(settingsProvider.select((v) => v.accentColor));

//   final localeCode = ref.watch(settingsProvider.select((v) => v.localeCode));

//   final useAmoledDark =
//       ref.watch(settingsProvider.select((v) => v.useAmoledDark));

//   final useDynamicColors =
//       ref.watch(settingsProvider.select((v) => v.useDynamicColors));

//   return MaterialApp(
//     debugShowCheckedModeBanner: false,

//     /// Themes
//     themeAnimationCurve: Curves.ease,
//     themeMode: ThemeMode.values[themeMode.AppIndex],
//     darkTheme: AppTheme.darkTheme(
//       isAmoled: useAmoledDark,
//       seedColor: useDynamicColors
//           ? dark?.primary
//           : AppTheme.materialColors[accentColor],
//     ),
//     theme: AppTheme.lightTheme(
//       seedColor: useDynamicColors
//           ? light?.primary
//           : AppTheme.materialColors[accentColor],
//     ),

//     /// Localization
//     locale: Locale(localeCode),
//     supportedLocales: AppLocalizations.supportedLocales,
//     localizationsDelegates: const [
//       AppLocalizations.delegate,
//       GlobalMaterialLocalizations.delegate,
//       GlobalWidgetsLocalizations.delegate,
//       GlobalCupertinoLocalizations.delegate,
//     ],

//     /// Navigation
//     initialRoute: AppRoutes.rootSplashPath,
//     routes: AppRoutes.routes,
//     navigatorKey: NavigationService.navigatorKey,
//     navigatorObservers: [AppRoutesObserver.instance],
//   );
// }
