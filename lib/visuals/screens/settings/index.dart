import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
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

  Widget _pageBody() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const Gap(200),
          ElevatedButton.icon(
            onPressed: _exportDatabase,
            label: Text("Export"),
            icon: Icon(Icons.import_export),
          ),

          ElevatedButton.icon(
            onPressed: _importDatabase,
            label: Text("Import"),
            icon: Icon(Icons.import_export),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _pageBody());
  }

  Future<String> getSqliteDbPath() async {
    final dir = await getApplicationDocumentsDirectory();
    printAppDirectoriesAndFiles();
    return p.join(dir.path, 'database.sqlite');
  }

  Future<void> printAppDirectoriesAndFiles() async {
    try {
      // Get various directories
      final appDocDir = await getApplicationDocumentsDirectory();
      final appSupportDir = await getApplicationSupportDirectory();
      final tempDir = await getTemporaryDirectory();
      final externalStorageDir = await getExternalStorageDirectory();

      // Print directory paths
      print('Application Documents Directory: ${appDocDir.path}');
      print('Application Support Directory: ${appSupportDir.path}');
      print('Temporary Directory: ${tempDir.path}');
      print('External Storage Directory: ${externalStorageDir?.path}');

      // Function to print files in a directory
      void printFiles(Directory dir) {
        print('\nFiles in ${dir.path}:');
        final files = dir.listSync();
        if (files.isEmpty) {
          print('  (empty)');
        } else {
          for (var file in files) {
            print('  ${file.path}');
          }
        }
      }

      // Print files for each directory
      printFiles(appDocDir);
      printFiles(appSupportDir);
      printFiles(tempDir);
      if (externalStorageDir != null) {
        printFiles(externalStorageDir);
      }
    } catch (e) {
      print('Error getting directories: $e');
    }
  }

  void _importDatabase() async {
    try {
      setState(() => _isImporting = true);

      /// Original DB file
      final originalDbFile = File(await getSqliteDbPath());
      final result = await FilePicker.platform.pickFiles(type: FileType.any);

      if (result == null ||
          result.count < 1 ||
          result.files.first.extension != 'sqlite') {
        throw Exception('Either selected file is null or invalid extension');
      }

      /// Backup DB file
      final backupFile = File(result.files.first.xFile.path);

      if (await backupFile.exists()) {
        /// dispose, clean, copy
        await originalDbFile.delete();
        await backupFile.copy(originalDbFile.path);

        /// let user know about the restart
      } else {
        throw Exception('Backup file does not exist');
      }
    } catch (e) {
      debugPrint("Error occurred while importing database: $e");
    } finally {
      if (mounted) {
        setState(() => _isImporting = false);
      }
    }
  }

  void _exportDatabase() async {
    try {
      setState(() => _isExporting = true);

      /// Get the database path: /data/user/0/com.mindful.android/app_flutter/Mindful.sqlite
      final dbFile = File(await getSqliteDbPath());
      if (!await dbFile.exists()) {
        throw Exception('Database file not found at ${dbFile.path}');
      }

      /// export to file
      final dbFileBytes = await dbFile.readAsBytes();
      final now = DateTime.now();
      final resultPath = await FilePicker.platform.saveFile(
        fileName:
            "Mindful-Backup-${now.year}${now.month}${now.day}-${now.hour}${now.minute}${now.second}.sqlite",
        bytes: Uint8List.fromList(dbFileBytes),
      );

      /// user aborted
      if (resultPath == null) {
        throw Exception('User aborted the exporting operation');
      }
    } catch (e) {
      debugPrint("Error occurred while exporting database: $e");
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }
}
