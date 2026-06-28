import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:core/src/config/env/api_config_service.dart';
import 'package:learnwayv2/services/ad_service.dart';
import 'package:learnwayv2/services/ads_service.dart';
import 'package:learnwayv2/shared/interfaces/ad_service_interface.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:unity_levelplay_mediation/unity_levelplay_mediation.dart';

@RoutePage()
class NativeAdScreen extends StatefulWidget {
  const NativeAdScreen({super.key});

  @override
  State<NativeAdScreen> createState() => _NativeAdScreen();
}

class _NativeAdScreen extends State<NativeAdScreen>
    with LevelPlayNativeAdListener {
  late LevelPlayNativeAd _nativeAd;
  final double _width = 350;
  final double _height = 300;
  final String _placementName = 'Level_Complete';
  final LevelPlayTemplateType _templateType = LevelPlayTemplateType.MEDIUM;
  int _adViewKey = 0;

  @override
  void initState() {
    super.initState();
    _createNativeAd();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initAndLoadAd() {
    if (locator.isRegistered<RevenueConfigResponse>() &&
        !locator.get<RevenueConfigResponse>().enableAds) {
      return;
    }
    final service = locator<IAdService>();
    if (service is LevelPlayService) {
      if (service.isInitialized) {
        _nativeAd.loadAd();
      } else {
        service.onInitComplete = () {
          if (mounted) _nativeAd.loadAd();
        };
      }
    }
  }

  void _createNativeAd() {
    _nativeAd = LevelPlayNativeAd.builder()
        .withPlacementName(_placementName)
        .withListener(this)
        .build();
  }

  void _destroyAd() {
    _nativeAd.destroyAd();
    setState(() {
      _createNativeAd();
      _adViewKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.dismissableAppBar(
        title: 'Advertising helps fund\nLearnWay\'s mission',
        onDismiss: () => Navigator.of(context).pop(),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: _width,
                    height: _height,
                    child: locator<IAdService>() is AdmobService
                        ? AdService.instance.nativeAd != null
                              ? AdWidget(ad: AdService.instance.nativeAd!)
                              : SizedBox.shrink()
                        : LevelPlayNativeAdView(
                            key: ValueKey(_adViewKey),
                            height: _height,
                            width: _width,
                            nativeAd: _nativeAd,
                            templateType: _templateType,
                            onPlatformViewCreated: _initAndLoadAd,
                          ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              color: Color(0xff12c2e8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonFactory.primaryButton(
                    onPressed: () {
                      context.router.push(PayWallRoute());
                    },
                    text: 'Remove Ads',
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onAdClicked(LevelPlayNativeAd nativeAd, AdInfo adInfo) {
    logMethodName('Native Ad', 'onAdClicked', adInfo);
  }

  @override
  void onAdImpression(LevelPlayNativeAd nativeAd, AdInfo adInfo) {
    logMethodName('Native Ad', 'onAdImpression', adInfo);
  }

  @override
  void onAdLoadFailed(LevelPlayNativeAd nativeAd, IronSourceError error) {
    logMethodName('Native Ad', 'onAdLoadFailed', error);
  }

  @override
  void onAdLoaded(LevelPlayNativeAd nativeAd, AdInfo adInfo) {
    logMethodName('Native Ad', 'onAdLoaded', adInfo);
    setState(() {
      _nativeAd = nativeAd;
    });
  }
}

void showTextDialog(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

void logMethodName(String adFormat, String methodName, dynamic data) {
  print(': $adFormat - $methodName $data');
}
