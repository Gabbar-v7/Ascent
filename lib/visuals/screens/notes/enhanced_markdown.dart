import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:markdown/markdown.dart' as md;

class EnhancedMarkdown extends StatelessWidget {
  final String data;

  const EnhancedMarkdown({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Markdown(
      data: data,
      onTapLink: (text, href, title) async {
        if (href != null) {
          if (await canLaunchUrl(Uri.parse(href))) {
            await launchUrl(Uri.parse(href));
          }
        }
      },
      builders: {'code': CodeBlockBuilder()},
      styleSheet: MarkdownStyleSheet(
        code: TextStyle(backgroundColor: Colors.transparent),
      ),
    );
  }
}

class CodeBlockBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final code = element.textContent;
    final language = element.attributes['class']?.replaceAll('language-', '');

    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Left-align children
          children: [
            // Header row with language and copy button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (language != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      language,
                      style: TextStyle(color: Colors.blue[800]),
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: code));
                    // Note: For SnackBar, you'll need to handle this differently
                  },
                ),
              ],
            ),
            // Code content
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SelectableText(
                code,
                style: const TextStyle(fontFamily: 'RobotoMono'),
                textAlign: TextAlign.left, // Explicit left alignment
              ),
            ),
          ],
        ),
      ),
    );
  }
}
