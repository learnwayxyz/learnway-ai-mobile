import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:learnwayv2/services/cloud/cloud_adapter.dart';
import 'package:learnwayv2/services/interfaces.dart';
import 'package:learnwayv2/services/secret_sharing_service/secret_sharing_service.dart';

class SecretSharingServiceFactory {
  static SecretSharingService create({
    FlutterSecureStorage? secureStorage,
    ICloudServices? cloudService,
  }) {
    CloudServiceAdapter? cloudAdapter;
    if (cloudService != null) {
      cloudAdapter = CloudServiceAdapter(cloudService);
    }

    if (Platform.isIOS) {
      return IOSSecretSharingService(
        secureStorage: secureStorage,
        cloudService: cloudAdapter,
      );
    } else if (Platform.isAndroid) {
      return AndroidSecretSharingService(
        secureStorage: secureStorage,
        cloudService: cloudAdapter,
      );
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }
}
