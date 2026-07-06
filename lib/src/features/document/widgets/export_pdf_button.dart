import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../components/primary_button.dart';
import '../../../providers/saved_entries_provider.dart';
import '../pdf_export_service.dart';

/// Export button: renders the document's `RepaintBoundary` to a PDF, shares
/// it via the OS share sheet, then deletes the entry and navigates to the
/// GDPR confirmation screen — ports the prototype's export-then-delete flow.
class ExportPdfButton extends ConsumerStatefulWidget {
  const ExportPdfButton({
    required this.entryId,
    required this.toolId,
    required this.filename,
    required this.repaintBoundaryKey,
    super.key,
  });

  final String entryId;
  final String toolId;
  final String filename;
  final GlobalKey repaintBoundaryKey;

  @override
  ConsumerState<ExportPdfButton> createState() => _ExportPdfButtonState();
}

class _ExportPdfButtonState extends ConsumerState<ExportPdfButton> {
  bool _isExporting = false;

  Future<void> _export() async {
    setState(() => _isExporting = true);
    await ref.read(pdfExportServiceProvider).exportAndShare(
          repaintBoundaryKey: widget.repaintBoundaryKey,
          toolId: widget.toolId,
          filename: widget.filename,
        );
    if (!mounted) return;
    ref.read(savedEntriesProvider.notifier).deleteEntry(widget.entryId);
    context.goNamed('gdprConfirmation');
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      label: 'Export PDF',
      leadingIcon: Icons.picture_as_pdf_outlined,
      isLoading: _isExporting,
      onPressed: _export,
    );
  }
}
