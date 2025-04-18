import 'package:drift/drift.dart';

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get taskTitle => text()();
  TextColumn get taskBody => text().nullable()();
  DateTimeColumn get dueDate => dateTime()();
  DateTimeColumn get doneOn => dateTime().nullable()();
  BoolColumn get notify => boolean().nullable()();
}
