import 'package:flutter/material.dart';

/// Creates a section header with consistent styling
Widget buildSectionHeader(String title, ThemeData theme) {
  return Text(
    "  $title",
    style: theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurface,
    ),
  );
}

/// A generic dialog widget for displaying and selecting from a list of options.
/// This component provides a consistent interface for all settings dialogs.
class SettingsDialog<T> extends StatelessWidget {
  /// The title displayed at the top of the dialog
  final String title;

  /// List of available options to choose from
  final List<T> options;

  /// The currently selected option
  final T currentSelection;

  /// Callback function when an option is selected
  final void Function(T option) onOptionSelected;

  /// Builder function to create the widget for each option
  final Widget Function(T option) optionBuilder;

  const SettingsDialog({
    super.key,
    required this.title,
    required this.options,
    required this.currentSelection,
    required this.onOptionSelected,
    required this.optionBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      contentPadding: const EdgeInsets.all(10),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: options.length,
          itemBuilder: (context, index) {
            final option = options[index];
            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                onOptionSelected(option);
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: optionBuilder(option),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// A widget representing a single option within a settings dialog.
/// Provides consistent styling and behavior for dialog options.
class SettingsDialogOption extends StatelessWidget {
  /// The title text for the option
  final String title;

  /// Optional icon to display on the left side
  final IconData? icon;

  /// Optional custom widget to display on the left side instead of an icon
  final Widget? leading;

  /// Whether this option is currently selected
  final bool isSelected;

  const SettingsDialogOption({
    super.key,
    required this.title,
    required this.isSelected,
    this.icon,
    this.leading,
  }) : assert(
         icon == null || leading == null,
         'Cannot provide both icon and leading widget',
       );

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: leading ?? (icon != null ? Icon(icon) : null),
      trailing: isSelected
          ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
          : null,
    );
  }
}
