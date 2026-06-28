import 'dart:developer';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:core/src/config/env/api_config_service.dart';
import 'package:learnwayv2/core/di/locator.dart';

class NativeAdManager {
  NativeAdManager._();

  static final NativeAdManager _instance = NativeAdManager._();
  static NativeAdManager get instance => _instance;

  NativeAd? _preloadedAd;
  bool _isReady = false;
  bool _isLoading = false;

  String get _adUnitId {
    if (!locator.isRegistered<RevenueConfigResponse>()) return '';
    final ids = locator.get<RevenueConfigResponse>().adUnitIds;
    if (ids == null) return '';
    return Platform.isIOS ? ids.ios.native : ids.android.native;
  }

  void preload() {
    if (_isReady || _isLoading) return;
    final adUnitId = _adUnitId;
    if (adUnitId.isEmpty) return;
    _isLoading = true;

    _preloadedAd = NativeAd(
      adUnitId: adUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          _isReady = true;
          _isLoading = false;
          log('NativeAdManager: ad preloaded.');
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _preloadedAd = null;
          _isReady = false;
          _isLoading = false;
          log('NativeAdManager: preload failed — $error');
        },
      ),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: Colors.white,
        callToActionTextStyle: NativeTemplateTextStyle(
          size: 16.0,
          textColor: Colors.white,
          backgroundColor: Colors.blue,
        ),
        primaryTextStyle: NativeTemplateTextStyle(textColor: Colors.black),
      ),
    )..load();
  }

  NativeAd? consume() {
    if (!_isReady) return null;
    final ad = _preloadedAd;
    _preloadedAd = null;
    _isReady = false;
    preload();
    return ad;
  }

  void dispose() {
    _preloadedAd?.dispose();
    _preloadedAd = null;
    _isReady = false;
    _isLoading = false;
  }
}
