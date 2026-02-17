import 'package:drift/drift.dart';

class Routines extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  IntColumn get repeatDaysMask => integer()();
  IntColumn get targetCount => integer()();
  // Store minutes from midnight
  IntColumn get notifyAtOffset => integer()();
  IntColumn get reminderOffsetMinutes =>
      integer().withDefault(const Constant(0))();
  BoolColumn get notify => boolean().nullable()();

  // Metadata
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
}
