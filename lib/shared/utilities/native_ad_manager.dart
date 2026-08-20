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
  DateTime? _loadedAt;
  bool _isReady = false;
  bool _isLoading = false;
  LoadAdError? _lastError;
  VoidCallback? _onAdLoadedCallback;

  static const Duration _adTtl = Duration(minutes: 5);

  LoadAdError? get lastError => _lastError;

  String get _adUnitId {
    if (!locator.isRegistered<RevenueConfigResponse>()) return '';
    final ids = locator.get<RevenueConfigResponse>().adUnitIds;
    if (ids == null) return '';
    return Platform.isIOS ? ids.ios.native : ids.android.native;
  }

  bool get isReady {
    if (!_isReady || _preloadedAd == null) return false;
    if (_loadedAt != null && DateTime.now().difference(_loadedAt!) > _adTtl) {
      log(
        'NativeAdManager: preloaded ad expired (> 5 mins), disposing and reloading.',
      );
      _preloadedAd?.dispose();
      _preloadedAd = null;
      _isReady = false;
      _loadedAt = null;
      preload();
      return false;
    }
    return true;
  }

  NativeTemplateStyle get defaultTemplateStyle => NativeTemplateStyle(
    templateType: TemplateType.medium,
    mainBackgroundColor: Colors.white,
    callToActionTextStyle: NativeTemplateTextStyle(
      size: 16.0,
      textColor: Colors.white,
      backgroundColor: Colors.blue,
    ),
    primaryTextStyle: NativeTemplateTextStyle(textColor: Colors.black),
  );

  void preload({VoidCallback? onAdLoaded}) {
    if (isReady) {
      onAdLoaded?.call();
      return;
    }
    if (onAdLoaded != null) {
      _onAdLoadedCallback = onAdLoaded;
    }
    if (_isLoading) return;

    final adUnitId = _adUnitId;
    if (adUnitId.isEmpty) return;
    _isLoading = true;

    _preloadedAd = NativeAd(
      adUnitId: adUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          _isReady = true;
          _isLoading = false;
          _loadedAt = DateTime.now();
          _lastError = null;
          log('NativeAdManager: ad preloaded successfully.');
          _onAdLoadedCallback?.call();
          _onAdLoadedCallback = null;
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _preloadedAd = null;
          _isReady = false;
          _isLoading = false;
          _loadedAt = null;
          _lastError = error;
          log('NativeAdManager: preload failed — $error');
          _onAdLoadedCallback = null;
        },
      ),
      request: const AdRequest(),
      nativeTemplateStyle: defaultTemplateStyle,
    )..load();
  }

  NativeAd? consume() {
    if (!isReady) return null;
    final ad = _preloadedAd;
    _preloadedAd = null;
    _isReady = false;
    _loadedAt = null;
    log('NativeAdManager: ad consumed. Preloading next ad in background.');
    preload();
    return ad;
  }

  NativeAd createAndLoadAd({
    required void Function(NativeAd ad) onAdLoaded,
    required void Function(NativeAd ad, LoadAdError error) onAdFailedToLoad,
  }) {
    final adUnitId = _adUnitId;
    return NativeAd(
      adUnitId: adUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          log('NativeAdManager: direct ad loaded.');
          onAdLoaded(ad as NativeAd);
        },
        onAdFailedToLoad: (ad, error) {
          log('NativeAdManager: direct ad failed to load — $error');
          ad.dispose();
          onAdFailedToLoad(ad as NativeAd, error);
        },
      ),
      request: const AdRequest(),
      nativeTemplateStyle: defaultTemplateStyle,
    )..load();
  }

  void dispose() {
    _preloadedAd?.dispose();
    _preloadedAd = null;
    _isReady = false;
    _isLoading = false;
    _loadedAt = null;
    _onAdLoadedCallback = null;
  }
}
