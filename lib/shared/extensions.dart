import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

extension SheetExtension on BuildContext {
  void showModalSheet({required String content}) {
    showModalBottomSheet(
      context: this,
      builder: (context) {
        return Row(children: []);
      },
    );
  }
}

extension DeviceInfoExtension on DeviceInfoPlugin {
  Future<String> getPlatformName() async {
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }

  Future<String> getDeviceModel() async {
    if (Platform.isAndroid) {
      final info = await androidInfo;
      return info.model;
    } else if (Platform.isIOS) {
      final info = await iosInfo;
      return info.utsname.machine;
    }
    return 'Unknown';
  }

  Future<Map<String, String>> getDeviceDetails() async {
    if (Platform.isAndroid) {
      final info = await androidInfo;
      return {
        'platform': 'Android',
        'model': info.model,
        'manufacturer': info.manufacturer,
        'device': info.device,
        'brand': info.brand,
        'version': info.version.release,
        'sdkInt': info.version.sdkInt.toString(),
      };
    } else if (Platform.isIOS) {
      final info = await iosInfo;
      return {
        'platform': 'iOS',
        'model': info.model,
        'name': info.name,
        'systemName': info.systemName,
        'systemVersion': info.systemVersion,
        'machine': info.utsname.machine,
      };
    }
    return {'platform': 'Unknown', 'model': 'Unknown'};
  }
}

extension PackageInfoExtension on PackageInfo {}
