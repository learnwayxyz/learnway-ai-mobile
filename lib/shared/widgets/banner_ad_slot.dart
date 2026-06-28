// shared/widgets/banner_ad_slot.dart

import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:core/src/config/env/api_config_service.dart';
import 'package:learnwayv2/services/ad_service.dart';
import 'package:learnwayv2/services/ads_service.dart';
import 'package:learnwayv2/shared/interfaces/ad_service_interface.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:unity_levelplay_mediation/unity_levelplay_mediation.dart';
import 'dart:developer';

class BannerAdSlot extends StatefulWidget {
  final String slotKey;

  const BannerAdSlot({super.key, required this.slotKey});

  @override
  State<BannerAdSlot> createState() => _BannerAdSlotState();
}

class _BannerAdSlotState extends State<BannerAdSlot>
    implements LevelPlayBannerAdViewListener {
  final AdService _adService = AdService.instance;
  bool get _isLevelPlay => locator<IAdService>() is LevelPlayService;

  final GlobalKey<LevelPlayBannerAdViewState> _bannerKey =
      GlobalKey<LevelPlayBannerAdViewState>();

  bool _levelPlayAdLoaded = false;
  BannerAd? _ownedAd;
  bool _adLoaded = false;

  @override
  void initState() {
    super.initState();
    _adService.premiumStatusNotifier.addListener(_onPremiumChanged);
    if (!_adService.shouldShowAds) return;

    if (_isLevelPlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) _bannerKey.currentState?.loadAd();
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadOwnAd());
    }
  }

  void _onPremiumChanged() {
    if (!_adService.shouldShowAds) {
      _ownedAd?.dispose();
      _ownedAd = null;
      _adLoaded = false;
      if (mounted) setState(() {});
    }
  }

  Future<void> _loadOwnAd() async {
    if (!mounted) return;
    final width = MediaQuery.of(context).size.width.truncate();
    final adSize =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);
    if (adSize == null || !mounted) return;

    final revenueConfig = locator.isRegistered<RevenueConfigResponse>()
        ? locator.get<RevenueConfigResponse>()
        : null;

    final ad = BannerAd(
      adUnitId: Platform.isIOS
          ? revenueConfig?.adUnitIds?.ios.banner ?? ''
          : revenueConfig?.adUnitIds?.android.banner ?? '',
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          log('BannerAdSlot[${widget.slotKey}]: loaded');
          if (mounted) setState(() => _adLoaded = true);
        },
        onAdFailedToLoad: (failedAd, error) {
          log('BannerAdSlot[${widget.slotKey}]: failed — $error');
          failedAd.dispose();
          if (mounted) setState(() => _ownedAd = null);
        },
      ),
    )..load();

    if (mounted) {
      setState(() => _ownedAd = ad);
    } else {
      ad.dispose();
    }
  }

  @override
  void dispose() {
    _adService.premiumStatusNotifier.removeListener(_onPremiumChanged);
    if (_isLevelPlay) {
      _bannerKey.currentState?.destroy();
    } else {
      _ownedAd?.dispose();
      _ownedAd = null;
    }
    super.dispose();
  }

  RevenueConfigResponse? get _revenueConfig =>
      locator.isRegistered<RevenueConfigResponse>()
      ? locator.get<RevenueConfigResponse>()
      : null;

  @override
  Widget build(BuildContext context) {
    if (!_adService.shouldShowAds) return const SizedBox.shrink();

    if (_isLevelPlay) {
      return SizedBox(
        width: LevelPlayAdSize.BANNER.width.toDouble(),
        height: LevelPlayAdSize.BANNER.height.toDouble(),
        child: LevelPlayBannerAdView(
          key: _bannerKey,
          adUnitId: Platform.isAndroid
              ? _revenueConfig?.adUnitIds?.android.banner ?? ''
              : _revenueConfig?.adUnitIds?.ios.banner ?? '',
          adSize: LevelPlayAdSize.BANNER,
          listener: this,
          placementName: 'Game_Screen',
        ),
      );
    }

    final ad = _ownedAd;
    if (ad == null || !_adLoaded) return const SizedBox.shrink();

    return SizedBox(
      width: ad.size.width.toDouble(),
      height: ad.size.height.toDouble(),
      child: AdWidget(ad: ad),
    );
  }

  @override
  void onAdLoaded(LevelPlayAdInfo adInfo) {
    log('BannerAdSlot[${widget.slotKey}]: loaded — ${adInfo.adNetwork}');
    if (mounted) setState(() => _levelPlayAdLoaded = true);
  }

  @override
  void onAdLoadFailed(LevelPlayAdError error) {
    log('BannerAdSlot[${widget.slotKey}]: failed — $error');
  }

  @override
  void onAdDisplayed(LevelPlayAdInfo adInfo) {}
  @override
  void onAdDisplayFailed(LevelPlayAdInfo adInfo, LevelPlayAdError error) {}
  @override
  void onAdClicked(LevelPlayAdInfo adInfo) {}
  @override
  void onAdExpanded(LevelPlayAdInfo adInfo) {}
  @override
  void onAdCollapsed(LevelPlayAdInfo adInfo) {}
  @override
  void onAdLeftApplication(LevelPlayAdInfo adInfo) {}
}
