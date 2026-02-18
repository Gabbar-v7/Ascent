import 'package:ascent/database/app_database.dart';
import 'package:ascent/services/drift_service.dart';
import 'package:ascent/visuals/home/routines/ukn.dart';
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

  // Days of week selection
  static const List<String> _daysOfWeek = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

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
    return ListView.separated(
      itemCount: _routines.length,
      separatorBuilder: (context, index) => const Gap(16),
      itemBuilder: (BuildContext context, int index) =>
          _buildRoutineTile(_routines[index]),
    );
  }

  Widget _buildRoutineTile(Routine routine) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () {
          // Handle routine tap
        },
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
            style: textTheme.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 12,
                color: colorScheme.onSurfaceVariant,
              ),
              const Gap(4),
              Text(routine.title, style: textTheme.bodySmall),
            ],
          ),
          trailing: Text("x3", style: textTheme.titleLarge),
        ),
      ),
    );
  }

  void showRoutineBottomSheet({Routine? routine}) {
    _routineTitleController.text = routine?.title ?? "";
    List<bool> _selectedDays = List.filled(7, false);
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();
    int goalCount = 1;

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
                    routine != null ? "Edit Routine" : "New Routine",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_rounded),
                    tooltip: 'Cancel',
                  ),
                  actions: routine != null
                      ? <Widget>[
                          IconButton(
                            icon: const Icon(Icons.copy_outlined, size: 20),
                            tooltip: 'Copy routine',
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: "Copied Routine: ${routine.title}",
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 26),
                            tooltip: 'Delete routine',
                            onPressed: () {
                              _deleteRoutine(routine);
                              Navigator.pop(context);
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
                      children: List.generate(_daysOfWeek.length, (index) {
                        final isSelected = _selectedDays[index];
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              _selectedDays[index] = !_selectedDays[index];
                            });
                            // Haptic feedback
                            HapticFeedback.selectionClick();
                          },
                          onHorizontalDragUpdate: (details) => print(index),
                          child: Semantics(
                            label:
                                '${_daysOfWeek[index]}, ${isSelected ? "selected" : "not selected"}',
                            button: true,
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
                                      : Theme.of(
                                          context,
                                        ).colorScheme.outline.withOpacity(0.5),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  _daysOfWeek[index],
                                  style: TextStyle(
                                    color: isSelected
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.onPrimary
                                        : Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
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
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2200),
                              );
                              if (picked != null && picked != selectedDate) {
                                setModalState(() {
                                  selectedDate = picked;
                                });
                              }
                            },
                            child: Text("Goal: x$goalCount/day"),
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
                              if (_routineTitleController.text.isNotEmpty) {
                                if (routine != null) {
                                  _updateRoutine();
                                  Navigator.pop(context);
                                } else {
                                  _addRoutine(
                                    _routineTitleController.text,
                                    127,
                                    goalCount,
                                    selectedTime.hour * 60 +
                                        selectedTime.minute,
                                    0,
                                    false,
                                    false,
                                  );
                                  FocusScope.of(context).unfocus();
                                  _routineTitleController.clear();
                                }
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

  // Goal Picker Dialog Widget

  void _updateRoutine() {}

  void _addRoutine(
    String routineTitle,
    int repeatDaysMask,
    int targetCount,
    int notifyAtOffset,
    int reminderOffsetMinutes,
    bool notify,
    bool isArchived,
  ) async {
    await database
        .into(database.routines)
        .insert(
          RoutinesCompanion.insert(
            title: routineTitle,
            repeatDaysMask: repeatDaysMask,
            targetCount: targetCount,
            notifyAtOffset: notifyAtOffset,
            reminderOffsetMinutes: drift.Value(reminderOffsetMinutes),
            notify: notify,
            isArchived: drift.Value(isArchived),
          ),
        );
  }

  void _deleteRoutine(Routine routine) async {}

  Future<void> _fetchRoutines() async {
    int todayBit = Ukn.getDayOfWeekBit(DateTime.now());

    final routines =
        await (database.select(database.routines)..where((tbl) {
              // Perform the bitwise AND and check if the result is > 0
              return tbl.repeatDaysMask
                  .bitwiseAnd(drift.Constant(todayBit))
                  .isBiggerThan(drift.Constant(0));
            }))
            .get();

    setState(() {
      _routines = routines;
    });
  }
}

class _GoalPickerDialog extends StatefulWidget {
  final int initialValue;

  const _GoalPickerDialog({required this.initialValue});

  @override
  State<_GoalPickerDialog> createState() => _GoalPickerDialogState();
}

class _GoalPickerDialogState extends State<_GoalPickerDialog> {
  late int selectedGoal;

  @override
  void initState() {
    super.initState();
    selectedGoal = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set Daily Goal'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('How many times per day?'),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: selectedGoal > 1
                    ? () {
                        setState(() {
                          selectedGoal--;
                        });
                      }
                    : null,
              ),
              const Gap(16),
              Text(
                'x$selectedGoal',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(16),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: selectedGoal < 10
                    ? () {
                        setState(() {
                          selectedGoal++;
                        });
                      }
                    : null,
              ),
            ],
          ),
          const Gap(8),
          Slider(
            value: selectedGoal.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            label: 'x$selectedGoal',
            onChanged: (value) {
              setState(() {
                selectedGoal = value.toInt();
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, selectedGoal),
          child: const Text('Set Goal'),
        ),
      ],
    );
  }
}
