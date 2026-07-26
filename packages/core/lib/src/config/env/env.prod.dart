import 'package:envied/envied.dart';

part 'env.prod.g.dart';

enum Flavor { dev, staging, prod }

@Envied(path: '.env.prod')
abstract class EnvProd {
  @EnviedField(varName: 'BASEURL')
  static const String prodbaseUrl = _EnvProd.prodbaseUrl;

  static const bool useFusdAsPrimary = false;

  @EnviedField(varName: 'EXCHANGE_API_KEY', obfuscate: true)
  static final String prodexchangeApiKey = _EnvProd.prodexchangeApiKey;

  @EnviedField(varName: 'LEARNWAYINDEXERURL')
  static const String prodlearnWayIndexerUrl = _EnvProd.prodlearnWayIndexerUrl;

  @EnviedField(varName: 'USEROPSSTATUS')
  static const String produserOpsStatus = _EnvProd.produserOpsStatus;
  // Social Media URLs
  @EnviedField(varName: 'TELEGRAM_APP_URL')
  static const String prodtelegramAppUrl = _EnvProd.prodtelegramAppUrl;

  @EnviedField(varName: 'TWITTER_APP_URL')
  static const String prodtwitterAppUrl = _EnvProd.prodtwitterAppUrl;

  @EnviedField(varName: 'LINKEDIN_APP_URL')
  static const String prodlinkedinAppUrl = _EnvProd.prodlinkedinAppUrl;

  @EnviedField(varName: 'LINKEDIN_WEB_URL')
  static const String prodlinkedinWebUrl = _EnvProd.prodlinkedinWebUrl;

  @EnviedField(varName: 'EXCHANGE_API')
  static const String prodexchangeApi = _EnvProd.prodexchangeApi;

  @EnviedField(varName: 'KOTANIBASEURL')
  static const String prodkotanBaseUrl = _EnvProd.prodkotanBaseUrl;

  @EnviedField(varName: 'DID_IT_BASE_URL')
  static const String proddidItBaseUrl = _EnvProd.proddidItBaseUrl;

  @EnviedField(varName: 'DID_IT_API_KEY')
  static const String proddidItApiKey = _EnvProd.proddidItApiKey;

  @EnviedField(varName: 'WORK_FLOW_ID')
  static const String prodworkFlowId = _EnvProd.prodworkFlowId;

  @EnviedField(varName: 'SENDER_ADDRESS')
  static const String prodsenderAddress = _EnvProd.prodsenderAddress;

  /// Mainnet
  @EnviedField(varName: 'MAINNET_ACCOUNT_FACTORY')
  static const String prodmainnetAccountFactory =
      _EnvProd.prodmainnetAccountFactory;

  @EnviedField(varName: 'MAINNET_RPCURL')
  static const String prodmainnetRpcUrl = _EnvProd.prodmainnetRpcUrl;

  @EnviedField(varName: 'MAINNET_EXPLORER')
  static const String prodmainnetExplorer = _EnvProd.prodmainnetExplorer;

  @EnviedField(varName: 'MAINNET_PAYMASTER_URL')
  static const String prodPaymasterUrl = _EnvProd.prodPaymasterUrl;

  @EnviedField(varName: 'MAINNET_BUNDLEURL')
  static const String prodmainnetBundleUrl = _EnvProd.prodmainnetBundleUrl;

  @EnviedField(varName: 'MAINNET_USDT_CONTRACTADDRESS')
  static const String prodmainnetUsdtContractAddress =
      _EnvProd.prodmainnetUsdtContractAddress;

  @EnviedField(varName: 'KOTANI_MAINNET_BASEURL')
  static const String prodmainnetKotaniBaseUrl =
      _EnvProd.prodmainnetKotaniBaseUrl;

  @EnviedField(varName: 'APP_UID')
  static const String prodappUID = _EnvProd.prodappUID;

  @EnviedField(varName: 'FONBNK_PROD_URL')
  static const String fonBnkProdUrl = _EnvProd.fonBnkProdUrl;

  @EnviedField(varName: 'FONBNK_PROD_CLIENTID')
  static const String fonBnkProdClientId = _EnvProd.fonBnkProdClientId;

  @EnviedField(varName: 'FONBNK_PROD_CLIENTSECRET')
  static const String fonBnkProdClientSecret = _EnvProd.fonBnkProdClientSecret;

  @EnviedField(varName: 'FONBNK_PROD_WIDGET_URL')
  static const String fonBnkProdWidgetUrl = _EnvProd.fonBnkProdWidgetUrl;

  @EnviedField(varName: 'FONBNK_PROD_SOURCE')
  static const String fonBnkProdSource = _EnvProd.fonBnkProdSource;

  @EnviedField(varName: 'FONBNK_PROD_URL_SIGNER')
  static const String fonBnkProdUrlSigner = _EnvProd.fonBnkProdUrlSigner;

  @EnviedField(varName: 'WEB_SOCKET_PROD_URL')
  static const String webSocketUrlProd = _EnvProd.webSocketUrlProd;

  @EnviedField(varName: 'PROD_CHAIN_ID')
  static const String prodChainId = _EnvProd.prodChainId;

  // @EnviedField(varName: 'ADMOB_PROD_ID_ANDROID')
  // static const String admobProdIdAndroid = _EnvProd.admobProdIdAndroid;

