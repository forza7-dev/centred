import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

final pdfExportServiceProvider = Provider<PdfExportService>((ref) => PdfExportService());

/// Tools whose document layout is wide (diagrams, grids) export landscape
/// — ported verbatim from the prototype's `jsPDF` orientation logic in
/// `design-reference/app/pages/view/[id].vue`.
const landscapeToolIds = {
  'my-people',
  'how-i-communicate',
  'my-perfect-week',
  'my-direction',
  'my-story',
};

/// `RepaintBoundary` -> image -> `pdf` document -> OS share sheet, the
/// direct Flutter analogue of the prototype's html2pdf.js screenshot-style
/// export. Never writes the PDF to app-local disk — bytes stay in memory
/// end to end, matching the ephemeral data requirement.
class PdfExportService {
  Future<void> exportAndShare({
    required GlobalKey repaintBoundaryKey,
    required String toolId,
    required String filename,
  }) async {
    final renderObject = repaintBoundaryKey.currentContext?.findRenderObject();
    if (renderObject is! RenderRepaintBoundary) return;

    final image = await renderObject.toImage(pixelRatio: 2.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return;
    final pngBytes = byteData.buffer.asUint8List();

    final pageFormat =
        landscapeToolIds.contains(toolId) ? PdfPageFormat.a4.landscape : PdfPageFormat.a4;

    final document = pw.Document();
    final memoryImage = pw.MemoryImage(pngBytes);
    document.addPage(
      pw.Page(
        pageFormat: pageFormat,
        build: (context) => pw.Column(
          children: [
            pw.Expanded(child: pw.Image(memoryImage, fit: pw.BoxFit.contain)),
            pw.Footer(
              title: pw.Text(
                'Created with Centred by Forza7',
                style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
              ),
            ),
          ],
        ),
      ),
    );

    final pdfBytes = await document.save();
    await Printing.sharePdf(bytes: pdfBytes, filename: filename);
  }
}
