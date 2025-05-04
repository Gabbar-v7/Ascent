import 'dart:async';

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
      onTapLink: _handleLinkTap,
      builders: {'code': CodeBlockBuilder()},
      styleSheet: MarkdownStyleSheet(
        code: const TextStyle(backgroundColor: Colors.transparent),
      ),
    );
  }

  Future<void> _handleLinkTap(String text, String? href, String? title) async {
    if (href != null && await canLaunchUrl(Uri.parse(href))) {
      await launchUrl(Uri.parse(href));
    }
  }
}

class CodeBlockBuilder extends MarkdownElementBuilder {
  CodeBlockBuilder();

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final code = element.textContent;
    final language = _extractLanguage(element);

    return CodeBlock(code: code, language: language);
  }

  String _extractLanguage(md.Element element) {
    return element.attributes['class']?.replaceAll('language-', '') ?? 'text';
  }
}

class CodeBlock extends StatelessWidget {
  final String code;
  final String language;

  const CodeBlock({super.key, required this.code, required this.language});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [_buildHeader(), _buildCodeContent()],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _getLanguageIcon(),
                const SizedBox(width: 8),
                Text(
                  _getLanguageDisplayName(),
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            CopyButton(code: code),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeContent() {
    return Container(
      color: Colors.grey.shade50,
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 400),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
          child: Text(
            code,
            style: const TextStyle(
              fontFamily: 'RobotoMono',
              fontSize: 14,
              height: 1.5,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }

  Widget _getLanguageIcon() {
    final IconData iconData;
    final Color color;

    switch (language.toLowerCase()) {
      case 'dart':
      case 'flutter':
        iconData = Icons.flutter_dash;
        color = Colors.blue;
        break;
      case 'javascript':
      case 'js':
        iconData = Icons.javascript;
        color = Colors.amber;
        break;
      case 'python':
        iconData = Icons.code;
        color = Colors.green;
        break;
      case 'html':
        iconData = Icons.html;
        color = Colors.orange;
        break;
      case 'css':
        iconData = Icons.css;
        color = Colors.lightBlue;
        break;
      default:
        iconData = Icons.code;
        color = Colors.grey.shade700;
    }

    return Icon(iconData, size: 16, color: color);
  }

  String _getLanguageDisplayName() {
    switch (language.toLowerCase()) {
      case 'js':
        return 'JavaScript';
      case 'py':
        return 'Python';
      case '':
      case 'text':
        return 'Plain Text';
      default:
        return language.isNotEmpty
            ? language[0].toUpperCase() + language.substring(1)
            : 'Plain Text';
    }
  }
}

class CopyButton extends StatefulWidget {
  final String code;

  const CopyButton({super.key, required this.code});

  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> {
  bool _copied = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      onPressed: _copyToClipboard,
      label: Text(
        _copied ? 'Copied!' : 'Copy',
        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
      ),
      icon: Icon(
        _copied ? Icons.check : Icons.copy,
        size: 12,
        color: _copied ? Colors.green : Colors.grey.shade600,
      ),
    );
  }

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    setState(() {
      _copied = true;
    });

    // Reset after 2 seconds
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _copied = false;
        });
      }
    });
  }
}
