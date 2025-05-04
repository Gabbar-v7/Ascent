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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Markdown(
      data: data,
      onTapLink: _handleLinkTap,
      builders: {'code': CodeBlockBuilder(isDarkMode: isDarkMode)},
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
  final bool isDarkMode;

  CodeBlockBuilder({this.isDarkMode = false});

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final code = element.textContent;
    final language = _extractLanguage(element);

    return CodeBlock(code: code, language: language, isDarkMode: isDarkMode);
  }

  String _extractLanguage(md.Element element) {
    return element.attributes['class']?.replaceAll('language-', '') ?? 'text';
  }
}

class CodeBlock extends StatelessWidget {
  final String code;
  final String language;
  final bool isDarkMode;

  const CodeBlock({
    super.key,
    required this.code,
    required this.language,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300;
    final headerBgColor = isDarkMode ? Color(0xFF1E1E1E) : Colors.grey.shade100;
    final contentBgColor = isDarkMode ? Color(0xFF121212) : Colors.grey.shade50;
    final textColor = isDarkMode ? Colors.grey.shade300 : Colors.grey.shade800;

    return Card(
      color: Colors.red,
      elevation: 0,
      surfaceTintColor: Colors.green,
      shadowColor: Colors.white,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(width: 1, color: borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(headerBgColor, borderColor, textColor),
            _buildCodeContent(contentBgColor, textColor),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color bgColor, Color borderColor, Color textColor) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(bottom: BorderSide(color: borderColor, width: 1)),
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
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            CopyButton(code: code, isDarkMode: isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeContent(Color bgColor, Color textColor) {
    return Container(
      color: bgColor,
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 400),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: SelectableText(
            code,
            style: TextStyle(
              fontFamily: 'RobotoMono',
              fontSize: 14,
              height: 1.5,
              color: isDarkMode ? Colors.grey.shade200 : Colors.grey.shade900,
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
        color = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700;
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
  final bool isDarkMode;

  const CopyButton({super.key, required this.code, this.isDarkMode = false});

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
    final textColor =
        widget.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
    final successColor = widget.isDarkMode ? Colors.greenAccent : Colors.green;

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
        style: TextStyle(
          fontSize: 13,
          color: _copied ? successColor : textColor,
        ),
      ),
      icon: Icon(
        _copied ? Icons.check : Icons.copy,
        size: 12,
        color: _copied ? successColor : textColor,
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
