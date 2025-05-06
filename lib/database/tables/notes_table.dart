import 'package:drift/drift.dart';

class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get noteTitle => text()();
  TextColumn get noteBody => text().nullable()();
  BoolColumn get isPinned => boolean().nullable()();
  BoolColumn get isArchived => boolean().nullable()();
  BoolColumn get isTrashed => boolean().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
