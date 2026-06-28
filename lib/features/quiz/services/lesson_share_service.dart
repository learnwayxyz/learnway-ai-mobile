import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class LessonShareService {
  static Future<void> shareWidget({
    required GlobalKey repaintBoundaryKey,
    required String text,
    required String subject,
    required BuildContext context,
  }) async {
    final box = context.findRenderObject() as RenderBox?;
    final sharePositionOrigin = box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : null;

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final RenderRepaintBoundary boundary =
          repaintBoundaryKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;

      final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        throw Exception('Failed to capture image');
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      // Get temporary directory
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath =
          '${tempDir.path}/lesson_completed_${DateTime.now().millisecondsSinceEpoch}.png';

      final File file = File(filePath);
      await file.writeAsBytes(pngBytes);

      final XFile xFile = XFile(filePath);
      await SharePlus.instance.share(
        ShareParams(
          files: [xFile],
          text: text,
          subject: subject,
          sharePositionOrigin: sharePositionOrigin,
        ),
      );

      await Future.delayed(const Duration(seconds: 2));
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Error sharing widget: $e');
      rethrow;
    }
  }

  static Future<Uint8List?> captureWidgetAsImage({
    required GlobalKey repaintBoundaryKey,
    double pixelRatio = 3.0,
  }) async {
    try {
      final RenderRepaintBoundary boundary =
          repaintBoundaryKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;

      final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error capturing widget: $e');
      return null;
    }
  }
}
