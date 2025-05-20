import 'package:ascent/services/drift_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ascent/visuals/index.dart';
import 'package:ascent/visuals/components/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DriftService.instance.init();

  // Lock the app to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ascent',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
