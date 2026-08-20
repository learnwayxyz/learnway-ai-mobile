import 'dart:async';
import 'dart:developer';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:core/src/config/env/api_config_service.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/shared/interfaces/ad_service_interface.dart';
import 'package:learnwayv2/shared/utilities/native_ad_manager.dart';
import 'package:unity_levelplay_mediation/unity_levelplay_mediation.dart';

class LevelPlayService
    with
        LevelPlayInitListener,
        LevelPlayInterstitialAdListener,
        LevelPlayRewardedAdListener,
        LevelPlayImpressionDataListener
    implements IAdService {
  bool _isInitialized = false;
  bool _isInterstitialReady = false;
  bool _isRewardedReady = false;

  Function(String, int)? _pendingOnReward;
  VoidCallback? _pendingOnDismissed;

  VoidCallback? onInitComplete;

  late LevelPlayInterstitialAd _interstitialAd;
  late LevelPlayRewardedAd _rewardedAd;

  LevelPlayNativeAd? _nativeAd;

  bool get isInitialized => _isInitialized;

  RevenueConfigResponse? get _revenueConfig =>
      locator.isRegistered<RevenueConfigResponse>()
      ? locator.get<RevenueConfigResponse>()
      : null;

  String get _appKey {
    final ids = _revenueConfig?.adUnitIds;
    if (ids != null) {
      final key = Platform.isIOS ? ids.ios.appKey : ids.android.appKey;
      if (key != null) return key;
    }
    return '';
  }

  String get _interstitialAdId {
    final ids = _revenueConfig?.adUnitIds;
    if (ids != null) {
      return Platform.isIOS ? ids.ios.interstitial : ids.android.interstitial;
    }
    return '';
  }

  String get _rewardedAdId {
    final ids = _revenueConfig?.adUnitIds;
    if (ids != null) {
      final result = Platform.isIOS ? ids.ios.rewarded : ids.android.rewarded;
      log('Android rewarded adunit id ${result}');
      return result;
    }
    return '';
  }

  @override
  Future<void> initialize() async {
    if (_revenueConfig?.enableAds == false) return;

    try {
      LevelPlay.setFlutterVersion('3.32.7');

      _interstitialAd = LevelPlayInterstitialAd(adUnitId: _interstitialAdId);
      _interstitialAd.setListener(this);

      _rewardedAd = LevelPlayRewardedAd(adUnitId: _rewardedAdId);
      _rewardedAd.setListener(this);

      LevelPlay.addImpressionDataListener(this);
      unawaited(enableDebug());

      LevelPlay.setMetaData({
        'is_test_suite': ['enable'],
      });
      final initRequest = LevelPlayInitRequest.builder(
        _appKey,
      ).withUserId(LocalStorageService.getUserSync()?.id ?? '').build();

      await LevelPlay.init(initRequest: initRequest, initListener: this);
    } on PlatformException catch (e) {
      _log('init', e);
    }
  }

  @override
  Future<void> loadNativeAd({VoidCallback? onAdLoaded}) async {
    throw UnimplementedError();
  }

  @override
  bool get isInterstitialReady => _isInterstitialReady;

  @override
  Future<void> loadInterstitial() async {
    await _interstitialAd.loadAd();
    _isInterstitialReady = await _interstitialAd.isAdReady();
  }

  @override
  Future<void> showInterstitial({VoidCallback? onDismissed}) async {
    if (_isInterstitialReady) {
      await _interstitialAd.showAd(placementName: 'Quests');
    } else {
      onDismissed?.call();
    }
  }

  @override
  bool get isRewardedReady => _isRewardedReady;

  @override
  Future<void> loadRewarded() async {
    log('Called LevelPlay service for Rewarded');
    _isRewardedReady = false;
    await _rewardedAd.loadAd();
    // _isRewardedReady is set to true in onAdLoaded when the ad is ready
  }

  @override
  void showRewarded({
    required Function(String rewardName, int rewardAmount) onReward,
    VoidCallback? onDismissed,
    VoidCallback? onFailedToShow,
  }) async {
    final isReady = await _rewardedAd.isAdReady();
    log('Show Rewarded ad called(isReady: $isReady)');
    if (isReady) {
      _pendingOnReward = onReward;
      _pendingOnDismissed = onDismissed;
      await _rewardedAd.showAd(placementName: 'Home_Screen');
    } else {
      onFailedToShow?.call();
    }
  }

  @override
  void onInitSuccess(LevelPlayConfiguration configuration) {
    _isInitialized = true;
    LevelPlay.launchTestSuite();
    // loadInterstitial();
    // loadRewarded();
    onInitComplete?.call();
    onInitComplete = null;
  }

  @override
  void onInitFailed(LevelPlayInitError error) => _log('onInitFailed', error);

  @override
  void onAdLoaded(LevelPlayAdInfo adInfo) => _log('onAdLoaded', adInfo);

  @override
  void onAdLoadFailed(LevelPlayAdError error) => _log('onAdLoadFailed', error);

  @override
  void onAdDisplayed(LevelPlayAdInfo adInfo) {}

  @override
  void onAdDisplayFailed(LevelPlayAdError error, LevelPlayAdInfo adInfo) =>
      _log('onAdDisplayFailed', '$error | $adInfo');

  @override
  void onAdClicked(LevelPlayAdInfo adInfo) {}

  @override
  void onAdClosed(LevelPlayAdInfo adInfo) {
    if (adInfo.adFormat == 'rewarded_video') {
      _pendingOnDismissed?.call();
      _pendingOnDismissed = null;
      loadRewarded();
    } else {
      loadInterstitial();
    }
  }

  @override
  void onAdInfoChanged(LevelPlayAdInfo adInfo) {}

  @override
  void onAdRewarded(LevelPlayReward reward, LevelPlayAdInfo adInfo) {
    _log('onAdRewarded', '${reward.name} x${reward.amount}');
    _pendingOnReward?.call(reward.name, reward.amount);
    _pendingOnReward = null;
  }

  @override
  void onImpressionSuccess(LevelPlayImpressionData impressionData) {}

  Future<void> enableDebug() async {
    await LevelPlay.setAdaptersDebug(true);
    LevelPlay.validateIntegration();
  }

  void _log(String method, dynamic data) =>
      log('LevelPlayService.$method — $data');

  @override
  void disposeAds() {
    _nativeAd?.destroyAd();
    _nativeAd = null;
  }
}

