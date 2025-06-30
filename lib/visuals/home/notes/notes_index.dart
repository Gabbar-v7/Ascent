import 'package:ascent/database/app_database.dart';
import 'package:ascent/services/drift_service.dart';
import 'package:ascent/visuals/home/notes/widgets.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NotesIndex extends StatefulWidget {
  const NotesIndex({super.key});

  @override
  State<NotesIndex> createState() => _NotesIndexState();
}

class _NotesIndexState extends State<NotesIndex> {
  final database = DriftService.instance.driftDB;
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  void _fetchNotes() async {
    notes = await (database.select(database.notes)
          ..where((tbl) =>
              tbl.archived.isNotValue(true) & tbl.trashed.isNotValue(true))
          ..orderBy([
            (tbl) =>
                OrderingTerm(expression: tbl.updatedAt, mode: OrderingMode.desc)
          ]))
        .get();
    setState(() {
      notes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: _noteTileBuilder,
        separatorBuilder: _sepratorBuilder,
        itemCount: notes.length);
  }

  Widget _noteTileBuilder(BuildContext context, int index) {
    return noteTilePlainText(context, notes[index]);
  }

  Widget _sepratorBuilder(BuildContext context, int index) {
    return const Gap(5);
  }
}
