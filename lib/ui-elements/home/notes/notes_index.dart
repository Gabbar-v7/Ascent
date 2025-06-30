import 'package:ascent/services/drift_service.dart';
import 'package:flutter/material.dart';

class NotesIndex extends StatefulWidget {
  const NotesIndex({super.key});

  @override
  State<NotesIndex> createState() => _NotesIndexState();
}

class _NotesIndexState extends State<NotesIndex> {
  final database = DriftService.instance.driftDB;

  @override
  Widget build(BuildContext context) {
    return Column();
  }
}
