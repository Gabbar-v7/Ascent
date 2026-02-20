import 'package:ascent/database/app_database.dart';
import 'package:ascent/services/dayofweek_service.dart';
import 'package:ascent/services/drift_service.dart';
import 'package:ascent/visuals/components/utils/navigator_utils.dart';
import 'package:ascent/visuals/components/utils/datetime_utils.dart';
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
  List<Routine> _routines = [];

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
    return ListView.builder(
      itemCount: _routines.length,
      itemBuilder: (BuildContext context, int index) =>
          _buildRoutineTile(_routines[index]),
    );
  }

  Widget _buildRoutineTile(Routine routine) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          // Handle routine tap
        },
        onDoubleTap: () {},
        onLongPress: () => showRoutineBottomSheet(routine: routine),
        borderRadius: BorderRadius.circular(20),
        child: ListTile(
          minVerticalPadding: 18,
          leading: Transform.scale(
            scale: 1.2,
            child: Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: true,
              onChanged: (value) {},
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
          trailing: Text(
            "x${routine.targetCount}",
            style: theme.textTheme.titleLarge,
          ),
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
        : TimeOfDay.now();
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
                    routine != null ? "Update Routine:" : "Create Routine:",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  leading: IconButton(
                    onPressed: () => NavigatorUtils.popPage(context),
                    icon: const Icon(Icons.arrow_back_ios_rounded),
                    tooltip: 'Cancel',
                  ),
                  actions: routine != null
                      ? <Widget>[
                          IconButton(
                            icon: const Icon(Icons.copy_outlined, size: 20),
                            tooltip: 'Copy Routine',
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: routine.title),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 26),
                            tooltip: 'Delete Routine',
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
                      decoration: const InputDecoration(
                        hintText: "Enter routine title:",
                      ),
                    ),
                    const Gap(16),

                    // Frequency Section
                    Text(
                      "   Frequency",
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
                            child: Text("Goal: x$targetCount/day"),
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
                                initialTime: TimeOfDay(hour: 6, minute: 0),
                              );

                              if (picked != null && picked != selectedTime) {
                                setModalState(() => selectedTime = picked);
                              }
                            },
                            child: Text(
                              "Time: ${selectedTime.format(context)}",
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
                            child: Text("Cancel"),
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
                                Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
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
                                    newTimeOfDay:
                                        selectedTime.hour * 60 +
                                        selectedTime.minute,
                                    newNotify: notify,
                                    newReminderOffsetMinutes: 0,
                                  );
                                } else {
                                  _addRoutine(
                                    routineTitle: _routineTitleController.text,
                                    repeatDaysMask: selectedWeekDaysMask,
                                    targetCount: targetCount,
                                    timeOfDay:
                                        selectedTime.hour * 60 +
                                        selectedTime.minute,
                                    notify: notify,
                                    reminderOffsetMinutes:
                                        reminderOffsetMinutes,
                                  );
                                }
                                Navigator.pop(context);
                              }
                            },
                            child: Text("Save"),
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
    DateTime current = DateTime.now();
    int todayBitMask = DayOfWeekService.dateMask(current);

    final routines =
        await (database.select(database.routines)
              ..where(
                (tbl) => tbl.repeatDaysMask
                    .bitwiseAnd(drift.Constant(todayBitMask))
                    .equals(todayBitMask),
              )
              ..orderBy([
                (tbl) => drift.OrderingTerm(
                  expression: tbl.timeOfDay,
                  mode: drift.OrderingMode.asc,
                ),
              ]))
            .get();

    setState(() {
      _routines = routines;
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

  Future<void> _toggleRoutineCompletion(
    Routine routine,
    bool isDone,
    DateTime date,
  ) async {}

  Future<void> _deleteRoutine(Routine routine) async {
    await (database.delete(
      database.routines,
    )..where((tbl) => tbl.id.equals(routine.id))).go();
    await _fetchRoutines();
  }
}
