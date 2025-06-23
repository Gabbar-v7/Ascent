import 'package:ascent/l10n/generated/app_localizations.dart';
import 'package:ascent/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Index extends ConsumerStatefulWidget {
  const Index({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IndexState();
}

class _IndexState extends ConsumerState<Index> {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      /// Themes
      themeAnimationCurve: Curves.ease,
      themeMode: ThemeMode.system,

      /// Localization
      locale: Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: HomePage(),
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
//     themeMode: ThemeMode.values[themeMode.index],
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
