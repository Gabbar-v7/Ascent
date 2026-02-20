import 'package:flutter/material.dart';

String formatMinutesOffsetToTime(int totalMinutes, BuildContext context) {
  final time = minutesOffsetToTimeOfDay(totalMinutes);
  // Device's locale (12h or 24h format)
  return time.format(context);
}

TimeOfDay minutesOffsetToTimeOfDay(int totalMinutes) {
  final int hour = totalMinutes ~/ 60;
  final int minute = totalMinutes % 60;

  return TimeOfDay(hour: hour, minute: minute);
}