class AdmobService implements IAdService {
  AdmobService();

  static final AdmobService _instance = AdmobService();
  static AdmobService get instance => _instance;

  RewardedAd? _rewardedAd;
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  LoadAdError? addError;

  bool _isInterstitialReady = false;
  bool _isBannerAdReady = false;
  bool _isRewardedReady = false;
  bool _isLoadingInterstitial = false;
  bool _isLoadingRewarded = false;

  int _rewardedLoadAttempts = 0;
  int _interstitialLoadAttempts = 0;
  static const _maxRetries = 3;

  RevenueConfigResponse? get _revenueConfig =>
      locator.isRegistered<RevenueConfigResponse>()
      ? locator.get<RevenueConfigResponse>()
      : null;

  String get _bannerAdUnitId {
    final ids = _revenueConfig?.adUnitIds;
    if (ids != null) {
      return Platform.isIOS ? ids.ios.banner : ids.android.banner;
    }
    return '';
  }

  String get _rewardedAdUnitId {
    final ids = _revenueConfig?.adUnitIds;
    if (ids != null) {
      return Platform.isIOS ? ids.ios.rewarded : ids.android.rewarded;
    }
    return '';
  }

  String get _interstitialAdUnitId {
    final ids = _revenueConfig?.adUnitIds;
    if (ids != null) {
      return Platform.isIOS ? ids.ios.interstitial : ids.android.interstitial;
    }
    return '';
  }

  @override
  Future<void> initialize() async {
    if (_revenueConfig?.enableAds == false) return;
    loadRewarded();
  }

  Future<void> loadBannerAd(int width) async {
    if (_isBannerAdReady || _bannerAd != null) return;

    final adSize =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);
    if (adSize == null) return;

