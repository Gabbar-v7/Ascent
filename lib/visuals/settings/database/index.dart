import 'package:ascent/l10n/generated/app_localizations.dart';
import 'package:ascent/visuals/components/utils/gap_utils.dart';
import 'package:ascent/visuals/components/utils/item_position.dart';
import 'package:ascent/visuals/components/widgets/positioned_button.dart';
import 'package:ascent/visuals/settings/components.dart';
import 'package:flutter/material.dart';

class DatabaseIndex extends StatefulWidget {
  const DatabaseIndex({super.key});

  @override
  State<StatefulWidget> createState() => _DatabaseIndexState();
}

class _DatabaseIndexState extends State<DatabaseIndex> {
  late final ThemeData theme = Theme.of(context);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        GapEnum.section.gap,
        buildSectionHeader("Database", theme),
        GapEnum.sectionHeader.gap,
        _buildDatabaseSection(),
      ],
    );
  }

  Widget _buildDatabaseSection() {
    return Column(
      children: [
        PositionedButton(
          title: AppLocalizations.of(context)!.setting_database_import,
          subtitle: AppLocalizations.of(
            context,
          )!.setting_database_importDescription,
          leading: Icon(Icons.file_download_outlined, size: 28),
          trailing: Icon(Icons.keyboard_arrow_right_outlined, size: 32),
          position: ItemPosition.top,
          onTap: _importDatabase,
        ),
        GapEnum.sectionContent.gap,
        PositionedButton(
          title: AppLocalizations.of(context)!.setting_database_export,
          subtitle: AppLocalizations.of(
            context,
          )!.setting_database_exportDescription,
          leading: Icon(Icons.file_upload_outlined, size: 28),
          trailing: Icon(Icons.keyboard_arrow_right_outlined, size: 32),
          position: ItemPosition.bottom,
          onTap: _exportDatabase,
        ),
      ],
    );
  }

  void _importDatabase() {}

  void _exportDatabase() {}
}
