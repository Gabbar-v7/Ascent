enum DayOfWeek {
  monday(1), // 0000001
  tuesday(2), // 0000010
  wednesday(4), // 0000100
  thursday(8), // 0001000
  friday(16), // 0010000
  saturday(32), // 0100000
  sunday(64); // 1000000

  final int bitValue;
  const DayOfWeek(this.bitValue);
}

class DayOfWeekService {
  /// Check if a specific day is present in the mask
  static bool isDaySelected(int mask, DayOfWeek day) {
    return (mask & day.bitValue) != 0;
  }

  /// Converts a DateTime object into the corresponding bitmask value
  static int dateMask(DateTime date) {
    // DateTime.weekday returns 1 (Mon) through 7 (Sun)
    // We subtract 1 to get a 0-6 range, then use bit shifting
    return 1 << (date.weekday - 1);
  }

  /// Helper to get the enum directly from a DateTime
  static DayOfWeek fromDateTime(DateTime date) {
    return DayOfWeek.values[date.weekday - 1];
  }

  /// Add or remove a day from the mask
  static int toggleDay(int mask, DayOfWeek day) {
    return mask ^ day.bitValue;
  }

  /// Force a day to be selected
  static int addDay(int mask, DayOfWeek day) {
    return mask | day.bitValue;
  }

  /// Force a day to be removed
  static int removeDay(int mask, DayOfWeek day) {
    return mask & ~day.bitValue;
  }

  /// Get a list of all selected DayOfWeek enums from a mask
  static List<DayOfWeek> getSelectedDays(int mask) {
    return DayOfWeek.values.where((day) => isDaySelected(mask, day)).toList();
  }
}
