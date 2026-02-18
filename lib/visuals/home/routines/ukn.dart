class Ukn {
  static List<String> weekDaysNames = [
    '', // Index 0 unused (since weekday starts at 1)
    'Monday', // 1
    'Tuesday', // 2
    'Wednesday', // 3
    'Thursday', // 4
    'Friday', // 5
    'Saturday', // 6
    'Sunday', // 7
  ];

  static int getDayOfWeekBit(DateTime date) {
    // Get week day (1 = Mon, 7 = Sun)
    int weekDay = date.weekday;

    // Convert to a bit position.
    // Mask starts at Monday bit 0, use (weekDay - 1)
    int dayBit = 1 << (weekDay - 1);
    return dayBit;
  }
}
