import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';

void launchConfetti(BuildContext context, bool mounted) {
  if (!mounted) return;

  final colors = [
    Theme.of(context).colorScheme.primary,
    Theme.of(context).colorScheme.onSecondaryContainer,
  ];

  Confetti.launch(
    context,
    options: ConfettiOptions(
      particleCount: 100,
      scalar: 1.5,
      angle: 60,
      spread: 55,
      startVelocity: 60,
      gravity: 0.5,
      x: 0,
      y: 1,
      colors: colors,
    ),
    onFinished: (overlay) => overlay.remove(),
  );

  Confetti.launch(
    context,
    options: ConfettiOptions(
      particleCount: 100,
      scalar: 1.5,
      angle: 120,
      spread: 55,
      startVelocity: 60,
      gravity: 0.5,
      x: 1,
      y: 1,
      colors: colors,
    ),
    onFinished: (overlay) => overlay.remove(),
  );
}
