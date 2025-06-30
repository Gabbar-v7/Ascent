import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class NotesIndex extends StatefulWidget {
  const NotesIndex({super.key});

  @override
  State<NotesIndex> createState() => _NotesIndexState();
}

class _NotesIndexState extends State<NotesIndex> {
  final QuillController _quillController = QuillController.basic();

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontSize: 26, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
                hintText: "Enter title...",
                border: InputBorder.none,
                fillColor: Colors.transparent,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none),
          ),
          Divider(
            indent: 10,
            endIndent: 10,
          ),
          Expanded(
            child: QuillEditor.basic(
              controller: _quillController,
              config: QuillEditorConfig(
                  placeholder: "Enter text...",
                  expands: true,
                  customStyles: DefaultStyles(
                    paragraph: DefaultTextBlockStyle(
                      Theme.of(context).textTheme.titleLarge!,
                      const HorizontalSpacing(8, 8),
                      const VerticalSpacing(8, 8),
                      const VerticalSpacing(8, 8),
                      const BoxDecoration(shape: BoxShape.rectangle),
                    ),
                  )),
            ),
          ),
          QuillSimpleToolbar(
            controller: _quillController,
            config: const QuillSimpleToolbarConfig(
                multiRowsDisplay: false,
                showDividers: false,
                showFontFamily: false,
                showFontSize: false,
                showBoldButton: false,
                showItalicButton: false,
                showSmallButton: false,
                showAlignmentButtons: false,
                showBackgroundColorButton: false,
                showCenterAlignment: false,
                showUndo: false,
                showRedo: false,
                showUnderLineButton: false,
                showStrikeThrough: false,
                showSubscript: false,
                showSuperscript: false,
                showColorButton: false,
                showHeaderStyle: false,
                showInlineCode: false,
                showCodeBlock: false,
                showClearFormat: false,
                showQuote: false),
          ),
        ],
      ),
    );
  }
}
