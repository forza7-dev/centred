import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Pure UI shell for a microphone toggle: `isListening` in, `onTap` out.
/// Zero knowledge of `speech_to_text` or any provider. The only state this
/// `StatefulWidget` owns is the local pulse animation while listening.
class SpeechMicButton extends StatefulWidget {
  const SpeechMicButton({
    required this.isListening,
    required this.onTap,
    this.enabled = true,
    super.key,
  });

  final bool isListening;
  final VoidCallback onTap;
  final bool enabled;

  @override
  State<SpeechMicButton> createState() => _SpeechMicButtonState();
}

class _SpeechMicButtonState extends State<SpeechMicButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    if (widget.isListening) _pulseController.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(SpeechMicButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening == oldWidget.isListening) return;
    if (widget.isListening) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return const SizedBox.shrink();

    return Semantics(
      button: true,
      label: widget.isListening ? 'Stop voice dictation' : 'Start voice dictation',
      child: SizedBox(
        width: 48,
        height: 48,
        child: IconButton(
          onPressed: widget.onTap,
          icon: widget.isListening
              ? AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) => Opacity(
                    opacity: 0.5 + (_pulseController.value * 0.5),
                    child: child,
                  ),
                  child: const Icon(Icons.mic, color: AppColors.coral),
                )
              : const Icon(Icons.mic_none, color: AppColors.textMuted),
        ),
      ),
    );
  }
}
