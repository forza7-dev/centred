import '../../../models/field_value.dart';

class FillWizardState {
  const FillWizardState({
    required this.toolId,
    required this.currentStepIndex,
    required this.formData,
  });

  final String toolId;
  final int currentStepIndex;
  final Map<String, FieldValue> formData;

  FillWizardState copyWith({
    int? currentStepIndex,
    Map<String, FieldValue>? formData,
  }) =>
      FillWizardState(
        toolId: toolId,
        currentStepIndex: currentStepIndex ?? this.currentStepIndex,
        formData: formData ?? this.formData,
      );
}
