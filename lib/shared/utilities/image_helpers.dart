import 'dart:io';
import 'dart:developer';

class ImageHelper {
  static const int maxFileSizeInBytes = 5 * 1024 * 1024;
  static const List<String> allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];

  static Future<bool> validateImageFile(File file) async {
    try {
      if (!await file.exists()) {
        log('Image file does not exist: ${file.path}');
        return false;
      }
      final extension = file.path.split('.').last.toLowerCase();
      if (!allowedExtensions.contains(extension)) {
        log('Invalid file extension: $extension');
        return false;
      }

      final fileSize = await file.length();
      if (fileSize > maxFileSizeInBytes) {
        log('File size too large: ${fileSize}bytes');
        return false;
      }

      return true;
    } catch (e) {
      log('Error validating image file: $e');
      return false;
    }
  }

  static Future<double> getFileSizeInMB(File file) async {
    try {
      final bytes = await file.length();
      return bytes / (1024 * 1024);
    } catch (e) {
      log('Error getting file size: $e');
      return 0.0;
    }
  }

  static String getFileExtension(String filePath) {
    return filePath.split('.').last.toLowerCase();
  }

  static Future<File?> createTempCopy(File originalFile) async {
    try {
      final directory = originalFile.parent;
      final extension = getFileExtension(originalFile.path);
      final tempPath =
          '${directory.path}/temp_${DateTime.now().millisecondsSinceEpoch}.$extension';

      return await originalFile.copy(tempPath);
    } catch (e) {
      log('Error creating temp copy: $e');
      return null;
    }
  }

  static Future<void> cleanupTempFile(File? tempFile) async {
    try {
      if (tempFile != null && await tempFile.exists()) {
        await tempFile.delete();
        log('Cleaned up temp file: ${tempFile.path}');
      }
    } catch (e) {
      log('Error cleaning up temp file: $e');
    }
  }

  static bool isAssetImage(String imagePath) {
    return imagePath.startsWith('assets/');
  }

  static String? getContentType(String filePath) {
    final extension = getFileExtension(filePath);
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      default:
        return null;
    }
  }
}
