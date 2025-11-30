import 'package:ascent/visuals/components/utils/item_position.dart';
import 'package:flutter/material.dart';

/// A reusable button button that changes its border radius depending on its position
/// for displaying and interacting material list view buttons.
class PositionedButton extends StatelessWidget {
  /// The main title text for the button
  final String title;

  /// The subtitle text displaying the current value
  final String subtitle;

  /// Optional custom widget to display on the left side instead of an icon
  final Widget? leading;

  /// Optional custom widget to display on the left side instead of an icon
  final Widget? trailing;

  /// The position of this option within a group (affects border radius)
  final ItemPosition position;

  /// Callback function when the option is tapped
  final VoidCallback onTap;

  const PositionedButton({
    super.key,
    this.leading,
    required this.title,
    required this.subtitle,
    this.trailing,
    required this.onTap,
    this.position = ItemPosition.none,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: getBorderRadiusFromPosition(position),
        color: theme.colorScheme.surfaceContainer,
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: ListTile(
          trailing: trailing,
          title: Text(title),
          subtitle: Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.disabledColor,
            ),
          ),
          leading: leading,
        ),
      ),
    );
  }
}

/// Creates [BorderRadius] from the given [ItemPosition] for the group item
BorderRadius getBorderRadiusFromPosition(ItemPosition position) =>
    switch (position) {
      /// Nothing
      ItemPosition.fit => BorderRadius.circular(0),

      /// Default all sides
      ItemPosition.none => BorderRadius.circular(24),

      /// Top
      ItemPosition.topLeft => const BorderRadius.all(
        Radius.circular(6),
      ).copyWith(topLeft: const Radius.circular(24)),
      ItemPosition.top => const BorderRadius.vertical(
        top: Radius.circular(24),
        bottom: Radius.circular(6),
      ),
      ItemPosition.topRight => const BorderRadius.all(
        Radius.circular(6),
      ).copyWith(topRight: const Radius.circular(24)),

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
      ItemPosition.bottomLeft => const BorderRadius.all(
        Radius.circular(6),
      ).copyWith(bottomLeft: const Radius.circular(24)),
      ItemPosition.bottom => const BorderRadius.vertical(
        top: Radius.circular(6),
        bottom: Radius.circular(24),
      ),
      ItemPosition.bottomRight => const BorderRadius.all(
        Radius.circular(6),
      ).copyWith(bottomRight: const Radius.circular(24)),
    };
