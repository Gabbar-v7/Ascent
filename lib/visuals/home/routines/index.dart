import 'package:ascent/database/app_database.dart';
import 'package:ascent/services/drift_service.dart';
import 'package:drift/drift.dart'
    as drift; // Alias to avoid conflict with Column
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

// --- Helper for Bitmasking ---
class DayBitmask {
  // S, M, T, W, T, F, S -> We map Sunday to index 0 or 6 depending on preference.
  // Standard DateTime: Mon=1..Sun=7.
  // Let's align with your list: [Sun, Mon, Tue, Wed, Thu, Fri, Sat]
  // Index 0 = Sun, Index 1 = Mon... Index 6 = Sat

  static int combine(List<bool> selectedDays) {
    int mask = 0;
    for (int i = 0; i < selectedDays.length; i++) {
      if (selectedDays[i]) {
        mask |= (1 << i);
      }
    }
    return mask;
  }

  static List<bool> decode(int mask) {
    return List.generate(7, (i) {
      return (mask & (1 << i)) != 0;
    });
  }

  static String getDisplayString(int mask) {
    if (mask == 127) return "Every day";
    if (mask == 0) return "No days selected";

    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    List<String> active = [];
    for (int i = 0; i < 7; i++) {
      if ((mask & (1 << i)) != 0) active.add(days[i]);
    }
    return active.join(', ');
  }
}

class RoutinesIndex extends StatefulWidget {
  const RoutinesIndex({super.key});

  @override
  State<RoutinesIndex> createState() => RoutinesIndexState();
}

class RoutinesIndexState extends State<RoutinesIndex> {
  final database = DriftService.instance.driftDB;
  final TextEditingController _routineTitleController = TextEditingController();

  // This will hold the data fetched from Drift
  List<Routine> _routines = [];

  // UI mapping matches DayBitmask logic: [Sun, Mon, Tue, Wed, Thu, Fri, Sat]
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

  /// Converts TimeOfDay to minutes from midnight (e.g., 1:00 AM = 60)
  int _timeToMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

