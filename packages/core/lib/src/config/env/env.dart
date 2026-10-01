import 'package:flutter/foundation.dart';

import 'env.dev.dart';
import 'env.staging.dart';
import 'env.prod.dart';

enum Flavor { dev, staging, prod }

class Env {
  static Flavor _currentFlavor = Flavor.dev;

  static void setFlavor(Flavor flavor) {
    _currentFlavor = flavor;
    _printConfig();
  }

  static Flavor get flavor => _currentFlavor;

  static bool get isDev => _currentFlavor == Flavor.dev;
  static bool get isStaging => _currentFlavor == Flavor.staging;
  static bool get isProd => _currentFlavor == Flavor.prod;

  static T _getValue<T>(T dev, T staging, T prod) {
    switch (_currentFlavor) {
      case Flavor.dev:
        return dev;
      case Flavor.staging:
        return staging;
      case Flavor.prod:
        return prod;
    }
  }

  // API Configuration
  // Override at build time with --dart-define=BASE_URL_ENV=dev|staging|prod
  // (or --dart-define=BASE_URL=https://... for an explicit URL).
  static const String _baseUrlOverride = String.fromEnvironment('BASE_URL');
  static const String _baseUrlEnvOverride = String.fromEnvironment(
    'BASE_URL_ENV',
  );

  static String get baseUrl {
    if (_baseUrlOverride.isNotEmpty) return _baseUrlOverride;
    switch (_baseUrlEnvOverride) {
      case 'dev':
        return EnvDev.devbaseUrl;
      case 'staging':
        return EnvStaging.stagebaseUrl;
      case 'prod':
        return EnvProd.prodbaseUrl;
    }
    return _getValue(
      EnvDev.devbaseUrl,
      EnvStaging.stagebaseUrl,
      EnvProd.prodbaseUrl,
    );
  }

  // AI-mentor (ai_mentor package) base URL override.
  // AI_TUTOR_BASE_URL / AI_TUTOR_BASE_URL_ENV are an escape hatch for when
  // this needs to point somewhere different from BASE_URL_ENV. Leave them
  // unset to have aiTutorBaseUrl follow BASE_URL_ENV, so a single
  // --dart-define=BASE_URL_ENV=<env> moves both baseUrl and aiTutorBaseUrl
  // together regardless of --flavor.
  static const String _aiTutorBaseUrlOverride = String.fromEnvironment(
    'AI_TUTOR_BASE_URL',
  );
  static const String _aiTutorBaseUrlEnvOverride = String.fromEnvironment(
    'AI_TUTOR_BASE_URL_ENV',
  );

  // Chosen at build/run time, e.g.
  //   flutter run --flavor dev -t lib/main_dev.dart --dart-define=USE_FUSD=true
  // Ignored in release/profile builds so FUSD can never ship by accident.
  static const bool _useFusdDefine = bool.fromEnvironment('USE_FUSD');
  static const bool _isProduct = bool.fromEnvironment('dart.vm.product');

  static bool get isFusdMode => _useFusdDefine && !_isProduct;

  static String get activeTokenAddress =>
      isFusdMode ? EnvDev.fonBnkUsdContractAddress : usdtContractAddress;

  static String get learnWayIndexerUrl => _getValue(
    EnvDev.devlearnWayIndexerUrl,
    EnvStaging.stagelearnWayIndexerUrl,
    EnvProd.prodlearnWayIndexerUrl,
  );

  static String get userOpsStatus => _getValue(
    EnvDev.devuserOpsStatus,
    EnvStaging.stageuserOpsStatus,
    EnvProd.produserOpsStatus,
  );

  // Obfuscated secrets
  static String get pepAddress => _getValue(
    EnvDev.devpepAddress,
    EnvStaging.stagepepAddress,
    EnvStaging.stagepepAddress,
  );

  static String get exchangeApiKey => _getValue(
    EnvDev.devexchangeApiKey,
    EnvStaging.stageexchangeApiKey,
    EnvProd.prodexchangeApiKey,
  );

  static String get kotanApiKey => _getValue(
    EnvDev.devkotanApiKey,
    EnvStaging.stagekotanApiKey,
    EnvStaging.stagekotanApiKey,
  );

