import 'dart:developer';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/services/ad_service.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/shared/interfaces/ad_service_interface.dart';

class ATTService {
  ATTService._();
  static final ATTService instance = ATTService._();

  bool _adsInitialized = false;

  Future<void> requestTrackingIfNeeded() async {
    if (!Platform.isIOS) {
      await _initializeAds();
      return;
    }

    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    log('ATTService: current status = $status', name: 'ATTService');

    if (status == TrackingStatus.notDetermined) {
      // iOS needs a brief settle before it will present the system dialog.
      await Future.delayed(const Duration(milliseconds: 400));
      final result =
          await AppTrackingTransparency.requestTrackingAuthorization();
      log('ATTService: user responded — $result', name: 'ATTService');
    }

    await _initializeAds();
  }

  Future<void> _initializeAds() async {
    if (_adsInitialized) return;
    _adsInitialized = true;
    try {
      final userId = LocalStorageService.getUserSync()?.id;
      AdService.instance.setAdBackend(locator<IAdService>());
      await AdService.instance.init(userId: userId);
      log('ATTService: ads initialized', name: 'ATTService');
    } catch (e, st) {
      log(
        'ATTService: ads init failed — $e',
        name: 'ATTService',
        stackTrace: st,
      );
    }
  }
}
