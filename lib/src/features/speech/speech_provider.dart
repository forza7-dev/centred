import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'services/speech_service.dart';

class SpeechState {
  const SpeechState({this.isSupported = true, this.listeningFieldId});

  final bool isSupported;
  final String? listeningFieldId;
}

final speechServiceProvider = Provider<SpeechService>((ref) => SpeechService());

final speechProvider = StateNotifierProvider<SpeechNotifier, SpeechState>(
  (ref) => SpeechNotifier(ref.watch(speechServiceProvider)),
);

/// Single global listening state — there is one microphone, so unlike the
/// per-entry providers this is not a `.family`. Toggling the same field id
/// again stops listening, mirroring the prototype's `listen(id, onResult)`.
class SpeechNotifier extends StateNotifier<SpeechState> {
  SpeechNotifier(this._service) : super(const SpeechState());

  final SpeechService _service;

  Future<void> listen(String fieldId, {required void Function(String) onResult}) async {
    if (state.listeningFieldId == fieldId) {
      await _service.stop();
      state = const SpeechState();
      return;
    }

    final available = await _service.initialize();
    if (!available) {
      state = const SpeechState(isSupported: false);
      return;
    }

    state = SpeechState(listeningFieldId: fieldId);
    await _service.listen(
      onResult: (text) {
        onResult(text);
        state = const SpeechState();
      },
    );
  }

  /// Appends the recognised text to a list instead of replacing a field's
  /// value — ports the prototype's `listenAndAddToList`.
  Future<void> listenAndAdd(String fieldId, {required void Function(String) onAppend}) =>
      listen('voice-list-$fieldId', onResult: onAppend);
}
