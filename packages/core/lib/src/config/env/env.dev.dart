import 'package:envied/envied.dart';

part 'env.dev.g.dart';

@Envied(path: '.env.dev')
abstract class EnvDev {
  @EnviedField(varName: 'DEV_BASEURL')
  static const String devbaseUrl = _EnvDev.devbaseUrl;

  @EnviedField(varName: 'DEV_PEPADDRESS', obfuscate: true)
  static final String devpepAddress = _EnvDev.devpepAddress;

  @EnviedField(varName: 'DEV_EXCHANGE_API_KEY', obfuscate: true)
  static final String devexchangeApiKey = _EnvDev.devexchangeApiKey;

  @EnviedField(varName: 'DEV_LEARNWAYINDEXERURL')
  static const String devlearnWayIndexerUrl = _EnvDev.devlearnWayIndexerUrl;

  @EnviedField(varName: 'DEV_USEROPS_STATUS')
  static const String devuserOpsStatus = _EnvDev.devuserOpsStatus;
  // Social Media URLs
  @EnviedField(varName: 'DEV_TELEGRAM_APP_URL')
  static const String devtelegramAppUrl = _EnvDev.devtelegramAppUrl;

  @EnviedField(varName: 'DEV_TWITTER_APP_URL')
  static const String devtwitterAppUrl = _EnvDev.devtwitterAppUrl;

  @EnviedField(varName: 'DEV_LINKEDIN_APP_URL')
  static const String devlinkedinAppUrl = _EnvDev.devlinkedinAppUrl;

  @EnviedField(varName: 'DEV_LINKEDIN_WEB_URL')
  static const String devlinkedinWebUrl = _EnvDev.devlinkedinWebUrl;

  @EnviedField(varName: 'DEV_EXCHANGE_API')
  static const String devexchangeApi = _EnvDev.devexchangeApi;

  @EnviedField(varName: 'DEV_KOTANIBASEURL')
  static const String devkotanBaseUrl = _EnvDev.devkotanBaseUrl;

  @EnviedField(varName: 'DEV_KOTANIPAYKEY')
  static const String devkotanApiKey = _EnvDev.devkotanApiKey;

  @EnviedField(varName: 'DEV_DID_IT_BASE_URL')
  static const String devdidItBaseUrl = _EnvDev.devdidItBaseUrl;

  @EnviedField(varName: 'DEV_DID_IT_API_KEY')
  static const String devdidItApiKey = _EnvDev.devdidItApiKey;

  @EnviedField(varName: 'DEV_WORK_FLOW_ID')
  static const String devworkFlowId = _EnvDev.devworkFlowId;

  @EnviedField(varName: 'DEV_SENDER_ADDRESS')
  static const String devsenderAddress = _EnvDev.devsenderAddress;

  /// Testnet
  @EnviedField(varName: 'DEV_TESTNET_ACCOUNT_FACTORY')
  static const String devlightAccount = _EnvDev.devlightAccount;

  @EnviedField(varName: 'DEV_TESTNET_BUNDLEURL')
  static const String devbundleUrl = _EnvDev.devbundleUrl;

  @EnviedField(varName: 'DEV_PAYMASTER_URL')
  static const String devpaymasterUrl = _EnvDev.devpaymasterUrl;

  @EnviedField(varName: 'DEV_TESTNET_RPCURL')
  static const String devrpcUrl = _EnvDev.devrpcUrl;

  @EnviedField(varName: 'DEV_TESTNET_USDT_CONTRACTADDRESS')
  static const String devtestnetUsdtContractAddress =
      _EnvDev.devtestnetUsdtContractAddress;

  @EnviedField(varName: 'DEV_TOKEN_DECIMALS', defaultValue: '6')
  static const String devTokenDecimals = _EnvDev.devTokenDecimals;

  @EnviedField(varName: 'DEV_APP_UID')
  static const String devappUID = _EnvDev.devappUID;

  @EnviedField(varName: 'FONBNK_DEV_URL')
  static const String fonBnkDevUrl = _EnvDev.fonBnkDevUrl;

  @EnviedField(varName: 'FONBNK_TEST_CLIENTID')
  static const String fonBnkTestClientId = _EnvDev.fonBnkTestClientId;

  @EnviedField(varName: 'FONBNK_TEST_CLIENTSECRET')
  static const String fonBnkTestSecret = _EnvDev.fonBnkTestSecret;

  @EnviedField(varName: 'FONBNK_TEST_WIDGET_URL')
  static const String fonBnkDevWidgetUrl = _EnvDev.fonBnkDevWidgetUrl;
  @EnviedField(varName: 'DEV_EXPLORER_URL')
  static const String devExplorerUrl = _EnvDev.devExplorerUrl;

  @EnviedField(varName: 'FONBNK_TEST_SOURCE')
  static const String fonBnkDevSource = _EnvDev.fonBnkDevSource;

  @EnviedField(varName: 'FONBNK_TEST_URL_SIGNER')
  static const String fonBnkDevUrlSigner = _EnvDev.fonBnkDevUrlSigner;

  @EnviedField(varName: 'FONBNK_USD_CONTRACT_ADDRESS')
  static const String fonBnkUsdContractAddress =
      _EnvDev.fonBnkUsdContractAddress;

  @EnviedField(varName: 'WEB_SOCKET_DEV_URL')
  static const String webSocketUrl = _EnvDev.webSocketUrl;
  @EnviedField(varName: 'DEV_CHAIN_ID')
  static const String devChainId = _EnvDev.devChainId;

