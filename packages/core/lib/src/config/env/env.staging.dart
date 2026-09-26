import 'package:envied/envied.dart';

part 'env.staging.g.dart';

@Envied(path: '.env.staging')
abstract class EnvStaging {
  @EnviedField(varName: 'STAGE_BASEURL')
  static const String stagebaseUrl = _EnvStaging.stagebaseUrl;

  static const bool useFusdAsPrimary = true;

  @EnviedField(varName: 'STAGE_PEPADDRESS', obfuscate: true)
  static final String stagepepAddress = _EnvStaging.stagepepAddress;
  @EnviedField(varName: 'STAGE_EXCHANGE_API_KEY', obfuscate: true)
  static final String stageexchangeApiKey = _EnvStaging.stageexchangeApiKey;

  @EnviedField(varName: 'STAGE_LEARNWAYINDEXERURL')
  static const String stagelearnWayIndexerUrl =
      _EnvStaging.stagelearnWayIndexerUrl;

  @EnviedField(varName: 'STAGE_USEROPSSTATUS')
  static const String stageuserOpsStatus = _EnvStaging.stageuserOpsStatus;
  // Social Media URLs
  @EnviedField(varName: 'STAGE_TELEGRAM_APP_URL')
  static const String stagetelegramAppUrl = _EnvStaging.stagetelegramAppUrl;

  @EnviedField(varName: 'STAGE_TWITTER_APP_URL')
  static const String stagetwitterAppUrl = _EnvStaging.stagetwitterAppUrl;

  @EnviedField(varName: 'STAGE_LINKEDIN_APP_URL')
  static const String stagelinkedinAppUrl = _EnvStaging.stagelinkedinAppUrl;

  @EnviedField(varName: 'STAGE_LINKEDIN_WEB_URL')
  static const String stagelinkedinWebUrl = _EnvStaging.stagelinkedinWebUrl;

  @EnviedField(varName: 'STAGE_EXCHANGE_API')
  static const String stageexchangeApi = _EnvStaging.stageexchangeApi;

  @EnviedField(varName: 'STAGE_KOTANIBASEURL')
  static const String stagekotanBaseUrl = _EnvStaging.stagekotanBaseUrl;

  @EnviedField(varName: 'STAGE_KOTANIPAYKEY')
  static const String stagekotanApiKey = _EnvStaging.stagekotanApiKey;

  @EnviedField(varName: 'STAGE_DID_IT_BASE_URL')
  static const String stagedidItBaseUrl = _EnvStaging.stagedidItBaseUrl;

  @EnviedField(varName: 'STAGE_DID_IT_API_KEY')
  static const String stagedidItApiKey = _EnvStaging.stagedidItApiKey;

  @EnviedField(varName: 'STAGE_WORK_FLOW_ID')
  static const String stageworkFlowId = _EnvStaging.stageworkFlowId;

  @EnviedField(varName: 'STAGE_SENDER_ADDRESS')
  static const String stagesenderAddress = _EnvStaging.stagesenderAddress;

  /// Mainnet
  @EnviedField(varName: 'STAGE_MAINNET_ACCOUNT_FACTORY')
  static const String stagemainnetAccountFactory =
      _EnvStaging.stagemainnetAccountFactory;

  @EnviedField(varName: 'STAGE_MAINNET_RPCURL')
  static const String stagemainnetRpcUrl = _EnvStaging.stagemainnetRpcUrl;

  @EnviedField(varName: 'STAGE_MAINNET_EXPLORER')
  static const String stagemainnetExplorer = _EnvStaging.stagemainnetExplorer;

  @EnviedField(varName: 'STAGE_MAINNET_PAYMASTER_URL')
  static const String stagePaymasterUrl = _EnvStaging.stagePaymasterUrl;

  @EnviedField(varName: 'STAGE_MAINNET_BUNDLEURL')
  static const String stagemainnetBundleUrl = _EnvStaging.stagemainnetBundleUrl;

  @EnviedField(varName: 'STAGE_MAINNET_USDT_CONTRACTADDRESS')
  static const String stagemainnetUsdtContractAddress =
      _EnvStaging.stagemainnetUsdtContractAddress;

  @EnviedField(varName: 'STAGE_TOKEN_DECIMALS', defaultValue: '6')
  static const String stageTokenDecimals = _EnvStaging.stageTokenDecimals;

  @EnviedField(varName: 'STAGE_KOTANI_MAINNET_BASEURL')
  static const String stagemainnetKotaniBaseUrl =
      _EnvStaging.stagemainnetKotaniBaseUrl;

  @EnviedField(varName: 'STAGE_APP_UID')
  static const String stageappUID = _EnvStaging.stageappUID;

  @EnviedField(varName: 'FONBNK_STAGING_URL')
  static const String fonBnkStagingUrl = _EnvStaging.fonBnkStagingUrl;

  @EnviedField(varName: 'FONBNK_STAGING_CLIENTID')
  static const String fonBnkStagingClientId = _EnvStaging.fonBnkStagingClientId;

  @EnviedField(varName: 'FONBNK_STAGING_CLIENTSECRET')
  static const String fonBnkStagingClientSecret =
      _EnvStaging.fonBnkStagingClientSecret;

  @EnviedField(varName: 'FONBNK_STAGING_WIDGET_URL')
  static const String fonBnkStagingWidgetUrl =
      _EnvStaging.fonBnkStagingWidgetUrl;

  @EnviedField(varName: 'FONBNK_STAGING_SOURCE')
  static const String fonBnkStagingSource = _EnvStaging.fonBnkStagingSource;

