import 'dart:async';
import 'dart:io';

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

  Widget _pageBody() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Gap(40),
              Text(
                'Database Management',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(40),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(Icons.storage, size: 48, color: Colors.blue),
                      const Gap(16),
                      Text(
                        'Backup & Restore',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Gap(24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isExporting ? null : _exportDatabase,
                          icon:
                              _isExporting
                                  ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Icon(Icons.upload),
                          label: const Text("Export Database"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const Gap(16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isImporting ? null : _importDatabase,
                          icon:
                              _isImporting
                                  ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Icon(Icons.download),
                          label: const Text("Import Database"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: Stack(
        children: [
          _pageBody(),
          if (_countdown > 0)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Restarting in',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      const Gap(16),
                      Text(
                        '$_countdown',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(16),
                      Text(
                        'Please wait...',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
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

      // Create export filename with timestamp
      final now = DateTime.now();
      final timestamp =
          '${now.year}-${now.month.toString().padLeft(2, '0')}'
          '${now.day.toString().padLeft(2, '0')}-'
          '${now.hour.toString().padLeft(2, '0')}'
          '${now.minute.toString().padLeft(2, '0')}'
          '${now.second.toString().padLeft(2, '0')}';

      // Let user choose save location
      final resultPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Database Backup',
        fileName: 'Ascent-Backup-$timestamp.sqlite',
        bytes: Uint8List.fromList(dbFileBytes),
      );

      if (resultPath == null) {
        throw Exception('Export cancelled by user');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Database exported successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: ${e.toString()}'),
            backgroundColor: Colors.red,
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