  // @EnviedField(varName: 'ADMOB_DEV_ID_IOS')
  // static const String admobDevIdIos = _EnvDev.admobDevIdIos;

  // @EnviedField(varName: 'ADMOB_DEV_ID_ANDROID')
  // static const String admobDevIdAndroid = _EnvDev.admobDevIdAndroid;

  // @EnviedField(varName: 'REVCAT_IOS_DEV_API_KEY')
  // static const String revCatIosDevApiKey = _EnvDev.revCatIosDevApiKey;

  // @EnviedField(varName: 'REVCAT_ANDROID_DEV_API_KEY')
  // static const String revCatAndroidDevApiKey = _EnvDev.revCatAndroidDevApiKey;

  // @EnviedField(varName: 'REVENUE_ENTLE_DEV_KEY')
  // static const String entitlementKey = _EnvDev.entitlementKey;

  // @EnviedField(varName: 'BANNER_AD_ID_IOS')
  // static const String bannderAdIdIos = _EnvDev.bannderAdIdIos;
  // @EnviedField(varName: 'REWARDED_AD_ID_IOS')
  // static const String rewardedAdIdIos = _EnvDev.rewardedAdIdIos;

  // @EnviedField(varName: 'BANNER_AD_ID_ANDROID')
  // static const String bannderAdIdAndroid = _EnvDev.bannderAdIdAndroid;
  // @EnviedField(varName: 'REWARDED_AD_ID_ANDROID')
  // static const String rewardedAdIdAndroid = _EnvDev.rewardedAdIdAndroid;
  // @EnviedField(varName: 'INTERSTITIAL_AD_ID_IOS')
  // static const String interstitialAdIdIos = _EnvDev.interstitialAdIdIos;
  // @EnviedField(varName: 'INTERSTITIAL_AD_ID_ANDROID')
  // static const String interstitialAdIdAndroid = _EnvDev.interstitialAdIdAndroid;
  // @EnviedField(varName: 'NATIVE_AD_ID_ANDROID')
  // static const String nativeAdIdAndroid = _EnvDev.nativeAdIdAndroid;
  // @EnviedField(varName: 'NATIVE_AD_ID_IOS')
  // static const String nativeAdIdiOS = _EnvDev.nativeAdIdiOS;
  // @EnviedField(varName: 'LVP_DEV_TAG')
  // static const String levelPlayTag = _EnvDev.levelPlayTag;
  // @EnviedField(varName: 'LVP_APP_KEY_ANDROID')
  // static const String appKeyAndroid = _EnvDev.appKeyAndroid;
  // @EnviedField(varName: 'LVP_APP_KEY_IOS')
  // static const String appKeyIos = _EnvDev.appKeyIos;
  // @EnviedField(varName: 'LVP_REWARDED_AD_ID_ANDROID')
  // static const String levelPlayRewardedAdIdAndroid =
  //     _EnvDev.levelPlayRewardedAdIdAndroid;
  // @EnviedField(varName: 'LVP_REWARDED_AD_ID_IOS')
  // static const String levelPlayRewardedAdIdIos =
  //     _EnvDev.levelPlayRewardedAdIdIos;
  // @EnviedField(varName: 'LVP_INTERSTITIAL_AD_ID_ANDROID')
  // static const String levelPlayInterstitialAdUnitIdAndroid =
  //     _EnvDev.levelPlayInterstitialAdUnitIdAndroid;
  // @EnviedField(varName: 'LVP_INTERSTITIAL_AD_ID_IOS')
  // static const String levelPlayInterstitialAdUnitIdIos =
  //     _EnvDev.levelPlayInterstitialAdUnitIdIos;
  // @EnviedField(varName: 'LVP_BANNER_AD_ID_ANDROID')
  // static const String levelPlayBannerAdUnitIdAndroid =
  //     _EnvDev.levelPlayBannerAdUnitIdAndroid;
  // @EnviedField(varName: 'LVP_BANNER_AD_ID_IOS')
  // static const String levelPlayBannerAdUnitIdIos =
  //     _EnvDev.levelPlayBannerAdUnitIdIos;
  // @EnviedField(varName: 'LVP_NATIVE_AD_ID_ANDROID')
  // static const String levelPlayNativeAdUnitIdAndroid =
  //     _EnvDev.levelPlayNativeAdUnitIdAndroid;
  // @EnviedField(varName: 'LVP_NATIVE_AD_ID_IOS')
  // static const String levelPlayNativeAdUnitIdIos =
  //     _EnvDev.levelPlayNativeAdUnitIdIos;

  @EnviedField(varName: 'DEV_SENTRY_DSN')
  static const String devSentryDsn = _EnvDev.devSentryDsn;

  @EnviedField(varName: 'DEV_GOOGLE_CLIENT_ID_IOS')
  static const String devGoogleClientIdIos = _EnvDev.devGoogleClientIdIos;

  @EnviedField(varName: 'DEV_GOOGLE_CLIENT_ID_ANDROID')
  static const String devGoogleClientIdAndroid =
      _EnvDev.devGoogleClientIdAndroid;

  @EnviedField(varName: 'DEV_ANDROID_PACKAGE_NAME')
  static const String devAndroidPackageName = _EnvDev.devAndroidPackageName;

  @EnviedField(varName: 'AI_TUTOR_BASE_URL')
  static const String devAiTutorBaseUrl = _EnvDev.devAiTutorBaseUrl;
}
