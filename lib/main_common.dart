import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/services/ad_service.dart';
import 'package:learnwayv2/services/connectivity_service.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/shared/interfaces/ad_service_interface.dart';
import 'package:sentry/sentry.dart';

Future<void> mainCommon() async {
  try {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } catch (e, st) {
    developer.log(
      'setPreferredOrientations failed: $e',
      name: 'LearnWay',
      stackTrace: st,
    );
  }

  try {
    await LocalStorageService.init();
  } catch (e, st) {
    developer.log(
      'LocalStorageService.init failed: $e',
      name: 'LearnWay',
      stackTrace: st,
    );
  }

  try {
    await ConnectivityService().initialize();
  } catch (e, st) {
    developer.log(
      'ConnectivityService.initialize failed: $e',
      name: 'LearnWay',
      stackTrace: st,
    );
  }

  await setupLocator();

  try {
    await fetchAndRegisterApiConfig();
  } catch (e, st) {
    developer.log(
      'fetchAndRegisterApiConfig failed: $e',
      name: 'LearnWay',
      stackTrace: st,
    );
    await Sentry.captureException(e, stackTrace: st);
  }

  // On iOS, ad initialization is deferred until after the ATT consent flow
  // completes in the home screen. Initializing MobileAds before ATT resolves
  // means the SDK would receive an empty advertising identifier and all
  // subsequent ad requests would be non-personalized by default.
  if (!Platform.isIOS) {
    await _initializeAds();
  }
}

Future<void> _initializeAds() async {
  try {
    final userId = LocalStorageService.getUserSync()?.id;
    AdService.instance.setAdBackend(locator<IAdService>());
    await AdService.instance.init(userId: userId);
  } catch (e, st) {
    developer.log(
      'Ad initialization failed: $e',
      name: 'LearnWay',
      stackTrace: st,
    );
  }
}

Future<void> fetchAndRegisterApiConfig() async {
  final client = locator<BaseApiClients>();
  await ApiConfigService(client).fetchApiConfig();
  await RevenueConfigService(client).fetchRevenueConfig();
}
