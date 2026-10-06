import 'package:flutter/material.dart';

class MarkdownScriptEditor extends StatefulWidget {
  final TextEditingController controller;
  final bool enabled;
  final String? errorText;

  const MarkdownScriptEditor({
    super.key,
    required this.controller,
    this.enabled = true,
    this.errorText,
  });

  @override
  State<MarkdownScriptEditor> createState() => _MarkdownScriptEditorState();
}

class _MarkdownScriptEditorState extends State<MarkdownScriptEditor> {
  bool _preview = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Script',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            ToggleButtons(
              constraints: const BoxConstraints(minHeight: 30, minWidth: 72),
              borderRadius: BorderRadius.circular(8),
              isSelected: [!_preview, _preview],
              onPressed: (index) => setState(() => _preview = index == 1),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('Edit'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('Preview'),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.errorText != null
                  ? Theme.of(context).colorScheme.error
                  : Colors.grey.shade400,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          constraints: const BoxConstraints(minHeight: 160),
          padding: const EdgeInsets.all(10),
          child: _preview
              ? _MarkdownPreview(text: widget.controller.text)
              : TextFormField(
                  controller: widget.controller,
                  enabled: widget.enabled,
                  minLines: 6,
                  maxLines: 14,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintText:
                        '# Hook\nWrite the script here... supports **bold**, '
                        '*italic*, `code`, and lists.',
                  ),
                ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              widget.errorText!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}

class _MarkdownPreview extends StatelessWidget {
  final String text;

  const _MarkdownPreview({required this.text});

  @override
  Widget build(BuildContext context) {
    if (text.trim().isEmpty) {
      return const Text(
        'Nothing to preview yet.',
        style: TextStyle(color: Colors.grey),
      );
    }

    final lines = text.split('\n');

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines.map(_renderLine).toList(),
      ),
    );
  }

  Widget _renderLine(String rawLine) {
    final line = rawLine.trimRight();

    if (line.trim().isEmpty) {
      return const SizedBox(height: 8);
    }

    if (line.startsWith('### ')) {
      return _paddedText(line.substring(4), fontSize: 15, bold: true);
    }
    if (line.startsWith('## ')) {
      return _paddedText(line.substring(3), fontSize: 17, bold: true);
    }
    if (line.startsWith('# ')) {
      return _paddedText(line.substring(2), fontSize: 20, bold: true);
    }

    if (line.trimLeft().startsWith('- ') || line.trimLeft().startsWith('* ')) {
      final content = line.trimLeft().substring(2);
      return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('•  '),
            Expanded(child: _inlineSpans(content)),
          ],
        ),
      );
    }

    final numberedMatch = RegExp(
      r'^(\d+)\.\s+(.*)$',
    ).firstMatch(line.trimLeft());
    if (numberedMatch != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${numberedMatch.group(1)}.  '),
            Expanded(child: _inlineSpans(numberedMatch.group(2) ?? '')),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: _inlineSpans(line),
    );
  }

  Widget _paddedText(
    String text, {
    required double fontSize,
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: _inlineSpans(
        text,
        baseStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _inlineSpans(String text, {TextStyle? baseStyle}) {
    final spans = <TextSpan>[];
    final pattern = RegExp(r'(\*\*.+?\*\*|\*.+?\*|`.+?`)');

    var lastEnd = 0;
    for (final match in pattern.allMatches(text)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: text.substring(lastEnd, match.start)));
      }

      final token = match.group(0)!;
      if (token.startsWith('**')) {
        spans.add(
          TextSpan(
            text: token.substring(2, token.length - 2),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      } else if (token.startsWith('`')) {
        spans.add(
          TextSpan(
            text: token.substring(1, token.length - 1),
            style: const TextStyle(
              fontFamily: 'monospace',
              backgroundColor: Color(0xFFEEEEEE),
            ),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: token.substring(1, token.length - 1),
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        );
      }

      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd)));
    }

    return RichText(
      text: TextSpan(
        style: (baseStyle ?? const TextStyle()).copyWith(color: Colors.black87),
        children: spans,
      ),
    );
  }
}
