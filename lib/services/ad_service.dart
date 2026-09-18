import 'dart:developer';
import 'dart:ui' show VoidCallback;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:core/src/config/env/api_config_service.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/services/ads_service.dart';
import 'package:learnwayv2/services/revenue_cat_service.dart';
import 'package:learnwayv2/shared/interfaces/ad_service_interface.dart';
import 'package:learnwayv2/shared/utilities/banner_ad_manager.dart';
import 'package:learnwayv2/shared/utilities/native_ad_manager.dart';
import 'package:purchases_flutter/purchases_flutter.dart' hide PurchaseResult;

class AdService {
  AdService._();
  IAdService? _ads;
  static final AdService _instance = AdService._();
  static AdService get instance => _instance;

  final RevenueCatService _revenueCat = RevenueCatService.instance;

  AdmobService? get _admob =>
      _ads is AdmobService ? _ads as AdmobService : null;

  void setAdBackend(IAdService backend) => _ads = backend;

  bool get _adsEnabledByConfig {
    if (locator.isRegistered<RevenueConfigResponse>()) {
      return locator.get<RevenueConfigResponse>().enableAds;
    }
    return true;
  }

  bool get _isReady => _ads != null;

  bool _mobileAdsInitialized = false;

  Future<void> init({String? userId}) async {
    if (!_mobileAdsInitialized) {
      _mobileAdsInitialized = true;
      await MobileAds.instance.initialize();
    }

    await _revenueCat.init(userId: userId);

    if (!_revenueCat.isPremiumUser && _adsEnabledByConfig) {
      await _ads?.initialize();
    }
  }

  ValueNotifier<bool> get premiumStatusNotifier =>
      _revenueCat.premiumStatusNotifier;

  bool get shouldShowAds => _adsEnabledByConfig && !_revenueCat.isPremiumUser;

  Future<bool> isPremiumUser() => _revenueCat.checkPremiumStatus();

  Future<void> refreshPremiumStatus() => _revenueCat.refreshEntitlementStatus();

  Future<Offering?> getCurrentOffering() => _revenueCat.getCurrentOffering();

  Future<Map<String, Offering>> getAllOfferings() =>
      _revenueCat.getAllOfferings();

  Future<PurchaseResult> purchase(Package package) async {
    final result = await _revenueCat.purchase(package);
    if (_revenueCat.isPremiumUser) {
      _ads?.disposeAds();
      BannerAdManager.instance.disposeAll();
      NativeAdManager.instance.dispose();
    }
    return result;
  }

  Future<PurchaseResult> changePlan(
    StoreProduct newProduct, {
    String? oldProductId,
  }) async {
    final result = await _revenueCat.changePlan(
      newProduct,
      oldProductId: oldProductId,
    );
    if (_revenueCat.isPremiumUser) {
      _ads?.disposeAds();
      BannerAdManager.instance.disposeAll();
      NativeAdManager.instance.dispose();
    }
    return result;
  }

  Future<PurchaseResult> restorePurchases() async {
    final result = await _revenueCat.restorePurchases();
    if (_revenueCat.isPremiumUser) {
      _ads?.disposeAds();
      BannerAdManager.instance.disposeAll();
      NativeAdManager.instance.dispose();
    }
    return result;
  }

  void loadRewardedAd() {
    if (!_isReady || !shouldShowAds) return;
    _ads!.loadRewarded();
  }

  Future<void> showRewardedAd({
    required Function(int amount) onUserEarnedReward,
    VoidCallback? onAdNotAvailable,
    VoidCallback? onAdClosed,
  }) async {
    if (!_isReady || !shouldShowAds) {
      log('AdService: not ready or ads disabled, skipping rewarded ad.');
      onAdNotAvailable?.call();
      return;
    }

    _ads!.showRewarded(
      onReward: (_, amount) => onUserEarnedReward(amount),
      onFailedToShow: onAdNotAvailable,
      onDismissed: onAdClosed,
    );
  }

  void loadInterstitialAd() {
    if (!_isReady || !shouldShowAds) return;
    _ads!.loadInterstitial();
  }

  Future<void> showInterstitialAd(VoidCallback? onAdDismissed) async {
    if (!_isReady || !shouldShowAds || await isPremiumUser()) {
      log('AdService: not ready or ads disabled, skipping interstitial ad.');
      return;
    }
    _ads!.showInterstitial(onDismissed: onAdDismissed);
  }

  void loadNativeAd({VoidCallback? onAdLoaded}) {
    if (!_isReady || !shouldShowAds) return;
    _ads!.loadNativeAd(onAdLoaded: onAdLoaded);
  }

  bool get isNativeAdReady {
    if (!_isReady || !shouldShowAds) return false;
    if (_ads is LevelPlayService) return true;
    return _admob?.isNativeAdReady ?? false;
  }

  NativeAd? consumeNativeAd() {
    if (!_isReady || !shouldShowAds) return null;
    return _admob?.consumeNativeAd();
  }

  NativeAd? get nativeAd {
    if (!_isReady || !shouldShowAds) return null;
    return _admob?.nativeAd;
  }

  LoadAdError? get adError {
    return _admob?.nativeAdError ?? _admob?.addError;
  }

  Future<void> loadBannerAd(int width) async {
    if (!_isReady || !shouldShowAds) return;
    await _admob?.loadBannerAd(width);
  }

  BannerAd? get bannerAd {
    if (!_isReady || !shouldShowAds) return null;
    return _admob?.admobBannerAd;
  }

  void dispose() => _ads?.disposeAds();
}
