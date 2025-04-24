import 'dart:async';
import 'dart:io';

import 'package:ascent/visuals/components/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool _isExporting = false;
  bool _isImporting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppStyles.appBar('Settings', context),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const Gap(24),
                _buildBackupRestoreCard(),
                const Gap(12),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackupRestoreCard() {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colors.surfaceContainerHighest.withAlpha(76), // ~0.3 opacity
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colors.outlineVariant.withAlpha(127), // ~0.5 opacity
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildSectionHeader(
              icon: Icons.storage_rounded,
              title: 'Backup & Restore',
              subtitle: 'Export or import your database file',
              iconColor: colors.onPrimaryContainer,
              iconBackground: colors.primaryContainer,
            ),
            const Gap(24),
            _buildActionButton(
              label: 'Export Database',
              icon: Icons.upload_rounded,
              isLoading: _isExporting,
              onPressed: _isExporting ? null : _exportDatabase,
              isPrimary: true,
            ),
            const Gap(12),
            _buildActionButton(
              label: 'Import Database',
              icon: Icons.download_rounded,
              isLoading: _isImporting,
              onPressed: _isImporting ? null : _importDatabase,
              isPrimary: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required Color iconBackground,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconBackground,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        const Gap(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const Gap(4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required bool isLoading,
    required VoidCallback? onPressed,
    required bool isPrimary,
  }) {
    final colors = Theme.of(context).colorScheme;
    final backgroundColor =
        isPrimary ? colors.primary : colors.secondaryContainer;
    final foregroundColor =
        isPrimary ? colors.onPrimary : colors.onSecondaryContainer;

    return FilledButton.tonalIcon(
      onPressed: onPressed,
      icon:
          isLoading
              ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: foregroundColor,
                ),
              )
              : Icon(icon),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
    );
  }

  Future<String> _getDatabasePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, 'database.sqlite');
  }

  Future<void> _showSnackBar(String message, {bool isError = false}) async {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      ),
    );
  }

  Future<void> _importDatabase() async {
    try {
      setState(() => _isImporting = true);

      final originalDbFile = File(await _getDatabasePath());
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        throw Exception('No file selected');
      }

      final selectedFile = File(result.files.single.path!);
      final extension = p.extension(selectedFile.path).toLowerCase();

      if (extension != '.x-sqlite3' && extension != '.sqlite') {
        throw Exception('Please select a .sqlite file');
      }

      if (!await selectedFile.exists()) {
        throw Exception('Selected file does not exist');
      }

      // Create backup
      final backupPath = '${originalDbFile.path}.backup';
      if (await originalDbFile.exists()) {
        await originalDbFile.copy(backupPath);
      }

      // Replace database
      await originalDbFile.delete();
      await selectedFile.copy(originalDbFile.path);

      await _showSnackBar('Database imported successfully');
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } catch (e) {
      await _showSnackBar('Import failed: ${e.toString()}', isError: true);
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }

  Future<void> _exportDatabase() async {
    try {
      setState(() => _isExporting = true);

      final dbFile = File(await _getDatabasePath());
      if (!await dbFile.exists()) {
        throw Exception('Database file not found at ${dbFile.path}');
      }

      final resultPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Database Backup',
        fileName: 'Ascent-Backup.x-sqlite3',
        type: FileType.custom,
        allowedExtensions: ['x-sqlite3', 'sqlite'],
        bytes: await dbFile.readAsBytes(),
      );

      if (resultPath == null) throw Exception('Export cancelled by user');
      await _showSnackBar('Database exported successfully to $resultPath');
    } catch (e) {
      await _showSnackBar('Export failed: ${e.toString()}', isError: true);
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }
}
