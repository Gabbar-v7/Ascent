import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class NotesIndex extends StatefulWidget {
  const NotesIndex({super.key});

  @override
  State<NotesIndex> createState() => _NotesIndexState();
}

class _NotesIndexState extends State<NotesIndex> {
  final QuillController _controller = QuillController.basic();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          QuillSimpleToolbar(
            controller: _controller,
            config: const QuillSimpleToolbarConfig(),
          ),
          SizedBox(
            height: 100,
            width: double.infinity,
            child: QuillEditor.basic(
              controller: _controller,
              config: const QuillEditorConfig(),
            ),
          )
        ],
      ),
    );
  }
}
