import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:learnwayv2/services/ad_service.dart';
import 'package:learnwayv2/shared/utilities/native_ad_manager.dart';

class NativeAdSlot extends StatefulWidget {
  const NativeAdSlot({super.key});

  @override
  State<NativeAdSlot> createState() => _NativeAdSlotState();
}

class _NativeAdSlotState extends State<NativeAdSlot> {
  final AdService _adService = AdService.instance;
  NativeAd? _nativeAd;

  @override
  void initState() {
    super.initState();
    _adService.premiumStatusNotifier.addListener(_onPremiumChanged);
    _loadAd();
  }

  void _loadAd() {
    if (!_adService.shouldShowAds) return;

    final preloaded = NativeAdManager.instance.consume();
    if (preloaded != null) {
      _nativeAd = preloaded;
      return;
    }

    _nativeAd = NativeAdManager.instance.createAndLoadAd(
      onAdLoaded: (ad) {
        if (mounted) setState(() {});
      },
      onAdFailedToLoad: (ad, error) {
        if (mounted) setState(() => _nativeAd = null);
      },
    );
  }

  void _onPremiumChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _adService.premiumStatusNotifier.removeListener(_onPremiumChanged);
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_adService.shouldShowAds || _nativeAd == null) {
      return const SizedBox.shrink();
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 320,
        maxWidth: 400,
        minHeight: 320,
        maxHeight: 400,
      ),
      child: AdWidget(ad: _nativeAd!),
    );
  }
}
