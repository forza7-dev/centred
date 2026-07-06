import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/personalisation_settings.dart';

/// Document personalisation (font/background/accent), scoped strictly to
/// the document view for a single entry — `autoDispose.family` guarantees
/// it is thrown away the moment the user navigates off that document, and
/// never leaks into the global `ThemeData`.
final personalisationProvider = StateNotifierProvider.autoDispose
    .family<PersonalisationNotifier, PersonalisationSettings, String>(
  (ref, entryId) => PersonalisationNotifier(),
);

class PersonalisationNotifier extends StateNotifier<PersonalisationSettings> {
  PersonalisationNotifier() : super(const PersonalisationSettings());

  void setFont(DocumentFont font) => state = state.copyWith(font: font);
  void setBackground(DocumentBackground background) => state = state.copyWith(background: background);
  void setAccent(DocumentAccent accent) => state = state.copyWith(accent: accent);
}
