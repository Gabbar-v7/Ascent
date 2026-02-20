import 'package:drift/drift.dart';

class Routines extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  IntColumn get repeatDaysMask => integer()();
  IntColumn get targetCount => integer()();
  // Store minutes from midnight
  IntColumn get timeOfDay => integer()();
  BoolColumn get notify => boolean()();
  IntColumn get reminderOffsetMinutes =>
      integer().withDefault(const Constant(0))();

  // Metadata
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
}

class RoutineLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get routineId => integer().references(Routines, #id)();
  DateTimeColumn get doneOn => dateTime()();
}
