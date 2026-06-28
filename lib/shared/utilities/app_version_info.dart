import 'dart:developer';

import 'package:package_info_plus/package_info_plus.dart';

class AppVersionInfo {
  Future<String> getPackageVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return info.version;
    } catch (e) {
      log('failed to get package version $e');
    }
    return '1.0.0';
  }
}
