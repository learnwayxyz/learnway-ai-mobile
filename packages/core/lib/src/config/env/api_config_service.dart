import 'dart:convert';
import 'dart:developer';
import 'package:core/core.dart';
import 'package:core/src/di/locator.dart';

class ApiConfigResponse {
  ApiConfigResponse({
    required this.kotaniPayKey,
    required this.didItApiKey,
    required this.pepAddress,
    required this.expiresAt,
    required this.issuedAt,
    required this.requestId,
  });

  final String kotaniPayKey;
  final String didItApiKey;
  final String pepAddress;
  final DateTime expiresAt;
  final DateTime issuedAt;
  final String requestId;

  factory ApiConfigResponse.fromJson(Map<String, dynamic> json) {
    return ApiConfigResponse(
      kotaniPayKey: json['KOTANIPAYKEY'] as String,
      didItApiKey: json['DID_IT_API_KEY'] as String,
      pepAddress: json['PEPADDRESS'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      issuedAt: DateTime.parse(json['issuedAt'] as String),
      requestId: json['requestId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'KOTANIPAYKEY': kotaniPayKey,
      'DID_IT_API_KEY': didItApiKey,
      'PEPADDRESS': pepAddress,
      'expiresAt': expiresAt.toIso8601String(),
      'issuedAt': issuedAt.toIso8601String(),
      'requestId': requestId,
    };
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

class AdUnitPlatformIds {
  AdUnitPlatformIds({
    this.appKey,
    required this.banner,
    required this.rewarded,
    required this.interstitial,
    required this.native,
  });

  final String? appKey;
  final String banner;
  final String rewarded;
  final String interstitial;
  final String native;

  factory AdUnitPlatformIds.fromJson(Map<String, dynamic> json) {
    return AdUnitPlatformIds(
      appKey: json['appKey'] as String?,
      banner: json['banner'] as String,
      rewarded: json['rewarded'] as String,
      interstitial: json['interstitial'] as String,
      native: json['native'] as String,
    );
  }
}

class AdUnitIds {
  AdUnitIds({required this.ios, required this.android});

  final AdUnitPlatformIds ios;
  final AdUnitPlatformIds android;

  factory AdUnitIds.fromJson(Map<String, dynamic> json) {
    return AdUnitIds(
      ios: AdUnitPlatformIds.fromJson(json['ios'] as Map<String, dynamic>),
      android: AdUnitPlatformIds.fromJson(
        json['android'] as Map<String, dynamic>,
      ),
    );
  }
}

class RevenueCatConfig {
  RevenueCatConfig({
    required this.iosApiKey,
    required this.androidApiKey,
    required this.entitlementKey,
  });

  final String iosApiKey;
  final String androidApiKey;
  final String entitlementKey;

  factory RevenueCatConfig.fromJson(Map<String, dynamic> json) {
    return RevenueCatConfig(
      iosApiKey: json['iosApiKey'] as String,
      androidApiKey: json['androidApiKey'] as String,
      entitlementKey: json['entitlementKey'] as String,
    );
  }
}

class RevenueConfigResponse {
  RevenueConfigResponse({
    required this.enableRevenueService,
    required this.enableAds,
    required this.enablePayment,
    required this.adProvider,
    this.adUnitIds,
    this.revenueCat,
  });

  final bool enableRevenueService;
  final bool enableAds;
  final bool enablePayment;

  final String adProvider;

  final AdUnitIds? adUnitIds;

  final RevenueCatConfig? revenueCat;

  bool get isAdmob => adProvider == 'admob';
  bool get isUnity => adProvider == 'unity';

  factory RevenueConfigResponse.fromJson(Map<String, dynamic> json) {
    return RevenueConfigResponse(
      enableRevenueService: json['enableRevenueService'] as bool,
      enableAds: json['enableAds'] as bool,
      enablePayment: json['enablePayment'] as bool,
      adProvider: json['adProvider'] as String? ?? 'admob',
      adUnitIds: json['adUnitIds'] != null
          ? AdUnitIds.fromJson(json['adUnitIds'] as Map<String, dynamic>)
          : null,
      revenueCat: json['revenueCat'] != null
          ? RevenueCatConfig.fromJson(
              json['revenueCat'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class RevenueConfigService {
  RevenueConfigService(this._client);

  final BaseApiClients _client;

  Future<void> fetchRevenueConfig() async {
    final response = await _client.get(
      Endpoints.revenueConfig,
      headers: {
        'Content-Type': 'application/json',
        'X-LearnWay-Mobile-Access': Env.appUID,
      },
    );
    log('RevenueConfig Response Status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final config = RevenueConfigResponse.fromJson(json);
      if (locator.isRegistered<RevenueConfigResponse>()) {
        locator.unregister<RevenueConfigResponse>();
      }

      locator.registerLazySingleton<RevenueConfigResponse>(() => config);
    } else {
      throw Exception('Failed to load revenue config: ${response.statusCode}');
    }
  }
}

class ApiConfigService {
  ApiConfigService(this._client);
  final BaseApiClients _client;

  Future<void> fetchApiConfig() async {
    final response = await _client.get(
      Endpoints.apiConfig,
      headers: {
        'Content-Type': 'application/json',
        'X-LearnWay-Mobile-Access': Env.appUID,
      },
    );
    log('Response Status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      log('ConfigResponse body: $json');
      final config = ApiConfigResponse.fromJson(json);

      if (locator.isRegistered<ApiConfigResponse>()) {
        locator.unregister<ApiConfigResponse>();
      }

      locator.registerLazySingleton<ApiConfigResponse>(() => config);
    } else {
      throw Exception('Failed to load API config: ${response.statusCode}');
    }
  }
}
