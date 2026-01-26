import 'package:drift/drift.dart';

class Routines extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  BoolColumn get sunday => boolean().withDefault(const Constant(false))();
  BoolColumn get monday => boolean().withDefault(const Constant(false))();
  BoolColumn get tuesday => boolean().withDefault(const Constant(false))();
  BoolColumn get wednesday => boolean().withDefault(const Constant(false))();
  BoolColumn get thursday => boolean().withDefault(const Constant(false))();
  BoolColumn get friday => boolean().withDefault(const Constant(false))();
  BoolColumn get saturday => boolean().withDefault(const Constant(false))();
  IntColumn get streak => integer().withDefault(const Constant(0))();
  BoolColumn get notify => boolean().nullable()();
}
