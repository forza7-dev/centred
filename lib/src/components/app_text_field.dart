import 'package:flutter/material.dart';

/// Pure single-line text input. Exposes a `trailing` slot so callers (e.g.
/// a speech-aware wrapper widget) can compose in a mic button without this
/// widget knowing anything about speech.
///
/// Owns a [TextEditingController] locally (a `StatefulWidget` is required
/// here — a plain `TextField` rebuilt with a fresh controller every frame
/// would reset the cursor to the end on every keystroke) but stays "pure"
/// in the sense that matters: no provider reads, no business logic. External
/// value changes (e.g. voice dictation appending text) are synced in
/// [didUpdateWidget] without disturbing an in-progress edit.
class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.value,
    required this.onChanged,
    this.placeholder,
    this.label,
    this.trailing,
    super.key,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String? placeholder;
  final String? label;
  final Widget? trailing;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.value);

  @override
  void didUpdateWidget(AppTextField oldWidget) {
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
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.placeholder,
        suffixIcon: widget.trailing,
      ),
    );
  }
}
