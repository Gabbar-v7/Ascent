import 'package:ascent/database/app_database.dart';
import 'package:ascent/services/drift_service.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';

class EditNote extends StatefulWidget {
  final Note? note;
  const EditNote(this.note, {super.key});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  final database = DriftService.instance.driftDB;
  late final TextEditingController _noteTitleController;
  late final TextEditingController _noteBodyController;

  @override
  void initState() {
    super.initState();
    _noteTitleController = TextEditingController(
      text: widget.note?.noteTitle ?? '',
    );
    _noteBodyController = TextEditingController(
      text: widget.note?.noteBody ?? '',
    );
  }

  @override
  void dispose() {
    _noteTitleController.dispose();
    _noteBodyController.dispose();
    super.dispose();
  }

  void _addNote(String title, {String? body}) async {
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

  Future<void> _updateNote(
    Note note,
    String newNoteTitle,
    String? newNoteBody,
  ) async {
    await (database.update(database.notes)
      ..where((tbl) => tbl.id.equals(note.id))).write(
      NotesCompanion(
        noteTitle: drift.Value(newNoteTitle),
        noteBody: drift.Value(newNoteBody),
        updatedAt: drift.Value(DateTime.now()),
      ),
    );
  }

  Widget _buildAppBar() {
    return TextField(
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
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
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

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (_noteTitleController.text.isNotEmpty) {
          if (widget.note == null)
            _addNote(_noteTitleController.text, body: _noteBodyController.text);
          else
            _updateNote(
              widget.note!,
              _noteTitleController.text,
              _noteBodyController.text,
            );
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: // Title input field
            _buildAppBar(),
      ),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }
}
