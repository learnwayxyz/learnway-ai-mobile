import 'dart:ui' show VoidCallback;
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class IAdService {
  Future<void> initialize();

  Future<void> loadInterstitial();

  bool get isInterstitialReady;

  Future<void> showInterstitial({VoidCallback? onDismissed});

  Future<void> loadRewarded();

  bool get isRewardedReady;

  void showRewarded({
    required Function(String rewardName, int rewardAmount) onReward,
    VoidCallback? onDismissed,
    VoidCallback? onFailedToShow,
  });

  Future<void> loadNativeAd({VoidCallback? onAdLoaded});

  // Widget? showNativeAd({double height = 300, double width = 350});

  void disposeAds();
}
