import 'dart:convert';
import 'dart:developer' as dev;

import 'package:learnwayv2/services/interfaces.dart';

class CloudServiceAdapter {
  final ICloudServices _cloudService;

  CloudServiceAdapter(this._cloudService);

  Future<void> upload(String data) async {
    final result = await _cloudService.upload(data);
    if (result != true) {
      throw Exception('Failed to upload to cloud storage');
    }
  }

  Future<String?> download() async {
    try {
      final data = await _cloudService.download();
      if (data.isEmpty) return null;
      return jsonEncode(data);
    } catch (e) {
      dev.log('Cloud download error: $e');
      return null;
    }
  }

  Future<bool> hasBackup() async {
    final exists = await _cloudService.backUpExists();
    return exists ?? false;
  }
}
