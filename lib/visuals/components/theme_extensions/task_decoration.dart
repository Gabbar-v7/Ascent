import 'package:flutter/material.dart';

class TaskDecoration extends ThemeExtension<TaskDecoration> {
  final BoxDecoration dateTagContainer;
  final BoxDecoration borderedContainer;
  final Color overdueColor;
  final Color dueColor;

  const TaskDecoration({
    required this.dateTagContainer,
    required this.borderedContainer,
    required this.overdueColor,
    required this.dueColor,
  });

  @override
  ThemeExtension<TaskDecoration> copyWith({
    BoxDecoration? dateTagContainer,
    BoxDecoration? borderedContainer,
    Color? overdueColor,
    Color? dueColor,
  }) {
    return TaskDecoration(
      dateTagContainer: dateTagContainer ?? this.dateTagContainer,
      borderedContainer: borderedContainer ?? this.borderedContainer,
      overdueColor: overdueColor ?? this.overdueColor,
      dueColor: dueColor ?? this.dueColor,
    );
  }

  @override
  ThemeExtension<TaskDecoration> lerp(
    ThemeExtension<TaskDecoration>? other,
    double t,
  ) {
    if (other is! TaskDecoration) return this;

    return TaskDecoration(
      dateTagContainer:
          BoxDecoration.lerp(dateTagContainer, other.dateTagContainer, t)!,
      borderedContainer:
          BoxDecoration.lerp(borderedContainer, other.borderedContainer, t)!,
      overdueColor: Color.lerp(overdueColor, other.overdueColor, t)!,
      dueColor: Color.lerp(dueColor, other.dueColor, t)!,
    );
  }
}
