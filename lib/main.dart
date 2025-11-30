import 'package:ascent/index.dart';
import 'package:ascent/services/drift_service.dart';
import 'package:ascent/utils/preference_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DriftService.instance.init();
  await AppPreferencesService.instance.init();

  // Lock the app to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(ProviderScope(child: AppIndex()));
  });
}