  @EnviedField(varName: 'FONBNK_STAGING_URL_SIGNER')
  static const String fonBnkStagingUrlSigner =
      _EnvStaging.fonBnkStagingUrlSigner;

  @EnviedField(varName: 'WEB_SOCKET_STAGING_URL')
  static const String webSocketUrlStaging = _EnvStaging.webSocketUrlStaging;

  @EnviedField(varName: 'STAGE_CHAIN_ID')
  static const String stageChainId = _EnvStaging.stageChainId;

  // @EnviedField(varName: 'ADMOB_STAGING_ID_IOS')
  // static const String admobStagingIdIos = _EnvStaging.admobStagingIdIos;

  // @EnviedField(varName: 'ADMOB_STAGING_ID_ANDROID')
  // static const String admobStagingIdAndroid = _EnvStaging.admobStagingIdAndroid;

  // @EnviedField(varName: 'BANNER_AD_ID_IOS')
  // static const String bannderAdIdIos = _EnvStaging.bannderAdIdIos;
  // @EnviedField(varName: 'REWARDED_AD_ID_IOS')
  // static const String rewardedAdIdIos = _EnvStaging.rewardedAdIdIos;

  // @EnviedField(varName: 'BANNER_AD_ID_ANDROID')
  // static const String bannderAdIdAndroid = _EnvStaging.bannderAdIdAndroid;
  // @EnviedField(varName: 'BANNER_AD_ID_ANDROID')
  // static const String rewardedAdIdAndroid = _EnvStaging.rewardedAdIdAndroid;

  // @EnviedField(varName: 'INTERSTITIAL_AD_ID_IOS')
  // static const String interstitialAdIdIos = _EnvStaging.interstitialAdIdIos;

  // @EnviedField(varName: 'INTERSTITIAL_AD_ID_ANDROID')
  // static const String interstitialAdIdAndroid =
  //     _EnvStaging.interstitialAdIdAndroid;

  // @EnviedField(varName: 'NATIVE_AD_ID_ANDROID')
  // static const String nativeAdIdAndroid = _EnvStaging.nativeAdIdAndroid;

  // @EnviedField(varName: 'NATIVE_AD_ID_IOS')
  // static const String nativeAdIdIos = _EnvStaging.nativeAdIdIos;

  // @EnviedField(varName: 'LVP_STAGING_TAG')
  // static const String levelPlayTag = _EnvStaging.levelPlayTag;
  // @EnviedField(varName: 'LVP_APP_KEY_ANDROID')
  // static const String appKeyAndroid = _EnvStaging.appKeyAndroid;
  // @EnviedField(varName: 'LVP_APP_KEY_IOS')
  // static const String appKeyIos = _EnvStaging.appKeyIos;
  // @EnviedField(varName: 'LVP_REWARDED_AD_ID_ANDROID')
  // static const String levelPlayRewardedAdIdAndroid =
  //     _EnvStaging.levelPlayRewardedAdIdAndroid;
  // @EnviedField(varName: 'LVP_REWARDED_AD_ID_IOS')
  // static const String levelPlayRewardedAdIdIos =
  //     _EnvStaging.levelPlayRewardedAdIdIos;
  // @EnviedField(varName: 'LVP_INTERSTITIAL_AD_ID_ANDROID')
  // static const String levelPlayInterstitialAdUnitIdAndroid =
  //     _EnvStaging.levelPlayInterstitialAdUnitIdAndroid;
  // @EnviedField(varName: 'LVP_INTERSTITIAL_AD_ID_IOS')
  // static const String levelPlayInterstitialAdUnitIdIos =
  //     _EnvStaging.levelPlayInterstitialAdUnitIdIos;
  // @EnviedField(varName: 'LVP_BANNER_AD_ID_ANDROID')
  // static const String levelPlayBannerAdUnitIdAndroid =
  //     _EnvStaging.levelPlayBannerAdUnitIdAndroid;
  // @EnviedField(varName: 'LVP_BANNER_AD_ID_IOS')
  // static const String levelPlayBannerAdUnitIdIos =
  //     _EnvStaging.levelPlayBannerAdUnitIdIos;
  // @EnviedField(varName: 'LVP_NATIVE_AD_ID_ANDROID')
  // static const String levelPlayNativeAdUnitIdAndroid =
  //     _EnvStaging.levelPlayNativeAdUnitIdAndroid;
  // @EnviedField(varName: 'LVP_NATIVE_AD_ID_IOS')
  // static const String levelPlayNativeAdUnitIdIos =
  //     _EnvStaging.levelPlayNativeAdUnitIdIos;

  @EnviedField(varName: 'STAGE_SENTRY_DSN')
  static const String stageSentryDsn = _EnvStaging.stageSentryDsn;

  @EnviedField(varName: 'STAGE_GOOGLE_CLIENT_ID_IOS')
  static const String stageGoogleClientIdIos =
      _EnvStaging.stageGoogleClientIdIos;

  @EnviedField(varName: 'STAGE_GOOGLE_CLIENT_ID_ANDROID')
  static const String stageGoogleClientIdAndroid =
      _EnvStaging.stageGoogleClientIdAndroid;

  @EnviedField(varName: 'STAGE_ANDROID_PACKAGE_NAME')
  static const String stageAndroidPackageName =
      _EnvStaging.stageAndroidPackageName;

  @EnviedField(varName: 'AI_TUTOR_BASE_URL')
  static const String stageAiTutorBaseUrl = _EnvStaging.stageAiTutorBaseUrl;
}
