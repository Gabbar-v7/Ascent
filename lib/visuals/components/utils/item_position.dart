import 'package:flutter/material.dart';

enum ItemPosition {
  none,
  fit,
  topLeft,
  top,
  topRight,
  left,
  mid,
  right,
  bottomLeft,
  bottom,
  bottomRight,
}

/// Creates [BorderRadius] from the given [ItemPosition] for the group item
BorderRadius getBorderRadiusFromPosition(ItemPosition position) =>
    switch (position) {
      /// Nothing
      ItemPosition.fit => BorderRadius.circular(0),

      /// Default all sides
      ItemPosition.none => BorderRadius.circular(24),

      /// Top
      ItemPosition.topLeft =>
        const BorderRadius.all(Radius.circular(6)).copyWith(
          topLeft: const Radius.circular(24),
        ),
      ItemPosition.top => const BorderRadius.vertical(
          top: Radius.circular(24),
          bottom: Radius.circular(6),
        ),
      ItemPosition.topRight =>
        const BorderRadius.all(Radius.circular(6)).copyWith(
          topRight: const Radius.circular(24),
        ),

      // Mid
      ItemPosition.left => const BorderRadius.horizontal(
          right: Radius.circular(6),
          left: Radius.circular(24),
        ),
      ItemPosition.mid => BorderRadius.circular(6),
      ItemPosition.right => const BorderRadius.horizontal(
          left: Radius.circular(6),
          right: Radius.circular(24),
        ),

      // Bottom
      ItemPosition.bottomLeft =>
        const BorderRadius.all(Radius.circular(6)).copyWith(
          bottomLeft: const Radius.circular(24),
        ),
      ItemPosition.bottom => const BorderRadius.vertical(
          top: Radius.circular(6),
          bottom: Radius.circular(24),
        ),
      ItemPosition.bottomRight =>
        const BorderRadius.all(Radius.circular(6)).copyWith(
          bottomRight: const Radius.circular(24),
        ),
    };
