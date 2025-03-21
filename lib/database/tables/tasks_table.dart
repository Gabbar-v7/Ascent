import 'package:drift/drift.dart';

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get task => text()();
  DateTimeColumn get dueDate => dateTime()();
  BoolColumn get isDone => boolean().withDefault(Constant(false))();
  BoolColumn get notification => boolean().withDefault(Constant(false))();
}
