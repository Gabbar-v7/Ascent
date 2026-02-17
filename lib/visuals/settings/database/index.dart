import 'dart:io';

import 'package:ascent/l10n/generated/app_localizations.dart';
import 'package:ascent/services/drift_service.dart';
import 'package:ascent/utils/drift_utils.dart';
import 'package:ascent/visuals/components/utils/gap_utils.dart';
import 'package:ascent/visuals/components/utils/item_position.dart';
import 'package:ascent/visuals/components/widgets/positioned_button.dart';
import 'package:ascent/visuals/settings/components.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DatabaseIndex extends StatefulWidget {
  const DatabaseIndex({super.key});

  @override
  State<StatefulWidget> createState() => _DatabaseIndexState();
}

class _DatabaseIndexState extends State<DatabaseIndex> {
  late final ThemeData theme = Theme.of(context);
  bool _isImporting = false;
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        GapEnum.section.gap,
        buildSectionHeader(
          AppLocalizations.of(context)!.setting_label_database,
          theme,
        ),
        GapEnum.sectionHeader.gap,
        _buildDatabaseSection(),

        GapEnum.section.gap,
        buildSectionHeader(
          AppLocalizations.of(context)!.setting_label_crashLogs,
          theme,
        ),
        GapEnum.sectionHeader.gap,
        PositionedButton(
          title: AppLocalizations.of(context)!.setting_database_exportCrashLogs,
          subtitle: AppLocalizations.of(
            context,
          )!.setting_database_exportCrashLogsDescription,
          leading: Icon(Icons.file_upload_outlined, size: 28),
          trailing: const Icon(Icons.keyboard_arrow_right_outlined, size: 32),
          position: ItemPosition.top,
          onTap: () {},
        ),
        GapEnum.sectionContent.gap,
        PositionedButton(
          title: AppLocalizations.of(context)!.setting_database_viewLogs,
          subtitle: AppLocalizations.of(
            context,
          )!.setting_database_viewLogsDescription,
          leading: Icon(Icons.description_outlined, size: 28),
          trailing: const Icon(Icons.keyboard_arrow_right_outlined, size: 32),
          position: ItemPosition.mid,
          onTap: () {},
        ),
        GapEnum.sectionContent.gap,
        PositionedButton(
          title: AppLocalizations.of(context)!.setting_database_clearLogs,
          subtitle: AppLocalizations.of(
            context,
          )!.setting_database_clearLogsDescription,
          leading: Icon(Icons.delete_sweep_outlined, size: 28),
          trailing: const Icon(Icons.keyboard_arrow_right_outlined, size: 32),
          position: ItemPosition.bottom,
          onTap: () {},
        ),
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
          trailing: _isImporting
              ? CircularProgressIndicator(
                  constraints: BoxConstraints(maxHeight: 32, maxWidth: 32),
                  strokeWidth: 2,
                )
              : Icon(Icons.keyboard_arrow_right_outlined, size: 32),
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
          trailing: _isExporting
              ? CircularProgressIndicator(
                  constraints: BoxConstraints(maxHeight: 32, maxWidth: 32),
                  strokeWidth: 2,
                )
              : Icon(Icons.keyboard_arrow_right_outlined, size: 32),
          position: ItemPosition.bottom,
          onTap: _exportDatabase,
        ),
      ],
    );
  }

  void _importDatabase() async {
    try {
      setState(() => _isImporting = true);

      /// Original DB file
      final originalDbFile = File(await getDatabasePath());
      final result = await FilePicker.platform.pickFiles(
        compressionQuality: 0,
        type: FileType.custom,
        allowedExtensions: ['bak'],
      );

      if (result == null ||
          result.count < 1 ||
          result.files.first.extension != 'bak') {
        throw Exception('Either selected file is null or invalid extension');
      }

      /// Backup DB file
      final backupFile = File(result.files.first.xFile.path);

      if (await backupFile.exists()) {
        /// dispose, clean, copy
        await DriftService.instance.driftDB.close();
        await originalDbFile.delete();
        await backupFile.copy(originalDbFile.path);

        /// Restart app
        await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      } else {
        throw Exception('Backup file does not exist');
      }
    } catch (e) {
      debugPrint("Error occurred while importing database: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error importing database: $e")));
    } finally {
      if (mounted) {
        setState(() => _isImporting = false);
      }
    }
  }

  void _exportDatabase() async {
    try {
      setState(() => _isExporting = true);

      final dbFile = File(await getDatabasePath());
      if (!await dbFile.exists()) {
        throw Exception('Database file not found at ${dbFile.path}');
      }

      final dbFileBytes = await dbFile.readAsBytes();

      final resultPath = await FilePicker.platform.saveFile(
        fileName: "Ascent (1).bak",
        bytes: Uint8List.fromList(dbFileBytes),
        type: FileType.custom,
        allowedExtensions: ['bak'],
      );

      if (resultPath == null) {
        throw Exception('User aborted the exporting operation');
      }
    } catch (e) {
      debugPrint("Error occurred while exporting database: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error exporting database: $e")));
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }
}
