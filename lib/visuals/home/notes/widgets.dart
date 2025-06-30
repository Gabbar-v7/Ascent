import 'package:ascent/database/app_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

Widget noteTilePlainText(BuildContext context, Note note) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          if (note.noteTitle?.isNotEmpty == true)
            Text(
              note.noteTitle!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),

          const SizedBox(height: 8),

          // Content as plain text
          if (note.noteBody != null)
            Text(
              Document.fromDelta(note.noteBody!).toPlainText(),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            )
          else
            Text(
              'No content',
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ],
      ),
    ),
  );
}
