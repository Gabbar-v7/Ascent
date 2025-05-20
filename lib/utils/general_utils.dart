import 'dart:math';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

String generateRandomString(int length) {
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final rand = Random.secure();
  return List.generate(
    length,
    (index) => chars[rand.nextInt(chars.length)],
  ).join();
}

/// Get the SQLITE database file path: /data/user/0/io.insane.ascent/app_flutter/database.sqlite
Future<String> getDatabasePath() async => path.join(
  (await getApplicationDocumentsDirectory()).path,
  'database.sqlite',
);
