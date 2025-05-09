import 'package:ascent/database/app_database.dart';
import 'package:ascent/services/drift_service.dart';
import 'package:ascent/visuals/components/app_styles.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _noteTitleController,
            textCapitalization: TextCapitalization.sentences,
          ),
          const Gap(20),
          TextFormField(
            controller: _noteBodyController,
            textCapitalization: TextCapitalization.sentences,
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
        onPressed: () {},
        child: Icon(Icons.save),
      ),
    );
  }
}
