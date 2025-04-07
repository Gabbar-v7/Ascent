import 'package:flutter/material.dart';

class GeneralDecoration extends ThemeExtension<GeneralDecoration> {
  final ButtonStyle secondaryButton;

  const GeneralDecoration({required this.secondaryButton});

  @override
  ThemeExtension<GeneralDecoration> copyWith({ButtonStyle? secondaryButton}) {
    return GeneralDecoration(
      secondaryButton: secondaryButton ?? this.secondaryButton,
    );
  }

  @override
  ThemeExtension<GeneralDecoration> lerp(
    ThemeExtension<GeneralDecoration>? other,
    double t,
  ) {
    if (other is! GeneralDecoration) return this;

    return GeneralDecoration(
      secondaryButton:
          ButtonStyle.lerp(secondaryButton, other.secondaryButton, t)!,
    );
  }
}
