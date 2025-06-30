import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

enum SingleCharacterFormatStyle {
  italic,
  bold,
  // Add other styles as needed
}

bool handleFormatByWrappingWithSingleCharacter({
  required QuillController controller,
  required String character,
  required SingleCharacterFormatStyle formatStyle,
}) {
  final selection = controller.selection;

  // If no text is selected, return false to let default behavior handle it
  if (selection.isCollapsed) {
    return false;
  }

  final selectedText = controller.document.getPlainText(
    selection.start,
    selection.end - selection.start,
  );

  // Check if text is already wrapped with the character
  final isAlreadyWrapped = selectedText.startsWith(character) &&
      selectedText.endsWith(character) &&
      selectedText.length > character.length * 2;

  String newText;
  int newSelectionStart;
  int newSelectionEnd;

  if (isAlreadyWrapped) {
    // Remove the wrapping characters
    newText = selectedText.substring(
        character.length, selectedText.length - character.length);
    newSelectionStart = selection.start;
    newSelectionEnd = selection.start + newText.length;
  } else {
    // Add the wrapping characters
    newText = '$character$selectedText$character';
    newSelectionStart = selection.start;
    newSelectionEnd = selection.start + newText.length;
  }

  // Replace the selected text
  controller.replaceText(
    selection.start,
    selection.end - selection.start,
    newText,
    TextSelection.collapsed(offset: newSelectionEnd),
  );

  // Apply the appropriate formatting based on the style
  if (!isAlreadyWrapped) {
    _applyFormatting(
        controller, formatStyle, newSelectionStart, newSelectionEnd);
  }

  return true;
}

void _applyFormatting(
  QuillController controller,
  SingleCharacterFormatStyle style,
  int start,
  int end,
) {
  final attribute = _getAttributeForStyle(style);
  if (attribute != null) {
    controller.formatText(start, end - start, attribute);
  }
}

Attribute? _getAttributeForStyle(SingleCharacterFormatStyle style) {
  switch (style) {
    case SingleCharacterFormatStyle.italic:
      return Attribute.italic;
    case SingleCharacterFormatStyle.bold:
      return Attribute.bold;
  }
}

// Example usage with your shortcut event
CharacterShortcutEvent asteriskToItalicStyleEvent = CharacterShortcutEvent(
  key: 'Asterisk to italic',
  character: '*',
  handler: (QuillController controller) =>
      handleFormatByWrappingWithSingleCharacter(
    controller: controller,
    character: '*',
    formatStyle: SingleCharacterFormatStyle.italic,
  ),
);

// You can also create similar events for other formatting
CharacterShortcutEvent asteriskToBoldStyleEvent = CharacterShortcutEvent(
  key: 'Double asterisk to bold',
  character: '*',
  handler: (QuillController controller) =>
      handleFormatByWrappingWithSingleCharacter(
    controller: controller,
    character: '**',
    formatStyle: SingleCharacterFormatStyle.bold,
  ),
);