  static String get didItApiKey => _getValue(
    EnvDev.devdidItApiKey,
    EnvStaging.stagedidItApiKey,
    EnvProd.proddidItApiKey,
  );

  static String get chainId => _getValue(
    EnvDev.devChainId,
    EnvStaging.stageChainId,
    EnvProd.prodChainId,
  );

  // Social Media
  static String get telegramAppUrl => _getValue(
    EnvDev.devtelegramAppUrl,
    EnvStaging.stagetelegramAppUrl,
    EnvProd.prodtelegramAppUrl,
  );

  static String get twitterAppUrl => _getValue(
    EnvDev.devtwitterAppUrl,
    EnvStaging.stagetwitterAppUrl,
    EnvProd.prodtwitterAppUrl,
  );

  static String get linkedinAppUrl => _getValue(
    EnvDev.devlinkedinAppUrl,
    EnvStaging.stagelinkedinAppUrl,
    EnvProd.prodlinkedinAppUrl,
  );

  static String get linkedinWebUrl => _getValue(
    EnvDev.devlinkedinWebUrl,
    EnvStaging.stagelinkedinWebUrl,
    EnvProd.prodlinkedinWebUrl,
  );

  // Third Party APIs
  static String get exchangeApi => _getValue(
    EnvDev.devexchangeApi,
    EnvStaging.stageexchangeApi,
    EnvProd.prodexchangeApi,
  );

  static String get kotanBaseUrl => _getValue(
    EnvDev.devkotanBaseUrl,
    EnvStaging.stagekotanBaseUrl,
    EnvProd.prodmainnetKotaniBaseUrl,
  );

  static String get didItBaseUrl => _getValue(
    EnvDev.devdidItBaseUrl,
    EnvStaging.stagedidItBaseUrl,
    EnvProd.proddidItBaseUrl,
  );

  static String get aiTutorBaseUrl {
    if (_aiTutorBaseUrlOverride.isNotEmpty) return _aiTutorBaseUrlOverride;
    final envOverride = _aiTutorBaseUrlEnvOverride.isNotEmpty
        ? _aiTutorBaseUrlEnvOverride
        : _baseUrlEnvOverride;
    switch (envOverride) {
      case 'dev':
        return EnvDev.devAiTutorBaseUrl;
      case 'staging':
        return EnvStaging.stageAiTutorBaseUrl;
      case 'prod':
        return EnvProd.prodAiTutorBaseUrl;
    }
    return _getValue(
      EnvDev.devAiTutorBaseUrl,
      EnvStaging.stageAiTutorBaseUrl,
      EnvProd.prodAiTutorBaseUrl,
    );
  }

  static String get workFlowId => _getValue(
    EnvDev.devworkFlowId,
    EnvStaging.stageworkFlowId,
    EnvProd.prodworkFlowId,
  );

  static String get senderAddress => _getValue(
    EnvDev.devsenderAddress,
    EnvStaging.stagesenderAddress,
    EnvProd.prodsenderAddress,
  );

  static String get appUID =>
      _getValue(EnvDev.devappUID, EnvStaging.stageappUID, EnvProd.prodappUID);

  // Testnet Blockchain
  static String get testnetAccountFactory => _getValue(
    EnvDev.devlightAccount,
    EnvStaging.stagemainnetAccountFactory,
    EnvProd.prodmainnetAccountFactory,
  );

  static String get testnetBundleUrl => _getValue(
    EnvDev.devbundleUrl,
    EnvStaging.stagemainnetBundleUrl,
    EnvProd.prodmainnetBundleUrl,
  );

  static String get testnetRpcUrl => _getValue(
    EnvDev.devrpcUrl,
    EnvStaging.stagemainnetRpcUrl,
    EnvProd.prodmainnetRpcUrl,
  );

  static String get usdtContractAddress => _getValue(
    EnvDev.devtestnetUsdtContractAddress,
    EnvStaging.stagemainnetUsdtContractAddress,
    EnvProd.prodmainnetUsdtContractAddress,
  );

  static const String _tokenDecimalsOverride = String.fromEnvironment(
    'TOKEN_DECIMALS',
  );

  static const int fusdTokenDecimals = 18;