  // @EnviedField(varName: 'ADMOB_PROD_ID_IOS')
  // static const String admobProdIdIos = _EnvProd.admobProdIdIos;
  // @EnviedField(varName: 'REVCAT_IOS_PROD_API_KEY')
  // static const String revCatIosProdApiKey = _EnvProd.revCatIosProdApiKey;
  // @EnviedField(varName: 'REVCAT_ANDROID_PROD_API_KEY')
  // static const String revCatAndroidProdApiKey =
  //     _EnvProd.revCatAndroidProdApiKey;

  // @EnviedField(varName: 'REVENUE_ENTLE_PROD_KEY')
  // static const String entitlementKey = _EnvProd.entitlementKey;

  // @EnviedField(varName: 'BANNER_AD_ID_IOS')
  // static const String bannderAdIdIos = _EnvProd.bannderAdIdIos;
  // @EnviedField(varName: 'REWARDED_AD_ID_IOS')
  // static const String rewardedAdIdIos = _EnvProd.rewardedAdIdIos;

  // @EnviedField(varName: 'BANNER_AD_ID_ANDROID')
  // static const String bannderAdIdAndroid = _EnvProd.bannderAdIdAndroid;
  // @EnviedField(varName: 'BANNER_AD_ID_ANDROID')
  // static const String rewardedAdIdAndroid = _EnvProd.rewardedAdIdAndroid;
  // @EnviedField(varName: 'INTERSTITIAL_AD_ID_IOS')
  // static const String interstitialAdIdIos = _EnvProd.interstitialAdIdIos;
  // @EnviedField(varName: 'INTERSTITIAL_AD_ID_ANDROID')
  // static const String interstitialAdIdAndroid =
  //     _EnvProd.interstitialAdIdAndroid;
  // @EnviedField(varName: 'NATIVE_AD_ID_ANDROID')
  // static const String nativeAdIdAndroid = _EnvProd.nativeAdIdAndroid;
  // @EnviedField(varName: 'NATIVE_AD_ID_IOS')
  // static const String nativeAdIdiOS = _EnvProd.nativeAdIdiOS;
  // @EnviedField(varName: 'LVP_PROD_TAG')
  // static const String levelPlayTag = _EnvProd.levelPlayTag;
  // @EnviedField(varName: 'LVP_APP_KEY_ANDROID')
  // static const String appKeyAndroid = _EnvProd.appKeyAndroid;
  // @EnviedField(varName: 'LVP_APP_KEY_IOS')
  // static const String appKeyIos = _EnvProd.appKeyIos;
  // @EnviedField(varName: 'LVP_REWARDED_AD_ID_ANDROID')
  // static const String levelPlayRewardedAdIdAndroid =
  //     _EnvProd.levelPlayRewardedAdIdAndroid;
  // @EnviedField(varName: 'LVP_REWARDED_AD_ID_IOS')
  // static const String levelPlayRewardedAdIdIos =
  //     _EnvProd.levelPlayRewardedAdIdIos;
  // @EnviedField(varName: 'LVP_INTERSTITIAL_AD_ID_ANDROID')
  // static const String levelPlayInterstitialAdUnitIdAndroid =
  //     _EnvProd.levelPlayInterstitialAdUnitIdAndroid;
  // @EnviedField(varName: 'LVP_INTERSTITIAL_AD_ID_IOS')
  // static const String levelPlayInterstitialAdUnitIdIos =
  //     _EnvProd.levelPlayInterstitialAdUnitIdIos;
  // @EnviedField(varName: 'LVP_BANNER_AD_ID_ANDROID')
  // static const String levelPlayBannerAdUnitIdAndroid =
  //     _EnvProd.levelPlayBannerAdUnitIdAndroid;
  // @EnviedField(varName: 'LVP_BANNER_AD_ID_IOS')
  // static const String levelPlayBannerAdUnitIdIos =
  //     _EnvProd.levelPlayBannerAdUnitIdIos;
  // @EnviedField(varName: 'LVP_NATIVE_AD_ID_ANDROID')
  // static const String levelPlayNativeAdUnitIdAndroid =
  //     _EnvProd.levelPlayNativeAdUnitIdAndroid;
  // @EnviedField(varName: 'LVP_NATIVE_AD_ID_IOS')
  // static const String levelPlayNativeAdUnitIdIos =
  //     _EnvProd.levelPlayNativeAdUnitIdIos;

  @EnviedField(varName: 'SENTRY_DSN')
  static const String prodSentryDsn = _EnvProd.prodSentryDsn;

  @EnviedField(varName: 'GOOGLE_CLIENT_ID_IOS')
  static const String prodGoogleClientIdIos = _EnvProd.prodGoogleClientIdIos;

  @EnviedField(varName: 'GOOGLE_CLIENT_ID_ANDROID')
  static const String prodGoogleClientIdAndroid =
      _EnvProd.prodGoogleClientIdAndroid;

  @EnviedField(varName: 'ANDROID_PACKAGE_NAME')
  static const String prodAndroidPackageName = _EnvProd.prodAndroidPackageName;

  @EnviedField(varName: 'AI_TUTOR_BASE_URL')
  static const String prodAiTutorBaseUrl = _EnvProd.prodAiTutorBaseUrl;
}
