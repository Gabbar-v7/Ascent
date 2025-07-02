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