  static int get tokenDecimals {
    if (_tokenDecimalsOverride.isNotEmpty) {
      return int.tryParse(_tokenDecimalsOverride) ?? 6;
    }
    // FUSD (USE_FUSD=true) uses 18 decimals; USDT uses the per-flavor value.
    if (isFusdMode) return fusdTokenDecimals;
    final raw = _getValue(
      EnvDev.devTokenDecimals,
      EnvStaging.stageTokenDecimals,
      EnvProd.prodTokenDecimals,
    );
    return int.tryParse(raw) ?? 6;
  }

  // Mainnet Blockchain
  static String get mainnetAccountFactory => _getValue(
    EnvDev.devlightAccount,
    EnvStaging.stagemainnetAccountFactory,
    EnvProd.prodmainnetAccountFactory,
  );

  static String get mainnetRpcUrl => _getValue(
    EnvDev.devrpcUrl,
    EnvStaging.stagemainnetRpcUrl,
    EnvProd.prodmainnetRpcUrl,
  );

  static String get explorerUrl => _getValue(
    EnvDev.devExplorerUrl,
    EnvStaging.stagemainnetExplorer,
    EnvProd.prodmainnetExplorer,
  );

  static String get bundleUrl => _getValue(
    EnvDev.devbundleUrl,
    EnvStaging.stagemainnetBundleUrl,
    EnvProd.prodmainnetBundleUrl,
  );

  static String get paymasterUrl => _getValue(
    EnvDev.devpaymasterUrl,
    EnvStaging.stagePaymasterUrl,
    EnvProd.prodPaymasterUrl,
  );

  static String get mainnetUsdtContractAddress => _getValue(
    EnvDev.devtestnetUsdtContractAddress,
    EnvStaging.stagemainnetUsdtContractAddress,
    EnvProd.prodmainnetUsdtContractAddress,
  );

  static String get mainnetKotaniBaseUrl => _getValue(
    EnvDev.devkotanBaseUrl,
    EnvStaging.stagemainnetKotaniBaseUrl,
    EnvProd.prodmainnetKotaniBaseUrl,
  );

  static String get webSocketUrl => _getValue(
    EnvDev.webSocketUrl,
    EnvStaging.webSocketUrlStaging,
    EnvProd.webSocketUrlProd,
  );

  static String get sentryDsn => _getValue(
    EnvDev.devSentryDsn,
    EnvStaging.stageSentryDsn,
    EnvProd.prodSentryDsn,
  );

  static String get googleClientIdIos => _getValue(
    EnvDev.devGoogleClientIdIos,
    EnvStaging.stageGoogleClientIdIos,
    EnvProd.prodGoogleClientIdIos,
  );

  static String get googleClientIdAndroid => _getValue(
    EnvDev.devGoogleClientIdAndroid,
    EnvStaging.stageGoogleClientIdAndroid,
    EnvProd.prodGoogleClientIdAndroid,
  );

  static String get androidPackageName => _getValue(
    EnvDev.devAndroidPackageName,
    EnvStaging.stageAndroidPackageName,
    EnvProd.prodAndroidPackageName,
  );

  // static String get bannerAdId => _getValue(
  //   Platform.isIOS ? EnvDev.bannderAdIdIos : EnvDev.bannderAdIdAndroid,
  //   Platform.isIOS ? EnvStaging.bannderAdIdIos : EnvStaging.bannderAdIdAndroid,
  //   Platform.isIOS ? EnvProd.bannderAdIdIos : EnvProd.bannderAdIdAndroid,
  // );

  // static String get rewardedAdId => _getValue(
  //   Platform.isIOS ? EnvDev.rewardedAdIdIos : EnvDev.rewardedAdIdAndroid,
  //   Platform.isIOS
  //       ? EnvStaging.rewardedAdIdIos
  //       : EnvStaging.rewardedAdIdAndroid,
  //   Platform.isIOS ? EnvProd.rewardedAdIdIos : EnvProd.rewardedAdIdAndroid,
  // );

  // static String get interstitialAdId => _getValue(
  //   Platform.isIOS
  //       ? EnvDev.interstitialAdIdIos
  //       : EnvDev.interstitialAdIdAndroid,
  //   Platform.isIOS
  //       ? EnvStaging.interstitialAdIdIos
  //       : EnvStaging.interstitialAdIdAndroid,
  //   Platform.isIOS
  //       ? EnvProd.interstitialAdIdIos
  //       : EnvProd.interstitialAdIdAndroid,
  // );

