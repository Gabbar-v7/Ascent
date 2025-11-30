import 'package:ascent/utils/preference_provider.dart';
import 'package:ascent/visuals/components/utils/gap_utils.dart';
import 'package:ascent/visuals/components/utils/item_position.dart';
import 'package:ascent/visuals/components/widgets/positioned_button.dart';
import 'package:ascent/visuals/settings/general/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeneralIndex extends ConsumerStatefulWidget {
  const GeneralIndex({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GeneralIndexState();
}

class _GeneralIndexState extends ConsumerState<GeneralIndex> {
  late final AppPreferencesNotifier preferencesNotifier = ref
      .read<AppPreferencesNotifier>(preferenceProvider.notifier);
  late final preference = ref.watch(preferenceProvider);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      children: [
        GapEnum.section.gap,
        buildSectionHeader('Appearance', theme),
        GapEnum.sectionHeader.gap,
        _buildAppearanceSection(context, theme),
        GapEnum.section.gap,
        buildSectionHeader('Defaults', theme),
        GapEnum.sectionHeader.gap,
        _buildDefaultsSection(context, theme),
      ],
    );
  }

  /// Builds the appearance settings section containing theme and color options
  Widget _buildAppearanceSection(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        PositionedButton(
          title: 'Theme Mode',
          subtitle: preference.themeMode.name,
          leading: Icon(_getThemeModeIcon(preference.themeMode)),
          trailing: const Icon(Icons.arrow_drop_down_rounded, size: 42),
          position: ItemPosition.top,
          onTap: () => _showThemeModeDialog(context),
        ),
        GapEnum.sectionContent.gap,
        PositionedButton(
          title: 'Color Scheme',
          subtitle: preference.colorScheme.name,
          leading: _buildColorIndicator(preference.colorScheme, theme),
          trailing: const Icon(Icons.arrow_drop_down_rounded, size: 42),
          position: ItemPosition.bottom,
          onTap: () => _showColorSchemeDialog(context),
        ),
      ],
    );
  }

  /// Builds the defaults settings section containing language options
  Widget _buildDefaultsSection(BuildContext context, ThemeData theme) {
    return PositionedButton(
      title: 'App language',
      subtitle: preference.language.name,
      leading: Icon(Icons.language_outlined),
      trailing: const Icon(Icons.arrow_drop_down_rounded, size: 42),
      position: ItemPosition.none,
      onTap: () => _showLanguageDialog(context),
    );
  }

  /// Creates a color indicator widget for the color scheme option
  Widget _buildColorIndicator(AppColorSchemeEnum colorScheme, ThemeData theme) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: colorScheme.color,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  /// Returns the appropriate icon for the given theme mode
  IconData _getThemeModeIcon(AppThemeMode themeMode) {
    switch (themeMode) {
      case AppThemeMode.light:
        return Icons.wb_twilight;
      case AppThemeMode.dark:
        return Icons.dark_mode_outlined;
      case AppThemeMode.system:
        return Icons.contrast;
    }
  }

  /// Displays a dialog for selecting theme mode
  void _showThemeModeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => SettingsDialog<AppThemeMode>(
        title: 'Theme Mode',
        options: AppThemeMode.values,
        currentSelection: preference.themeMode,
        onOptionSelected: (mode) => preferencesNotifier.themeMode = mode,
        optionBuilder: (mode) => SettingsDialogOption(
          title: mode.name,
          icon: _getThemeModeIcon(mode),
          isSelected: preference.themeMode == mode,
        ),
      ),
    );
  }

  /// Displays a dialog for selecting color scheme
  void _showColorSchemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => SettingsDialog<AppColorSchemeEnum>(
        title: 'Color Scheme',
        options: AppColorSchemeEnum.values,
        currentSelection: preference.colorScheme,
        onOptionSelected: (scheme) => preferencesNotifier.colorScheme = scheme,
        optionBuilder: (scheme) => SettingsDialogOption(
          title: scheme.name,
          leading: _buildColorIndicator(scheme, Theme.of(context)),
          isSelected: preference.colorScheme == scheme,
        ),
      ),
    );
  }

  /// Displays a dialog for selecting application language
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => SettingsDialog<AppLanguageEnum>(
        title: 'App Language',
        options: AppLanguageEnum.values,
        currentSelection: preference.language,
        onOptionSelected: (language) => preferencesNotifier.language = language,
        optionBuilder: (language) => SettingsDialogOption(
          title: language.name,
          icon: Icons.language_outlined,
          isSelected: preference.language == language,
        ),
      ),
    );
  }
}
