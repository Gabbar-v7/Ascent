import 'package:ascent/database/app_database.dart';
import 'package:ascent/l10n/generated/app_localizations.dart';
import 'package:ascent/services/dayofweek_service.dart';
import 'package:ascent/services/drift_service.dart';
import 'package:ascent/utils/extensions/datetime.x.dart';
import 'package:ascent/utils/extensions/timeofday.x.dart';
import 'package:ascent/visuals/components/utils/navigator_utils.dart';
import 'package:ascent/visuals/components/utils/datetime_utils.dart';
import 'package:ascent/visuals/components/widgets/dateline_picker.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class RoutinesIndex extends StatefulWidget {
  const RoutinesIndex({super.key});

  @override
  State<RoutinesIndex> createState() => RoutinesIndexState();
}

class RoutinesIndexState extends State<RoutinesIndex> {
  final database = DriftService.instance.driftDB;
  final TextEditingController _routineTitleController = TextEditingController();
  List<RoutineProgress> _routineProgressList = [];
  // Use start of day to reduce comparision
  DateTime _activeDate = DateTime.now().startOfDay;

  @override
  void initState() {
    super.initState();
    _fetchRoutines();
  }

  @override
  void dispose() {
    _routineTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DatelinePicker(
          selectedDate: _activeDate,
          onDateSelected: (value) {
            setState(() {
              _activeDate = value;
            });
            _fetchRoutines();
          },
        ),
        Divider(indent: 10, endIndent: 10),
        Expanded(
          child: ListView.builder(
            itemCount: _routineProgressList.length,
            itemBuilder: (BuildContext context, int index) =>
                _buildRoutineTile(_routineProgressList[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildRoutineTile(RoutineProgress routineProgress) {
    final theme = Theme.of(context);
    final Routine routine = routineProgress.routine;
    final bool isCompleted = routineProgress.isCompleted;
    final int currentStreak = routineProgress.currentStreak;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          // Handle routine tap
        },
        onDoubleTap: () =>
            _toggleRoutineCompletion(routine, !isCompleted, _activeDate),
        onLongPress: () => showRoutineBottomSheet(routine: routine),
        borderRadius: BorderRadius.circular(20),
        child: ListTile(
          minVerticalPadding: 18,
          leading: Transform.scale(
            scale: 1.2,
            child: Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: isCompleted,
              onChanged: (value) =>
                  _toggleRoutineCompletion(routine, value!, _activeDate),
            ),
          ),
          title: Text(
            routine.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium,
          ),
          subtitle: Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 13,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const Gap(4),
              Text(
                formatMinutesOffsetToTime(routine.timeOfDay, context),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          trailing: Text("x$currentStreak", style: theme.textTheme.titleLarge),
        ),
      ),
    );
  }

  void showRoutineBottomSheet({Routine? routine}) {
    _routineTitleController.text = routine?.title ?? "";
    int selectedWeekDaysMask = routine?.repeatDaysMask ?? 0;
    int targetCount = routine?.targetCount ?? 1;
    TimeOfDay selectedTime = routine != null
        ? minutesOffsetToTimeOfDay(routine.timeOfDay)
        : TimeOfDay(hour: 6, minute: 0);
    bool notify = routine?.notify ?? false;
    int reminderOffsetMinutes = routine?.reminderOffsetMinutes ?? 0;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header AppBar
              Padding(
                padding: const EdgeInsets.only(top: 3, right: 3, left: 3),
                child: AppBar(
                  title: Text(
                    routine != null
                        ? AppLocalizations.of(
                            context,
                          )!.routine_label_updateRoutine
                        : AppLocalizations.of(
                            context,
                          )!.routine_label_createRoutine,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  leading: IconButton(
                    onPressed: () => NavigatorUtils.popPage(context),
                    icon: const Icon(Icons.arrow_back_ios_rounded),
                  ),
                  actions: routine != null
                      ? <Widget>[
                          IconButton(
                            icon: const Icon(Icons.copy_outlined, size: 20),
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: routine.title),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 26),
                            onPressed: () {
                              _deleteRoutine(routine);
                              NavigatorUtils.popPage(context);
                            },
                          ),
                          const Gap(5),
                        ]
                      : <Widget>[],
                  backgroundColor: Colors.transparent,
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Input
                    TextField(
                      controller: _routineTitleController,
                      textCapitalization: TextCapitalization.sentences,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(
                          context,
                        )!.routine_input_title,
                      ),
                    ),
                    const Gap(16),

                    // Frequency Section
                    Text(
                      "  ${AppLocalizations.of(context)!.routine_label_frequency}",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: DayOfWeek.values.map((day) {
                        // Check if this specific day bit is "on" in the mask
                        final isSelected = DayOfWeekService.isDaySelected(
                          selectedWeekDaysMask,
                          day,
                        );

                        // Get first letter for the UI (M, T, W, etc.)
                        final dayLabel = day.name.substring(0, 1).toUpperCase();

                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              // Toggle the bit in the mask
                              selectedWeekDaysMask = DayOfWeekService.toggleDay(
                                selectedWeekDaysMask,
                                day,
                              );
                            });
                            HapticFeedback.selectionClick();
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.outline
                                          .withValues(alpha: .5),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                dayLabel,
                                style: TextStyle(
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).colorScheme.onSurface,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const Gap(20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: FilledButton(
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              backgroundColor: WidgetStatePropertyAll<Color>(
                                Theme.of(context).colorScheme.primaryContainer,
                              ),
                              foregroundColor: WidgetStatePropertyAll<Color>(
                                Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                              textStyle: WidgetStatePropertyAll(
                                Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              "${AppLocalizations.of(context)!.routine_button_goal}: x$targetCount/day",
                            ),
                          ),
                        ),
                        const Gap(16),
                        Expanded(
                          child: FilledButton(
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              backgroundColor: WidgetStatePropertyAll<Color>(
                                Theme.of(context).colorScheme.primaryContainer,
                              ),
                              foregroundColor: WidgetStatePropertyAll<Color>(
                                Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                              textStyle: WidgetStatePropertyAll(
                                Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                            onPressed: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: selectedTime,
                              );

                              if (picked != null && picked != selectedTime) {
                                setModalState(() => selectedTime = picked);
                              }
                            },
                            child: Text(
                              "${AppLocalizations.of(context)!.routine_button_time}: ${selectedTime.format(context)}",
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              backgroundColor: WidgetStatePropertyAll(
                                Theme.of(context).colorScheme.surface,
                              ),
                              foregroundColor: WidgetStatePropertyAll(
                                Theme.of(context).colorScheme.onSurface,
                              ),
                              textStyle: WidgetStatePropertyAll(
                                Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              AppLocalizations.of(
                                context,
                              )!.common_button_cancel,
                            ),
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              backgroundColor: WidgetStatePropertyAll(
                                Theme.of(context).colorScheme.primary,
                              ),
                              foregroundColor: WidgetStatePropertyAll(
                                Theme.of(context).colorScheme.onPrimary,
                              ),
                              textStyle: WidgetStatePropertyAll(
                                Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            onPressed: () {
                              if (_routineTitleController.text.isNotEmpty &&
                                  selectedWeekDaysMask > 0) {
                                if (routine != null) {
                                  _updateRoutine(
                                    routine,
                                    newRoutineTitle:
                                        _routineTitleController.text,
                                    newRepeatDaysMask: selectedWeekDaysMask,
                                    newTargetCount: targetCount,
                                    newTimeOfDay: selectedTime.toInt,
                                    newNotify: notify,
                                    newReminderOffsetMinutes: 0,
                                  );
                                } else {
                                  _addRoutine(
                                    routineTitle: _routineTitleController.text,
                                    repeatDaysMask: selectedWeekDaysMask,
                                    targetCount: targetCount,
                                    timeOfDay: selectedTime.toInt,
                                    notify: notify,
                                    reminderOffsetMinutes:
                                        reminderOffsetMinutes,
                                  );
                                }
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              AppLocalizations.of(context)!.common_button_save,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Gap(MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchRoutines() async {
    int activeDayMask = DayOfWeekService.dateMask(_activeDate);
    DateTime monthStart = _activeDate.startOfMonth;

    final isCompleted = database.routineLogs.doneOn.max().equals(_activeDate);

    final rows =
        await (database.select(database.routines).join([
                drift.leftOuterJoin(
                  database.routineLogs,
                  database.routineLogs.routineId.equalsExp(
                        database.routines.id,
                      ) &
                      database.routineLogs.doneOn.isBetween(
                        drift.Constant(monthStart),
                        drift.Constant(_activeDate),
                      ),
                ),
              ])
              ..where(
                database.routines.repeatDaysMask
                    .bitwiseAnd(drift.Constant(activeDayMask))
                    .equals(activeDayMask),
              )
              ..addColumns([database.routineLogs.id.count(), isCompleted])
              ..groupBy([database.routines.id])
              ..orderBy([
                drift.OrderingTerm(
                  expression: database.routines.timeOfDay,
                  mode: drift.OrderingMode.asc,
                ),
              ]))
            .get();

    final routineProgressList = rows
        .map((row) {
          return RoutineProgress(
            row.readTable(database.routines),
            row.read(isCompleted) ?? false,
            row.read(database.routineLogs.id.count())!,
          );
        })
        .toList(growable: false);

    setState(() {
      _routineProgressList = routineProgressList;
    });
  }

  Future<void> _addRoutine({
    required String routineTitle,
    required int repeatDaysMask,
    required int targetCount,
    required int timeOfDay,
    required bool notify,
    required int reminderOffsetMinutes,
  }) async {
    await database
        .into(database.routines)
        .insert(
          RoutinesCompanion.insert(
            title: routineTitle,
            repeatDaysMask: repeatDaysMask,
            targetCount: targetCount,
            timeOfDay: timeOfDay,
            reminderOffsetMinutes: drift.Value(reminderOffsetMinutes),
            notify: notify,
          ),
        );
    await _fetchRoutines();
  }

  Future<void> _updateRoutine(
    Routine routine, {
    String? newRoutineTitle,
    int? newRepeatDaysMask,
    int? newTargetCount,
    int? newTimeOfDay,
    bool? newNotify,
    int? newReminderOffsetMinutes,
    bool? newIsArchived,
  }) async {
    await (database.update(
      database.routines,
    )..where((tbl) => tbl.id.equals(routine.id))).write(
      RoutinesCompanion(
        // Only update if a new value is provided, otherwise keep the old one
        title: newRoutineTitle != null
            ? drift.Value(newRoutineTitle)
            : const drift.Value.absent(),
        repeatDaysMask: newRepeatDaysMask != null
            ? drift.Value(newRepeatDaysMask)
            : const drift.Value.absent(),
        targetCount: newTargetCount != null
            ? drift.Value(newTargetCount)
            : const drift.Value.absent(),
        timeOfDay: newTimeOfDay != null
            ? drift.Value(newTimeOfDay)
            : const drift.Value.absent(),
        notify: newNotify != null
            ? drift.Value(newNotify)
            : const drift.Value.absent(),
        reminderOffsetMinutes: newReminderOffsetMinutes != null
            ? drift.Value(newReminderOffsetMinutes)
            : const drift.Value.absent(),
        isArchived: newIsArchived != null
            ? drift.Value(newIsArchived)
            : const drift.Value.absent(),
      ),
    );
    await _fetchRoutines();
  }

  // ignore: unused_element
  Future<void> _toggleRoutineCompletion(
    Routine routine,
    bool isDone,
    DateTime date,
  ) async {
    isDone
        ? await database
              .into(database.routineLogs)
              .insert(
                RoutineLogsCompanion(
                  routineId: drift.Value(routine.id),
                  doneOn: drift.Value(date),
                ),
              )
        : await (database.delete(database.routineLogs)..where(
                (tbl) =>
                    tbl.routineId.equals(routine.id) &
                    tbl.doneOn.isBetween(
                      drift.Constant(date),
                      drift.Constant(date.add(Duration(days: 1))),
                    ),
              ))
              .go();
    await _fetchRoutines();
  }

  Future<void> _deleteRoutine(Routine routine) async {
    await (database.delete(
      database.routines,
    )..where((tbl) => tbl.id.equals(routine.id))).go();
    await _fetchRoutines();
  }
}

class RoutineProgress {
  final Routine routine;
  final bool isCompleted;
  final int currentStreak;

  RoutineProgress(this.routine, this.isCompleted, this.currentStreak);
}
