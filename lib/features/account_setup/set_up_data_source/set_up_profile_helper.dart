import 'dart:io';

import 'package:flutter/services.dart';
import 'package:learnwayv2/features/auth/auth_exception.dart';
import 'package:learnwayv2/shared/utilities/image_helpers.dart';

class ProfileImageHelper {
  static Future<
    ({
      Map<String, Uint8List> bytes,
      Map<String, String> names,
      Map<String, String>? mime,
    })
  >
  prepareImage(String path) async {
    if (path.startsWith('assets/')) {
      final ByteData assetData = await rootBundle.load(path);
      final Uint8List imageBytes = assetData.buffer.asUint8List();

      final extension = path.split('.').last.toLowerCase();
      final filename = 'avatar.$extension';
      final contentType = ImageHelper.getContentType(path);

      return (
        bytes: {'profileImage': imageBytes},
        names: {'profileImage': filename},
        mime: contentType != null ? {'profileImage': contentType} : null,
      );
    } else {
      final file = File(path);
      if (!await file.exists()) {
        throw AuthFailure('Profile image file does not exist: $path');
      }
      throw UnimplementedError('Use file upload method for non-asset paths');
    }
  }
}