  /// Converts minutes from midnight back to TimeOfDay
  TimeOfDay _minutesToTime(int minutes) =>
      TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _routines.isEmpty
          ? const Center(child: Text("No routines found"))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _routines.length,
              separatorBuilder: (context, index) => const Gap(16),
              itemBuilder: (context, index) =>
                  _buildRoutineTile(_routines[index]),
            ),
    );
  }

  Widget _buildRoutineTile(Routine routine) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Decode DB values for display
    final time = _minutesToTime(routine.notifyAtOffset);
    final daysText = DayBitmask.getDisplayString(routine.repeatDaysMask);

    return Material(
      color: colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () {
          // Handle routine tap (mark complete logic would go here)
        },
        onLongPress: () => showRoutineBottomSheet(routine: routine),
        borderRadius: BorderRadius.circular(20),
        child: ListTile(
          minVerticalPadding: 18,
          leading: Transform.scale(
            scale: 1.2,
            child: Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value:
                  false, // You need to join with RoutineComplete table for this state
              onChanged: (value) {},
            ),
          ),
          title: Text(
            routine.title,
            style: textTheme.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    size: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const Gap(4),
                  Text(
                    "${time.format(context)} • $daysText",
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
              Text(
                "Goal: x${routine.targetCount}",
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showRoutineBottomSheet({Routine? routine}) {
    _routineTitleController.text = routine?.title ?? "";

    // Initialize State variables
    List<bool> selectedDays = routine != null
        ? DayBitmask.decode(routine.repeatDaysMask)
        : List.filled(7, false); // Default none

    TimeOfDay selectedTime = routine != null
        ? _minutesToTime(routine.notifyAtOffset)
        : TimeOfDay.now();

    int goalCount = routine?.targetCount ?? 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context, routine),

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
                        decoration: const InputDecoration(
                          hintText: "Enter routine title",
                        ),
                      ),
                      const Gap(16),

                      // Frequency Selector
                      Text(
                        "Frequency",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Gap(8),
                      _buildDaySelector(context, selectedDays, setModalState),
                      const Gap(20),

                      // Goal and Time Buttons
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.tonal(
                              onPressed: () async {
                                // Show Goal Dialog
                                final newGoal = await showDialog<int>(
                                  context: context,
                                  builder: (c) => _GoalPickerDialog(
                                    initialValue: goalCount,
                                  ),
                                );
                                if (newGoal != null) {
                                  setModalState(() => goalCount = newGoal);
                                }
                              },
                              child: Text("Goal: x$goalCount"),
                            ),
                          ),
                          const Gap(16),
                          Expanded(
                            child: FilledButton.tonal(
                              onPressed: () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: selectedTime,
                                );
                                if (picked != null) {
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
                      const Gap(24),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: FilledButton(
                              onPressed: () {
                                if (_routineTitleController.text.isNotEmpty) {
                                  final mask = DayBitmask.combine(selectedDays);
                                  final timeOffset = _timeToMinutes(
                                    selectedTime,
                                  );

                                  if (routine != null) {
                                    _updateRoutine(
                                      routine,
                                      mask,
                                      timeOffset,
                                      goalCount,
                                    );
                                  } else {
                                    _addRoutine(mask, timeOffset, goalCount);
                                  }
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text("Save"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Header Extraction for cleaner code ---
  Widget _buildHeader(BuildContext context, Routine? routine) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AppBar(
        title: Text(routine != null ? "Edit Routine" : "New Routine"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: routine != null
            ? [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    _deleteRoutine(routine);
                    Navigator.pop(context);
                  },
                ),
              ]
            : [],
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
    );
  }

  // --- Day Selector Extraction ---
  Widget _buildDaySelector(
    BuildContext context,
    List<bool> selectedDays,
    StateSetter setModalState,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(_daysOfWeek.length, (index) {
        final isSelected = selectedDays[index];
        return GestureDetector(
          onTap: () {
            setModalState(() => selectedDays[index] = !selectedDays[index]);
            HapticFeedback.selectionClick();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
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
                    : Colors.grey.shade400,
              ),
            ),
            child: Center(
              child: Text(
                _daysOfWeek[index],
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Colors.grey.shade700,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // --- Database Operations ---

  Future<void> _fetchRoutines() async {
    // Select all routines, typically you would order them or filter archived
    final results = await (database.select(
      database.routines,
    )..where((tbl) => tbl.isArchived.not())).get();

    if (mounted) {
      setState(() {
        _routines = results;
      });
    }
  }

  Future<void> _addRoutine(int mask, int timeOffset, int goal) async {
    final companion = RoutinesCompanion(
      title: drift.Value(_routineTitleController.text),
      repeatDaysMask: drift.Value(mask),
      notifyAtOffset: drift.Value(timeOffset),
      targetCount: drift.Value(goal),
      notify: const drift.Value(true),
      isArchived: const drift.Value(false),
    );

    await database.into(database.routines).insert(companion);
    _fetchRoutines(); // Refresh list
  }

  Future<void> _updateRoutine(
    Routine routine,
    int mask,
    int timeOffset,
    int goal,
  ) async {
    final companion = RoutinesCompanion(
      id: drift.Value(routine.id),
      title: drift.Value(_routineTitleController.text),
      repeatDaysMask: drift.Value(mask),
      notifyAtOffset: drift.Value(timeOffset),
      targetCount: drift.Value(goal),
    );

    await (database.update(
      database.routines,
    )..where((t) => t.id.equals(routine.id))).write(companion);
    _fetchRoutines();
  }

  Future<void> _deleteRoutine(Routine routine) async {
    await (database.delete(
      database.routines,
    )..where((t) => t.id.equals(routine.id))).go();
    _fetchRoutines();
  }
}

// --- Goal Picker (Kept mostly the same, just made reusable) ---
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: selectedGoal > 1
                    ? () => setState(() => selectedGoal--)
                    : null,
              ),
              Text(
                'x$selectedGoal',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => setState(() => selectedGoal++),
              ),
            ],
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
          child: const Text('Set'),
        ),
      ],
    );
  }
}
