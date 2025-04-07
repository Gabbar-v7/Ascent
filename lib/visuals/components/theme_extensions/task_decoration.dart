import 'package:flutter/material.dart';

class TaskDecoration extends ThemeExtension<TaskDecoration> {
  final BoxDecoration dateTagContainer;
  final BoxDecoration borderedContainer;
  final TextStyle taskTitleStyle;
  final TextStyle taskBodyStyle;
  final Color overdueColor;
  final Color dueColor;

  const TaskDecoration({
    required this.dateTagContainer,
    required this.borderedContainer,
    required this.taskTitleStyle,
    required this.taskBodyStyle,
    required this.overdueColor,
    required this.dueColor,
  });

  @override
  ThemeExtension<TaskDecoration> copyWith({
    BoxDecoration? dateTagContainer,
    BoxDecoration? borderedContainer,
    TextStyle? taskTitleStyle,
    TextStyle? taskBodyStyle,
    Color? overdueColor,
    Color? dueColor,
  }) {
    return TaskDecoration(
      dateTagContainer: dateTagContainer ?? this.dateTagContainer,
      borderedContainer: borderedContainer ?? this.borderedContainer,
      taskTitleStyle: taskTitleStyle ?? this.taskTitleStyle,
      taskBodyStyle: taskBodyStyle ?? this.taskBodyStyle,
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
      taskTitleStyle: TextStyle.lerp(taskTitleStyle, other.taskTitleStyle, t)!,
      taskBodyStyle: TextStyle.lerp(taskBodyStyle, other.taskBodyStyle, t)!,
      overdueColor: Color.lerp(overdueColor, other.overdueColor, t)!,
      dueColor: Color.lerp(dueColor, other.dueColor, t)!,
    );
  }
}