  // static String get nativeAdId => _getValue(
  //   Platform.isIOS ? EnvDev.nativeAdIdiOS : EnvDev.nativeAdIdAndroid,
  //   Platform.isIOS ? '' : EnvStaging.nativeAdIdAndroid,
  //   Platform.isIOS ? EnvProd.nativeAdIdiOS : EnvProd.nativeAdIdAndroid,
  // );

  // static String get levelPlayAppKey => _getValue(
  //   Platform.isIOS ? EnvDev.appKeyIos : EnvDev.appKeyAndroid,
  //   Platform.isIOS ? EnvStaging.appKeyIos : EnvStaging.appKeyAndroid,
  //   Platform.isIOS ? EnvProd.appKeyIos : EnvProd.appKeyAndroid,
  // );

  // static String get levelPlayTag => _getValue(
  //   EnvDev.levelPlayTag,
  //   EnvStaging.levelPlayTag,
  //   EnvProd.levelPlayTag,
  // );

  // static String get levelPlayRewardedAdId => _getValue(
  //   Platform.isIOS
  //       ? EnvDev.levelPlayRewardedAdIdIos
  //       : EnvDev.levelPlayRewardedAdIdAndroid,
  //   Platform.isIOS
  //       ? EnvStaging.levelPlayRewardedAdIdIos
  //       : EnvStaging.levelPlayRewardedAdIdAndroid,
  //   Platform.isIOS
  //       ? EnvProd.levelPlayRewardedAdIdIos
  //       : EnvProd.levelPlayRewardedAdIdAndroid,
  // );

  // static String get levelPlayInterstitialAdId => _getValue(
  //   Platform.isIOS
  //       ? EnvDev.levelPlayInterstitialAdUnitIdIos
  //       : EnvDev.levelPlayInterstitialAdUnitIdAndroid,
  //   Platform.isIOS
  //       ? EnvStaging.levelPlayInterstitialAdUnitIdIos
  //       : EnvStaging.levelPlayInterstitialAdUnitIdAndroid,
  //   Platform.isIOS
  //       ? EnvProd.levelPlayInterstitialAdUnitIdIos
  //       : EnvProd.levelPlayInterstitialAdUnitIdAndroid,
  // );

  // static String get levelPlayBannerAdId => _getValue(
  //   Platform.isIOS
  //       ? EnvDev.levelPlayBannerAdUnitIdIos
  //       : EnvDev.levelPlayBannerAdUnitIdAndroid,
  //   Platform.isIOS
  //       ? EnvStaging.levelPlayBannerAdUnitIdIos
  //       : EnvStaging.levelPlayBannerAdUnitIdAndroid,
  //   Platform.isIOS
  //       ? EnvProd.levelPlayBannerAdUnitIdIos
  //       : EnvProd.levelPlayBannerAdUnitIdAndroid,
  // );

  // static String get revCatIosApiKey =>
  //     _getValue(EnvDev.revCatIosDevApiKey, '', EnvProd.revCatIosProdApiKey);
  // static String get revCatProdApiKey => _getValue(
  //   EnvDev.revCatAndroidDevApiKey,
  //   '',
  //   EnvProd.revCatAndroidProdApiKey,
  // );
  // static String get entitlementKey =>
  //     _getValue(EnvDev.entitlementKey, '', EnvProd.entitlementKey);
  // static String get TAG =>
  //     _getValue(EnvDev.levelPlayTag, '', EnvProd.levelPlayTag);

  // Convenience getters for active network
  static String get accountFactory =>
      isProd ? mainnetAccountFactory : testnetAccountFactory;

  static String get rpcUrl => isProd ? mainnetRpcUrl : testnetRpcUrl;

  static String get networkName => isProd ? 'Mainnet' : 'Testnet';

  static void _printConfig() {
    debugPrint('========================================');
    debugPrint('Flavor: ${_currentFlavor.name.toUpperCase()}');
    debugPrint('Network: $networkName');
    debugPrint('========================================');
  }
}
