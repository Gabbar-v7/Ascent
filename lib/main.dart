import 'package:ascent/app_index.dart';
import 'package:ascent/services/drift_service.dart';
import 'package:ascent/visuals/components/utils/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize shared preferenes, method channel and drift Database
  final prefs = await SharedPreferences.getInstance();
  await DriftService.instance.init();

  // Lock the app to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(ProviderScope(
      overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
      child: AppIndex(),
    ));
  });
}
