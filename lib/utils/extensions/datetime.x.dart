extension DateTimeX on DateTime {
  DateTime get startOfMonth => DateTime(year, month, 1);

  DateTime get startOfNextMonth =>
      month == 12 ? DateTime(year + 1, 1, 1) : DateTime(year, month + 1, 1);

  DateTime get startOfDay => DateTime(year, month, day);
}