    _bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          log('AdmobService: Banner loaded.');
          _isBannerAdReady = true;
        },
        onAdFailedToLoad: (ad, error) {
          log('AdmobService: Banner failed — $error');
          ad.dispose();
          _bannerAd = null;
          _isBannerAdReady = false;
        },
      ),
    )..load();
  }

  BannerAd? get admobBannerAd => _isBannerAdReady ? _bannerAd : null;

  @override
  bool get isInterstitialReady => _isInterstitialReady;

  @override
  Future<void> loadInterstitial({VoidCallback? onAdDismissed}) async {
    if (_isLoadingInterstitial || _isInterstitialReady) return;
    _isLoadingInterstitial = true;

    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialReady = true;
          _isLoadingInterstitial = false;
          _interstitialLoadAttempts = 0;
          _setFullScreenCallback(
            ad,
            adType: 'Interstitial',
            onDismissed: () {
              _isInterstitialReady = false;
              onAdDismissed?.call();
              loadInterstitial();
            },
          );
        },
        onAdFailedToLoad: (error) {
          log('AdmobService: Interstitial failed — $error');
          _isInterstitialReady = false;
          _isLoadingInterstitial = false;
          _interstitialLoadAttempts++;
          if (_interstitialLoadAttempts <= _maxRetries) {
            Timer(
              Duration(seconds: 2 * _interstitialLoadAttempts),
              () => loadInterstitial(),
            );
          }
        },
      ),
    );
  }

  @override
  Future<void> showInterstitial({VoidCallback? onDismissed}) async {
    if (_isInterstitialReady && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _isInterstitialReady = false;
          onDismissed?.call();
          loadInterstitial();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          log('AdmobService: Interstitial failed to show — $error');
          ad.dispose();
          _isInterstitialReady = false;
          onDismissed?.call();
          loadInterstitial();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
      _isInterstitialReady = false;
    } else {
      log('AdmobService: Interstitial not ready.');
      onDismissed?.call();
      if (!_isLoadingInterstitial) loadInterstitial();
    }
  }

  @override
  bool get isRewardedReady => _isRewardedReady;

  @override
  Future<void> loadRewarded() async {
    if (_isLoadingRewarded || _isRewardedReady) return;
    _isLoadingRewarded = true;

    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedReady = true;
          _isLoadingRewarded = false;
          _rewardedLoadAttempts = 0;
          _setFullScreenCallback(
            ad,
            adType: 'Rewarded',
            onDismissed: () {
              _isRewardedReady = false;
              loadRewarded();
            },
          );
        },
        onAdFailedToLoad: (error) {
          log('AdmobService: Rewarded failed — $error');
          _rewardedAd = null;
          _isRewardedReady = false;
          _isLoadingRewarded = false;
          _rewardedLoadAttempts++;
          if (_rewardedLoadAttempts <= _maxRetries) {
            Timer(
              Duration(seconds: 2 * _rewardedLoadAttempts),
              () => loadRewarded(),
            );
          }
        },
      ),
    );
  }

  @override
  void showRewarded({
    required Function(String rewardName, int rewardAmount) onReward,
    VoidCallback? onDismissed,
    VoidCallback? onFailedToShow,
  }) {
    if (_isRewardedReady && _rewardedAd != null) {
      final ad = _rewardedAd!;
      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (_) {
          ad.dispose();
          _isRewardedReady = false;
          onDismissed?.call();
          loadRewarded();
        },
        onAdFailedToShowFullScreenContent: (_, error) {
          log('AdmobService: Rewarded failed to show — $error');
          ad.dispose();
          _isRewardedReady = false;
          onFailedToShow?.call();
          loadRewarded();
        },
      );
      ad.show(
        onUserEarnedReward: (_, reward) {
          onReward(reward.type, reward.amount.toInt());
        },
      );
      _rewardedAd = null;
      _isRewardedReady = false;
    } else {
      log('AdmobService: Rewarded not ready.');
      onFailedToShow?.call();
      if (!_isLoadingRewarded) loadRewarded();
    }
  }

  @override
  Future<void> loadNativeAd({VoidCallback? onAdLoaded}) async {
    NativeAdManager.instance.preload(onAdLoaded: onAdLoaded);
  }

  bool get isNativeAdReady => NativeAdManager.instance.isReady;
  NativeAd? get nativeAd => NativeAdManager.instance.consume();
  NativeAd? consumeNativeAd() => NativeAdManager.instance.consume();
  LoadAdError? get nativeAdError => NativeAdManager.instance.lastError;

  @override
  void disposeAds() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isRewardedReady = false;

    _bannerAd?.dispose();
    _bannerAd = null;
    _isBannerAdReady = false;

    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isInterstitialReady = false;

    NativeAdManager.instance.dispose();
  }

  void _setFullScreenCallback(
    Ad ad, {
    required String adType,
    required VoidCallback onDismissed,
  }) {
    final callback = FullScreenContentCallback<Ad>(
      onAdShowedFullScreenContent: (_) => log('AdmobService: $adType shown.'),
      onAdDismissedFullScreenContent: (_) {
        log('AdmobService: $adType dismissed.');
        ad.dispose();
        onDismissed();
      },
      onAdFailedToShowFullScreenContent: (_, error) {
        log('AdmobService: $adType failed to show — $error');
        ad.dispose();
      },
    );

    if (ad is RewardedAd) {
      ad.fullScreenContentCallback =
          callback as FullScreenContentCallback<RewardedAd>;
    }
    if (ad is InterstitialAd) {
      ad.fullScreenContentCallback =
          callback as FullScreenContentCallback<InterstitialAd>;
    }
  }
}

void logMethodName(String adFormat, String methodName, dynamic data) {
  log(': $adFormat - $methodName $data');
}

