import 'package:flutter/material.dart';

/// Pure multi-line text input — see [AppTextField] for why this owns a
/// local [TextEditingController] via `StatefulWidget` while staying "pure"
/// (no provider reads, no business logic).
class AppTextareaField extends StatefulWidget {
  const AppTextareaField({
    required this.value,
    required this.onChanged,
    this.placeholder,
    this.label,
    this.trailing,
    this.minLines = 3,
    super.key,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String? placeholder;
  final String? label;
  final Widget? trailing;
  final int minLines;

  @override
  State<AppTextareaField> createState() => _AppTextareaFieldState();
}

class _AppTextareaFieldState extends State<AppTextareaField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.value);

  @override
  void didUpdateWidget(AppTextareaField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      minLines: widget.minLines,
      maxLines: null,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.placeholder,
        suffixIcon: widget.trailing,
        alignLabelWithHint: true,
      ),
    );
  }
}
