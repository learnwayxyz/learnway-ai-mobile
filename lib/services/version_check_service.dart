import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Platform;
import 'package:core/core.dart';
import 'package:learnwayv2/core/di/locator.dart';

import 'package:learnwayv2/shared/utilities/app_version_info.dart';

enum VersionStatus { ok, softUpdate, forceUpdate, maintenance }

class VersionCheckResponse {
  const VersionCheckResponse({
    required this.status,
    required this.minimumVersion,
    required this.latestVersion,
    this.message,
    this.storeUrl,
    required this.isMaintenanceMode,
    this.maintenanceMessage,
    this.maintenanceEndTime,
  });

  final VersionStatus status;
  final String minimumVersion;
  final String latestVersion;
  final String? message;
  final String? storeUrl;
  final bool isMaintenanceMode;
  final String? maintenanceMessage;
  final DateTime? maintenanceEndTime;

  factory VersionCheckResponse.fromJson(Map<String, dynamic> json) {
    final statusStr = json['status'] as String? ?? 'ok';
    final status = switch (statusStr) {
      'soft_update' => VersionStatus.softUpdate,
      'force_update' => VersionStatus.forceUpdate,
      'maintenance' => VersionStatus.maintenance,
      _ => VersionStatus.ok,
    };

    DateTime? maintenanceEndTime;
    final endTimeStr = json['maintenanceEndTime'] as String?;
    if (endTimeStr != null) {
      maintenanceEndTime = DateTime.tryParse(endTimeStr);
    }

    return VersionCheckResponse(
      status: status,
      minimumVersion: json['minimumVersion'] as String? ?? '',
      latestVersion: json['latestVersion'] as String? ?? '',
      message: json['message'] as String?,
      storeUrl: json['storeUrl'] as String?,
      isMaintenanceMode: json['isMaintenanceMode'] as bool? ?? false,
      maintenanceMessage: json['maintenanceMessage'] as String?,
      maintenanceEndTime: maintenanceEndTime,
    );
  }
}

class VersionCheckService {
  static final VersionCheckService _instance = VersionCheckService._internal();
  factory VersionCheckService() => _instance;
  VersionCheckService._internal();

  VersionCheckResponse? _cachedResponse;
  VersionCheckResponse? get lastResponse => _cachedResponse;

  static final _controller = StreamController<VersionCheckResponse>.broadcast();
  static Stream<VersionCheckResponse> get onResponse => _controller.stream;

  Future<VersionCheckResponse?> check() async {
    log('VersionCheckResponse> check()');
    try {
      final client = locator<BaseApiClients>();
      final platform = Platform.isIOS ? 'ios' : 'android';
      final instance = locator.get<AppVersionInfo>();
      final version = await instance.getPackageVersion();
      final versionNumber = version.split('+').first;
      log('Show me the version $versionNumber');
      final response = await client.get(
        Endpoints.appVersionCheck,
        queryParameters: {'platform': platform, 'version': versionNumber},
      );

      log('VersionCheckService(): ${response.body}');
      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        if (body['success'] == true) {
          final data = body['data'] as Map<String, dynamic>;
          log('Version body $data');
          _cachedResponse = VersionCheckResponse.fromJson(data);
          _controller.add(_cachedResponse!);
          return _cachedResponse;
        }
      }
    } catch (e) {
      log('VersionCheckService: $e', name: 'LearnWay');
    }
    return _cachedResponse;
  }

  void notifyIfSoftUpdate() {
    if (_cachedResponse?.status == VersionStatus.softUpdate) {
      Future.delayed(const Duration(milliseconds: 500), () {});
    }
  }
}
