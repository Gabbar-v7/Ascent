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
  int _countdown = 0;
  Timer? _countdownTimer;

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppStyles.appBar('Settings', context),
      body: Stack(
        children: [
          _pageBody(colorScheme),
          if (_countdown > 0) _countdownOverlay(),
        ],
      ),
    );
  }

  Widget _pageBody(ColorScheme colorScheme) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(24),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Database Management',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const Gap(12),
                _buildBackupRestoreSection(colorScheme),
                const Gap(24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackupRestoreSection(ColorScheme colorScheme) {
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: ShapeDecoration(
                    color: colorScheme.primaryContainer,
                    shape: const CircleBorder(),
                  ),
                  child: Icon(
                    Icons.storage_rounded,
                    color: colorScheme.onPrimaryContainer,
                    size: 28,
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Backup & Restore',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Gap(4),
                      Text(
                        'Export or import your database file',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(24),
            _buildActionButton(
              label: 'Export Database',
              icon: Icons.upload_rounded,
              isLoading: _isExporting,
              onPressed: _isExporting ? null : _exportDatabase,
              colorScheme: colorScheme,
              isPrimary: true,
            ),
            const Gap(12),
            _buildActionButton(
              label: 'Import Database',
              icon: Icons.download_rounded,
              isLoading: _isImporting,
              onPressed: _isImporting ? null : _importDatabase,
              colorScheme: colorScheme,
              isPrimary: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required bool isLoading,
    required VoidCallback? onPressed,
    required ColorScheme colorScheme,
    required bool isPrimary,
  }) {
    return FilledButton.tonalIcon(
      onPressed: onPressed,
      icon:
          isLoading
              ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color:
                      isPrimary
                          ? colorScheme.onPrimary
                          : colorScheme.onSecondaryContainer,
                ),
              )
              : Icon(icon),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor:
            isPrimary ? colorScheme.primary : colorScheme.secondaryContainer,
        foregroundColor:
            isPrimary
                ? colorScheme.onPrimary
                : colorScheme.onSecondaryContainer,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
    );
  }

  Widget _countdownOverlay() {
    return Positioned.fill(
      child: Material(
        color: Colors.black.withValues(alpha: 0.7),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const Gap(24),
                Text(
                  'Restarting in $_countdown',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Gap(8),
                Text(
                  'Please wait while the app restarts',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> getSqliteDbPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, 'database.sqlite');
  }

  void _importDatabase() async {
    try {
      setState(() {
        _isImporting = true;
        _countdown = 0;
      });

      // Get original DB file
      final originalDbFile = File(await getSqliteDbPath());

      // Use FilePicker to select any file (we'll check extension manually)
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        throw Exception('No file selected');
      }

      final selectedFile = File(result.files.single.path!);
      final extension = p.extension(selectedFile.path).toLowerCase();

      if (extension != '.sqlite') {
        throw Exception('Please select a .sqlite file');
      }

      if (!await selectedFile.exists()) {
        throw Exception('Selected file does not exist');
      }

      // Create backup of current database
      final backupPath = '${originalDbFile.path}.backup';
      if (await originalDbFile.exists()) {
        await originalDbFile.copy(backupPath);
      }

      // Replace database
      await originalDbFile.delete();
      await selectedFile.copy(originalDbFile.path);

      // Start countdown
      setState(() => _countdown = 5);
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_countdown > 1) {
          setState(() => _countdown--);
        } else {
          timer.cancel();
          // Restart app or reload database here
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Import failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 100,
              left: 16,
              right: 16,
            ),
          ),
        );
      }
      debugPrint("Error occurred while importing database: $e");
    } finally {
      if (mounted && _countdown == 0) {
        setState(() => _isImporting = false);
      }
    }
  }

  void _exportDatabase() async {
    try {
      setState(() => _isExporting = true);

      // Get the database path
      final dbFile = File(await getSqliteDbPath());
      if (!await dbFile.exists()) {
        throw Exception('Database file not found at ${dbFile.path}');
      }

      final dbFileBytes = await dbFile.readAsBytes();

      // Let user choose save location
      final resultPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Database Backup',
        fileName: 'Ascent-Backup.sqlite',
        bytes: Uint8List.fromList(dbFileBytes),
      );

      if (resultPath == null) {
        throw Exception('Export cancelled by user');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.white),
                const Gap(12),
                const Text('Database exported successfully'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 100,
              left: 16,
              right: 16,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 100,
              left: 16,
              right: 16,
            ),
          ),
        );
      }
      debugPrint("Error occurred while exporting database: $e");
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }
}
