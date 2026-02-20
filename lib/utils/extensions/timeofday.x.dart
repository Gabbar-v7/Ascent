import 'package:flutter/material.dart';

extension TimeOfDayX on TimeOfDay {
  int get toInt => hour * 60 + minute;
}
