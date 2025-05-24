import 'package:ascent/database/app_database.dart';
import 'package:ascent/services/drift_service.dart';
import 'package:ascent/visuals/utils/nav_manager.dart';
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
  bool _isSaving = false;

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

  Future<void> _addNote(String title, {String? body}) async {
    try {
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

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note saved successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(
          context,
          true,
        ); // Return true to indicate changes were made
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving note: $e'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _updateNote(
    Note note,
    String newNoteTitle,
    String? newNoteBody,
  ) async {
    try {
      await (database.update(database.notes)
        ..where((tbl) => tbl.id.equals(note.id))).write(
        NotesCompanion(
          noteTitle: drift.Value(newNoteTitle),
          noteBody: drift.Value(newNoteBody),
          updatedAt: drift.Value(DateTime.now()),
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note updated successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(
          context,
          true,
        ); // Return true to indicate changes were made
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating note: $e'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _buildAppBar() {
    return TextField(
      controller: _noteTitleController,
      textCapitalization: TextCapitalization.sentences,
      style: Theme.of(context).textTheme.headlineLarge,
      decoration: const InputDecoration(
        hintText: 'Title',
        hintStyle: TextStyle(color: Colors.grey),
        fillColor: Colors.transparent,
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        border: InputBorder.none,
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Body input field that takes the rest of the space
          Expanded(
            child: TextFormField(
              controller: _noteBodyController,
              textCapitalization: TextCapitalization.sentences,
              style: Theme.of(context).textTheme.bodyMedium,
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
      onPressed:
          _isSaving
              ? null
              : () async {
                if (_noteTitleController.text.trim().isNotEmpty) {
                  setState(() {
                    _isSaving = true;
                  });

                  try {
                    if (widget.note == null) {
                      await _addNote(
                        _noteTitleController.text.trim(),
                        body:
                            _noteBodyController.text.trim().isEmpty
                                ? null
                                : _noteBodyController.text.trim(),
                      );
                    } else {
                      await _updateNote(
                        widget.note!,
                        _noteTitleController.text.trim(),
                        _noteBodyController.text.trim().isEmpty
                            ? null
                            : _noteBodyController.text.trim(),
                      );
                    }
                  } finally {
                    if (mounted) {
                      setState(() {
                        _isSaving = false;
                      });
                    }
                  }
                } else {
                  // Show a snackbar indicating title is required
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please add a title for your note'),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
      child:
          _isSaving
              ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
              : const Icon(Icons.save),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => NavManager.popPage(context),
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
        title: _buildAppBar(),
      ),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }
}
