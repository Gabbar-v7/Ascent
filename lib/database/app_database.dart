import 'package:drift/drift.dart';
import 'package:ascent/database/tables/tasks_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  // STEP 1 => Modify or create tables
  //
  // STEP 2 => Bump up [schemaVersion]
  //
  // STEP 3 => Rebuild dart api => dart run build_runner build -d
  //
  // STEP 4 => Generate schema => dart run drift_dev schema dump lib/database/app_database.dart lib/database/schemas
  //
  // STEP 5 => Generate steps => dart run drift_dev schema steps lib/database/schemas lib/database/schemas/schema_versions.dart
  //
  // STEP 6 => Add migration steps to migration strategy by create new file in migrations folder. See previous migrations for help

  @override
  int get schemaVersion => 1;

  // Always use [runSafe()] for upgrades - why?
  // If a user imports a backup from a newer schema when they are on an older
  // App version, it will import correctly. However, when they do update the app
  // The migrator will run and it will throw error!
  // @override
  // MigrationStrategy get migration => MigrationStrategy(
  //       onCreate: (m) async => await m.createAll(),
  //       onUpgrade: (m, from, to) async {
  //         return m.runMigrationSteps(
  //           from: from,
  //           to: to,
  //           steps:  migrationSteps(from1To2: from1To2,),
  //         );
  //       },
  //     );
}
