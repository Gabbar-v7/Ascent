import 'package:ascent/database/converters/quill_delta_converter.dart';
import 'package:drift/drift.dart';

class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get noteTitle => text().nullable()();
  BlobColumn get noteBody => blob().nullable().map(QuillDeltaConverter())();
  BoolColumn get archived => boolean().nullable()();
  BoolColumn get trashed => boolean().nullable()();

  DateTimeColumn get trashedAt => dateTime().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(Constant(DateTime.now()))();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(Constant(DateTime.now()))();
}
