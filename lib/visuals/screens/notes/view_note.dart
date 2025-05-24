import 'package:ascent/database/app_database.dart';
import 'package:ascent/services/drift_service.dart';
import 'package:ascent/visuals/components/app_styles.dart';
import 'package:ascent/visuals/screens/notes/edit_note.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

class ViewNote extends StatefulWidget {
  final Note note;
  const ViewNote(this.note, {super.key});

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  late Note _note;
  final database = DriftService.instance.driftDB;

  @override
  void initState() {
    super.initState();
    _note = widget.note;
    fetchNote(); // Call fetchNote to get the latest data
  }

  void fetchNote() async {
    try {
      final query = database.select(database.notes)
        ..where((tbl) => tbl.id.equals(_note.id));

      final result = await query.getSingleOrNull();

      if (result != null && mounted) {
        setState(() {
          _note = result;
        });
      }
    } catch (e) {
      // Handle error appropriately
      debugPrint('Error fetching note: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppStyles.appBar(
        _note.noteTitle,
        context,
        actions: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: IconButton(
              visualDensity: VisualDensity.compact,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: const Icon(Icons.format_list_bulleted),
              onPressed: () {},
              iconSize: 22,
            ),
          ),
          const Gap(10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 8.0, bottom: 8, left: 8),
        child: ListView(children: [GptMarkdown(_note.noteBody ?? "")]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditNote(_note)),
            ).then((value) {
              // Refresh the note when returning from edit screen
              if (value == true) {
                fetchNote();
              }
            }),
        child: const Icon(Icons.edit),
      ),
    );
  }
}
