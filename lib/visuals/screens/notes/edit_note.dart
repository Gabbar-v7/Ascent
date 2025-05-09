import 'package:ascent/database/app_database.dart';
import 'package:ascent/services/drift_service.dart';
import 'package:ascent/visuals/components/app_styles.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';

class EditNote extends StatefulWidget {
  const EditNote({super.key});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  final database = DriftService.instance.driftDB;
  final TextEditingController _noteTitleController = TextEditingController();
  final TextEditingController _noteBodyController = TextEditingController();

  void saveNote(String title, {Note? note, String? body}) async {
    await database
        .into(database.notes)
        .insert(
          NotesCompanion.insert(
            noteTitle: title,
            noteBody: drift.Value(body),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        spacing: 0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Title input field
          TextField(
            controller: _noteTitleController,
            textCapitalization: TextCapitalization.sentences,
            style: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              hintText: 'Title',
              hintStyle: TextStyle(color: Colors.grey),
              fillColor: Colors.transparent,
              contentPadding: EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 8.0,
              ),
            ),
          ),
          Divider(indent: 4, endIndent: 4),
          // Body input field that takes the rest of the space
          Expanded(
            child: TextFormField(
              controller: _noteBodyController,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(
                fontSize: 16.0,
                height: 1.5,
                color: Colors.white70,
              ),
              maxLines: null, // Allows for unlimited lines
              expands: true, // Takes up all available space
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(
                hintText: 'Start typing...',
                hintStyle: TextStyle(color: Colors.grey),
                fillColor: Colors.transparent,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 8.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppStyles.appBar('Edit Note', context),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_noteTitleController.text.isNotEmpty) {
            saveNote(_noteTitleController.text, body: _noteBodyController.text);
            Navigator.pop(context);
          } else {
            // Show a snackbar or dialog indicating title is required
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please add a title for your note'),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
