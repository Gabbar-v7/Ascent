import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class DatelinePicker extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DatelinePicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<DatelinePicker> createState() => _DatelinePickerState();
}

class _DatelinePickerState extends State<DatelinePicker> {
  final ScrollController _scrollController =
      ScrollController(); // Initialize controller

  // Generate a fixed 7-day window ending today
  late final List<DateTime> _dates = List.generate(
    7,
    (index) => widget.selectedDate.subtract(Duration(days: 6 - index)),
    growable: false,
  );

  @override
  void initState() {
    super.initState();
    // Use PostFrameCallback to ensure the list is rendered before scrolling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 100, // Provides bounded height for the horizontal ListView
      child: ListView.builder(
        controller: _scrollController, // Attach for programatic scrolling
        scrollDirection: Axis.horizontal, // Create horizontal timeline
        itemCount: _dates.length,
        itemBuilder: (context, index) {
          final date = _dates[index];
          final isSelected = DateUtils.isSameDay(widget.selectedDate, date);

          return GestureDetector(
            onTap: () => widget.onDateSelected(date),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE').format(date),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : Colors.grey,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  const Gap(8),
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // Circular highlight
                      color: isSelected
                          ? theme.colorScheme.onSurface
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.onSurface
                            : Colors.grey,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                        color: isSelected
                            ? theme.colorScheme.surface
                            : theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
