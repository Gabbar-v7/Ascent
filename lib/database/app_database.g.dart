// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _taskMeta = const VerificationMeta('task');
  @override
  late final GeneratedColumn<String> task = GeneratedColumn<String>(
    'task',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDoneMeta = const VerificationMeta('isDone');
  @override
  late final GeneratedColumn<bool> isDone = GeneratedColumn<bool>(
    'is_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_done" IN (0, 1))',
    ),
    defaultValue: Constant(false),
  );
  static const VerificationMeta _notificationMeta = const VerificationMeta(
    'notification',
  );
  @override
  late final GeneratedColumn<bool> notification = GeneratedColumn<bool>(
    'notification',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notification" IN (0, 1))',
    ),
    defaultValue: Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    task,
    dueDate,
    isDone,
    notification,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Task> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('task')) {
      context.handle(
        _taskMeta,
        task.isAcceptableOrUnknown(data['task']!, _taskMeta),
      );
    } else if (isInserting) {
      context.missing(_taskMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('is_done')) {
      context.handle(
        _isDoneMeta,
        isDone.isAcceptableOrUnknown(data['is_done']!, _isDoneMeta),
      );
    }
    if (data.containsKey('notification')) {
      context.handle(
        _notificationMeta,
        notification.isAcceptableOrUnknown(
          data['notification']!,
          _notificationMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      task:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}task'],
          )!,
      dueDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}due_date'],
          )!,
      isDone:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_done'],
          )!,
      notification:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}notification'],
          )!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class Task extends DataClass implements Insertable<Task> {
  final int id;
  final String task;
  final DateTime dueDate;
  final bool isDone;
  final bool notification;
  const Task({
    required this.id,
    required this.task,
    required this.dueDate,
    required this.isDone,
    required this.notification,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['task'] = Variable<String>(task);
    map['due_date'] = Variable<DateTime>(dueDate);
    map['is_done'] = Variable<bool>(isDone);
    map['notification'] = Variable<bool>(notification);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      task: Value(task),
      dueDate: Value(dueDate),
      isDone: Value(isDone),
      notification: Value(notification),
    );
  }

  factory Task.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<int>(json['id']),
      task: serializer.fromJson<String>(json['task']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      isDone: serializer.fromJson<bool>(json['isDone']),
      notification: serializer.fromJson<bool>(json['notification']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'task': serializer.toJson<String>(task),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'isDone': serializer.toJson<bool>(isDone),
      'notification': serializer.toJson<bool>(notification),
    };
  }

  Task copyWith({
    int? id,
    String? task,
    DateTime? dueDate,
    bool? isDone,
    bool? notification,
  }) => Task(
    id: id ?? this.id,
    task: task ?? this.task,
    dueDate: dueDate ?? this.dueDate,
    isDone: isDone ?? this.isDone,
    notification: notification ?? this.notification,
  );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      task: data.task.present ? data.task.value : this.task,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      isDone: data.isDone.present ? data.isDone.value : this.isDone,
      notification:
          data.notification.present
              ? data.notification.value
              : this.notification,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('task: $task, ')
          ..write('dueDate: $dueDate, ')
          ..write('isDone: $isDone, ')
          ..write('notification: $notification')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, task, dueDate, isDone, notification);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.task == this.task &&
          other.dueDate == this.dueDate &&
          other.isDone == this.isDone &&
          other.notification == this.notification);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<int> id;
  final Value<String> task;
  final Value<DateTime> dueDate;
  final Value<bool> isDone;
  final Value<bool> notification;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.task = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.isDone = const Value.absent(),
    this.notification = const Value.absent(),
  });
  TasksCompanion.insert({
    this.id = const Value.absent(),
    required String task,
    required DateTime dueDate,
    this.isDone = const Value.absent(),
    this.notification = const Value.absent(),
  }) : task = Value(task),
       dueDate = Value(dueDate);
  static Insertable<Task> custom({
    Expression<int>? id,
    Expression<String>? task,
    Expression<DateTime>? dueDate,
    Expression<bool>? isDone,
    Expression<bool>? notification,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (task != null) 'task': task,
      if (dueDate != null) 'due_date': dueDate,
      if (isDone != null) 'is_done': isDone,
      if (notification != null) 'notification': notification,
    });
  }

  TasksCompanion copyWith({
    Value<int>? id,
    Value<String>? task,
    Value<DateTime>? dueDate,
    Value<bool>? isDone,
    Value<bool>? notification,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      task: task ?? this.task,
      dueDate: dueDate ?? this.dueDate,
      isDone: isDone ?? this.isDone,
      notification: notification ?? this.notification,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (task.present) {
      map['task'] = Variable<String>(task.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (isDone.present) {
      map['is_done'] = Variable<bool>(isDone.value);
    }
    if (notification.present) {
      map['notification'] = Variable<bool>(notification.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('task: $task, ')
          ..write('dueDate: $dueDate, ')
          ..write('isDone: $isDone, ')
          ..write('notification: $notification')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TasksTable tasks = $TasksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [tasks];
}

typedef $$TasksTableCreateCompanionBuilder =
    TasksCompanion Function({
      Value<int> id,
      required String task,
      required DateTime dueDate,
      Value<bool> isDone,
      Value<bool> notification,
    });
typedef $$TasksTableUpdateCompanionBuilder =
    TasksCompanion Function({
      Value<int> id,
      Value<String> task,
      Value<DateTime> dueDate,
      Value<bool> isDone,
      Value<bool> notification,
    });

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get task => $composableBuilder(
    column: $table.task,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notification => $composableBuilder(
    column: $table.notification,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get task => $composableBuilder(
    column: $table.task,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notification => $composableBuilder(
    column: $table.notification,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get task =>
      $composableBuilder(column: $table.task, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<bool> get isDone =>
      $composableBuilder(column: $table.isDone, builder: (column) => column);

  GeneratedColumn<bool> get notification => $composableBuilder(
    column: $table.notification,
    builder: (column) => column,
  );
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          Task,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
          Task,
          PrefetchHooks Function()
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> task = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<bool> isDone = const Value.absent(),
                Value<bool> notification = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                task: task,
                dueDate: dueDate,
                isDone: isDone,
                notification: notification,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String task,
                required DateTime dueDate,
                Value<bool> isDone = const Value.absent(),
                Value<bool> notification = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                task: task,
                dueDate: dueDate,
                isDone: isDone,
                notification: notification,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      Task,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
      Task,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
}
