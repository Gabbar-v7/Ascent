import 'package:ascent/l10n/generated/app_localizations.dart';
import 'package:ascent/utils/preference_provider.dart';
import 'package:ascent/visuals/components/themes.dart';
import 'package:ascent/visuals/home/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
    final preference = ref.watch(preferenceProvider);
    final ThemeMode themeMode = preference.themeMode.mode;
    final Color colorScheme = preference.colorScheme.color;
    final String languageCode = preference.language.code;

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
      ],

      home: HomeIndex(),
    );
  }
}
