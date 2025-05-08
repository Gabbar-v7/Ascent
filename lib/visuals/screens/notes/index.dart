import "package:ascent/database/app_database.dart";
import "package:ascent/services/drift_service.dart";
import "package:ascent/visuals/components/app_styles.dart";
import "package:ascent/visuals/components/theme_extensions/task_decoration.dart";
import "package:ascent/visuals/screens/notes/view_note.dart";
import "package:flutter/material.dart";
import "package:gap/gap.dart";

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final database = DriftService.instance.driftDb;
  List<Note> _notes = <Note>[];

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    _notes = await database.select(database.notes).get();
  }

  Widget _buildNotesList() {
    return ListView.separated(
      padding: EdgeInsets.all(10),
      itemCount: _notes.length,
      itemBuilder:
          (context, index) => InkWell(
            onTap: () {},
            child: Container(
              decoration:
                  Theme.of(
                    context,
                  ).extension<TaskDecoration>()?.borderedContainer,
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(_notes[index].noteTitle),
                  IconButton(onPressed: () {}, icon: Icon(Icons.arrow_right)),
                ],
              ),
            ),
          ),
      separatorBuilder: (context, index) => const Gap(10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppStyles.appBar("Notes", context),
      body: _buildNotesList(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViewNote()),
            ),
      ),
    );
  }
}
