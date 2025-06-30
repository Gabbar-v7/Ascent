import 'package:drift/drift.dart';
import 'dart:convert';

import 'package:flutter_quill/quill_delta.dart';

// Store Flutter Quill's Delta as BLOB
class QuillDeltaConverter extends TypeConverter<Delta, Uint8List> {
  const QuillDeltaConverter();

  @override
  Delta fromSql(Uint8List fromDb) {
    try {
      // Convert Uint8List back to string
      final jsonString = utf8.decode(fromDb);

      // Parse JSON and create Delta
      final Map<String, dynamic> deltaJson = json.decode(jsonString);

      // Create Delta from JSON
      return Delta.fromJson(deltaJson['ops'] ?? []);
    } catch (e) {
      // Return empty Delta if conversion fails
      return Delta();
    }
  }

  @override
  Uint8List toSql(Delta value) {
    try {
      // Convert Delta to JSON map
      final Map<String, dynamic> deltaMap = {
        'ops': value.toJson(),
      };

      // Convert to JSON string
      final jsonString = json.encode(deltaMap);

      // Convert string to Uint8List
      return Uint8List.fromList(utf8.encode(jsonString));
    } catch (e) {
      // Return empty JSON if conversion fails
      return Uint8List.fromList(utf8.encode('{"ops":[]}'));
    }
  }
}
