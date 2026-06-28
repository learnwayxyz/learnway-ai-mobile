import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/services/ad_service.dart';
import 'package:learnwayv2/services/ads_service.dart';
import 'package:learnwayv2/shared/interfaces/ad_service_interface.dart';

class NativeAdSlot extends StatefulWidget {
  const NativeAdSlot({super.key});

  @override
  State<NativeAdSlot> createState() => _NativeAdSlotState();
}

class _NativeAdSlotState extends State<NativeAdSlot> {
  final AdService _adService = AdService.instance;

  @override
  void initState() {
    super.initState();
    _adService.premiumStatusNotifier.addListener(_onPremiumChanged);
    if (!_adService.shouldShowAds) return;

    _adService.loadNativeAd(
      onAdLoaded: () {
        if (mounted) setState(() {});
      },
    );
  }

  void _onPremiumChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _adService.premiumStatusNotifier.removeListener(_onPremiumChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_adService.shouldShowAds) return const SizedBox.shrink();

    final service = locator<IAdService>();
    if (service is! AdmobService) return const SizedBox.shrink();

    final nativeAd = service.nativeAd;
    if (nativeAd == null) return const SizedBox.shrink();

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 320,
        maxWidth: 400,
        minHeight: 320,
        maxHeight: 400,
      ),
      child: AdWidget(ad: nativeAd),
    );
  }
}
