import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:core/src/config/env/api_config_service.dart';
import 'package:learnwayv2/core/di/locator.dart';

class BannerAdManager {
  BannerAdManager._();

  static final BannerAdManager _instance = BannerAdManager._();
  static BannerAdManager get instance => _instance;

  final Map<String, BannerAd> _ads = {};
  final Map<String, bool> _readyStatus = {};
  final Map<String, bool> _mounted = {};

  final Map<String, List<VoidCallback>> _listeners = {};
  final Map<String, DateTime> _loadedAt = {};
  static const _adRefreshDuration = Duration(minutes: 5);

  void addListener(String screenKey, VoidCallback callback) {
    _listeners.putIfAbsent(screenKey, () => []).add(callback);
  }

  void removeListener(String screenKey, VoidCallback callback) {
    _listeners[screenKey]?.remove(callback);
  }

  bool _isStale(String screenKey) {
    final loadedAt = _loadedAt[screenKey];
    if (loadedAt == null) return true;
    return DateTime.now().difference(loadedAt) > _adRefreshDuration;
  }

  RevenueConfigResponse? get _revenueConfig =>
      locator.isRegistered<RevenueConfigResponse>()
      ? locator.get<RevenueConfigResponse>()
      : null;

  Future<void> loadAd(String screenKey, int width) async {
    if (_readyStatus[screenKey] == true && _isStale(screenKey)) {
      if (_mounted[screenKey] != true) {
        _ads[screenKey]?.dispose();
        _ads.remove(screenKey);
        _readyStatus.remove(screenKey);
        _loadedAt.remove(screenKey);
      } else {
        return;
      }
    }
    if (_readyStatus[screenKey] == true && _ads.containsKey(screenKey)) return;

    if (_ads.containsKey(screenKey)) {
      _ads[screenKey]?.dispose();
      _ads.remove(screenKey);
      _readyStatus.remove(screenKey);
    }

    final adSize =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);
    if (adSize == null) return;

    final ad = BannerAd(
      adUnitId: Platform.isIOS
          ? _revenueConfig?.adUnitIds?.ios.banner ?? ''
          : _revenueConfig?.adUnitIds?.android.banner ?? '',
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          log("BannerAdManager: Ad loaded for $screenKey");
          _readyStatus[screenKey] = true;
          _loadedAt[screenKey] = DateTime.now();
          for (final cb in _listeners[screenKey] ?? []) {
            cb();
          }
        },
        onAdFailedToLoad: (ad, error) {
          log("BannerAdManager: Ad failed for $screenKey: $error");
          ad.dispose();
          _ads.remove(screenKey);
          _readyStatus[screenKey] = false;
        },
      ),
    )..load();

    _ads[screenKey] = ad;
  }

  BannerAd? getAd(String screenKey) {
    if (_readyStatus[screenKey] != true) return null;
    return _ads[screenKey];
  }

  void markMounted(String screenKey) {
    _mounted[screenKey] = true;
  }

  void markUnmounted(String screenKey) {
    _mounted[screenKey] = false;
  }

  void disposeAd(String screenKey) {
    _ads[screenKey]?.dispose();
    _ads.remove(screenKey);
    _readyStatus.remove(screenKey);
    _listeners.remove(screenKey);
    _loadedAt.remove(screenKey);
  }

  void disposeAll() {
    for (final ad in _ads.values) {
      ad.dispose();
    }
    _ads.clear();
    _readyStatus.clear();
    _listeners.clear();
    _loadedAt.clear();
  }
}
