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
  static const VerificationMeta _taskTitleMeta = const VerificationMeta(
    'taskTitle',
  );
  @override
  late final GeneratedColumn<String> taskTitle = GeneratedColumn<String>(
    'task_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskBodyMeta = const VerificationMeta(
    'taskBody',
  );
  @override
  late final GeneratedColumn<String> taskBody = GeneratedColumn<String>(
    'task_body',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _doneOnMeta = const VerificationMeta('doneOn');
  @override
  late final GeneratedColumn<DateTime> doneOn = GeneratedColumn<DateTime>(
    'done_on',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notifyMeta = const VerificationMeta('notify');
  @override
  late final GeneratedColumn<bool> notify = GeneratedColumn<bool>(
    'notify',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notify" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskTitle,
    taskBody,
    dueDate,
    doneOn,
    notify,
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
    if (data.containsKey('task_title')) {
      context.handle(
        _taskTitleMeta,
        taskTitle.isAcceptableOrUnknown(data['task_title']!, _taskTitleMeta),
      );
    } else if (isInserting) {
      context.missing(_taskTitleMeta);
    }
    if (data.containsKey('task_body')) {
      context.handle(
        _taskBodyMeta,
        taskBody.isAcceptableOrUnknown(data['task_body']!, _taskBodyMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('done_on')) {
      context.handle(
        _doneOnMeta,
        doneOn.isAcceptableOrUnknown(data['done_on']!, _doneOnMeta),
      );
    }
    if (data.containsKey('notify')) {
      context.handle(
        _notifyMeta,
        notify.isAcceptableOrUnknown(data['notify']!, _notifyMeta),
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
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      taskTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_title'],
      )!,
      taskBody: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_body'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      doneOn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}done_on'],
      ),
      notify: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notify'],
      ),
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class Task extends DataClass implements Insertable<Task> {
  final int id;
  final String taskTitle;
  final String? taskBody;
  final DateTime dueDate;
  final DateTime? doneOn;
  final bool? notify;
  const Task({
    required this.id,
    required this.taskTitle,
    this.taskBody,
    required this.dueDate,
    this.doneOn,
    this.notify,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['task_title'] = Variable<String>(taskTitle);
    if (!nullToAbsent || taskBody != null) {
      map['task_body'] = Variable<String>(taskBody);
    }
    map['due_date'] = Variable<DateTime>(dueDate);
    if (!nullToAbsent || doneOn != null) {
      map['done_on'] = Variable<DateTime>(doneOn);
    }
    if (!nullToAbsent || notify != null) {
      map['notify'] = Variable<bool>(notify);
    }
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      taskTitle: Value(taskTitle),
      taskBody: taskBody == null && nullToAbsent
          ? const Value.absent()
          : Value(taskBody),
      dueDate: Value(dueDate),
      doneOn: doneOn == null && nullToAbsent
          ? const Value.absent()
          : Value(doneOn),
      notify: notify == null && nullToAbsent
          ? const Value.absent()
          : Value(notify),
    );
  }

  factory Task.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<int>(json['id']),
      taskTitle: serializer.fromJson<String>(json['taskTitle']),
      taskBody: serializer.fromJson<String?>(json['taskBody']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      doneOn: serializer.fromJson<DateTime?>(json['doneOn']),
      notify: serializer.fromJson<bool?>(json['notify']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'taskTitle': serializer.toJson<String>(taskTitle),
      'taskBody': serializer.toJson<String?>(taskBody),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'doneOn': serializer.toJson<DateTime?>(doneOn),
      'notify': serializer.toJson<bool?>(notify),
    };
  }

  Task copyWith({
    int? id,
    String? taskTitle,
    Value<String?> taskBody = const Value.absent(),
    DateTime? dueDate,
    Value<DateTime?> doneOn = const Value.absent(),
    Value<bool?> notify = const Value.absent(),
  }) => Task(
    id: id ?? this.id,
    taskTitle: taskTitle ?? this.taskTitle,
    taskBody: taskBody.present ? taskBody.value : this.taskBody,
    dueDate: dueDate ?? this.dueDate,
    doneOn: doneOn.present ? doneOn.value : this.doneOn,
    notify: notify.present ? notify.value : this.notify,
  );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      taskTitle: data.taskTitle.present ? data.taskTitle.value : this.taskTitle,
      taskBody: data.taskBody.present ? data.taskBody.value : this.taskBody,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      doneOn: data.doneOn.present ? data.doneOn.value : this.doneOn,
      notify: data.notify.present ? data.notify.value : this.notify,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('taskTitle: $taskTitle, ')
          ..write('taskBody: $taskBody, ')
          ..write('dueDate: $dueDate, ')
          ..write('doneOn: $doneOn, ')
          ..write('notify: $notify')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, taskTitle, taskBody, dueDate, doneOn, notify);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.taskTitle == this.taskTitle &&
          other.taskBody == this.taskBody &&
          other.dueDate == this.dueDate &&
          other.doneOn == this.doneOn &&
          other.notify == this.notify);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<int> id;
  final Value<String> taskTitle;
  final Value<String?> taskBody;
  final Value<DateTime> dueDate;
  final Value<DateTime?> doneOn;
  final Value<bool?> notify;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.taskTitle = const Value.absent(),
    this.taskBody = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.doneOn = const Value.absent(),
    this.notify = const Value.absent(),
  });
  TasksCompanion.insert({
    this.id = const Value.absent(),
    required String taskTitle,
    this.taskBody = const Value.absent(),
    required DateTime dueDate,
    this.doneOn = const Value.absent(),
    this.notify = const Value.absent(),
  }) : taskTitle = Value(taskTitle),
       dueDate = Value(dueDate);
  static Insertable<Task> custom({
    Expression<int>? id,
    Expression<String>? taskTitle,
    Expression<String>? taskBody,
    Expression<DateTime>? dueDate,
    Expression<DateTime>? doneOn,
    Expression<bool>? notify,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskTitle != null) 'task_title': taskTitle,
      if (taskBody != null) 'task_body': taskBody,
      if (dueDate != null) 'due_date': dueDate,
      if (doneOn != null) 'done_on': doneOn,
      if (notify != null) 'notify': notify,
    });
  }

  TasksCompanion copyWith({
    Value<int>? id,
    Value<String>? taskTitle,
    Value<String?>? taskBody,
    Value<DateTime>? dueDate,
    Value<DateTime?>? doneOn,
    Value<bool?>? notify,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      taskTitle: taskTitle ?? this.taskTitle,
      taskBody: taskBody ?? this.taskBody,
      dueDate: dueDate ?? this.dueDate,
      doneOn: doneOn ?? this.doneOn,
      notify: notify ?? this.notify,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (taskTitle.present) {
      map['task_title'] = Variable<String>(taskTitle.value);
    }
    if (taskBody.present) {
      map['task_body'] = Variable<String>(taskBody.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (doneOn.present) {
      map['done_on'] = Variable<DateTime>(doneOn.value);
    }
    if (notify.present) {
      map['notify'] = Variable<bool>(notify.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('taskTitle: $taskTitle, ')
          ..write('taskBody: $taskBody, ')
          ..write('dueDate: $dueDate, ')
          ..write('doneOn: $doneOn, ')
          ..write('notify: $notify')
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
      required String taskTitle,
      Value<String?> taskBody,
      required DateTime dueDate,
      Value<DateTime?> doneOn,
      Value<bool?> notify,
    });
typedef $$TasksTableUpdateCompanionBuilder =
    TasksCompanion Function({
      Value<int> id,
      Value<String> taskTitle,
      Value<String?> taskBody,
      Value<DateTime> dueDate,
      Value<DateTime?> doneOn,
      Value<bool?> notify,
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

  ColumnFilters<String> get taskTitle => $composableBuilder(
    column: $table.taskTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskBody => $composableBuilder(
    column: $table.taskBody,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get doneOn => $composableBuilder(
    column: $table.doneOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notify => $composableBuilder(
    column: $table.notify,
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

  ColumnOrderings<String> get taskTitle => $composableBuilder(
    column: $table.taskTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskBody => $composableBuilder(
    column: $table.taskBody,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get doneOn => $composableBuilder(
    column: $table.doneOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notify => $composableBuilder(
    column: $table.notify,
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

  GeneratedColumn<String> get taskTitle =>
      $composableBuilder(column: $table.taskTitle, builder: (column) => column);

  GeneratedColumn<String> get taskBody =>
      $composableBuilder(column: $table.taskBody, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<DateTime> get doneOn =>
      $composableBuilder(column: $table.doneOn, builder: (column) => column);

  GeneratedColumn<bool> get notify =>
      $composableBuilder(column: $table.notify, builder: (column) => column);
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
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> taskTitle = const Value.absent(),
                Value<String?> taskBody = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<DateTime?> doneOn = const Value.absent(),
                Value<bool?> notify = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                taskTitle: taskTitle,
                taskBody: taskBody,
                dueDate: dueDate,
                doneOn: doneOn,
                notify: notify,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String taskTitle,
                Value<String?> taskBody = const Value.absent(),
                required DateTime dueDate,
                Value<DateTime?> doneOn = const Value.absent(),
                Value<bool?> notify = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                taskTitle: taskTitle,
                taskBody: taskBody,
                dueDate: dueDate,
                doneOn: doneOn,
                notify: notify,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
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
