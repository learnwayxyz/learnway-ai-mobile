import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/core/di/locator.dart';

import 'package:learnwayv2/features/notifications/model/notification_model.dart';
import 'package:learnwayv2/features/notifications/network_exception.dart';
import 'package:http/http.dart' as http;

abstract class NotificationDataSource {
  Future<bool> deleteNotification(String notificationId);
  Future<bool> deleteAllNotifications();
  Future<bool> markAsRead(String notificationId);
  Future<bool> markAllAsRead();
  Future<bool> sendTokenDevice(String deviceToken);
  Future<NotificationResponse> getUserNotifications({int? limit, int? offset});
}

class NotificationDataSourceImpl implements NotificationDataSource {
  NotificationDataSourceImpl(BaseApiClients? client)
    : _client = client ?? locator.get<BaseApiClients>();
  final BaseApiClients _client;

  @override
  Future<bool> deleteAllNotifications() async {
    try {
      final response = await _client.delete(Endpoints.getNotifications);

      log(
        'deleteAllNotifications response: ${response.statusCode} - ${response.body}',
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw NotificationFailure(
          'Failed to delete all notifications: ${response.statusCode}',
        );
      }
    } on HttpException catch (e) {
      throw NotificationFailure('HTTP error: ${e.message}');
    } on SocketException catch (e) {
      throw NotificationFailure('Network error: ${e.message}');
    } catch (e) {
      log('Error in deleteAllNotifications: $e');
      throw NotificationFailure('Failed to delete all notifications: $e');
    }
  }

  @override
  Future<bool> deleteNotification(String notificationId) async {
    try {
      final response = await _client.delete(
        '${Endpoints.getNotifications}/$notificationId',
      );

      log(
        'deleteNotification response: ${response.statusCode} - ${response.body}',
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw NotificationFailure(
          'Failed to delete notification: ${response.statusCode}',
        );
      }
    } on HttpException catch (e) {
      throw NotificationFailure('HTTP error: ${e.message}');
    } on SocketException catch (e) {
      throw NotificationFailure('Network error: ${e.message}');
    } catch (e) {
      log('Error in deleteNotification: $e');
      throw NotificationFailure('Failed to delete notification: $e');
    }
  }

  @override
  Future<bool> markAllAsRead() async {
    try {
      final response = await _client.patch(
        body: {},
        '${Endpoints.getNotifications}/read-all',
      );

      log('markAllAsRead response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw NotificationFailure(
          'Failed to mark all notifications as read: ${response.statusCode}',
        );
      }
    } on HttpException catch (e) {
      throw NotificationFailure('HTTP error: ${e.message}');
    } on SocketException catch (e) {
      throw NotificationFailure('Network error: ${e.message}');
    } catch (e) {
      log('Error in markAllAsRead: $e');
      throw NotificationFailure('Failed to mark all as read: $e');
    }
  }

  @override
  Future<bool> markAsRead(String notificationId) async {
    try {
      final response = await _client.patch(
        body: {},
        '${Endpoints.getNotifications}/$notificationId/read',
      );

      log('markAsRead response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw NotificationFailure(
          'Failed to mark notification as read: ${response.statusCode}',
        );
      }
    } on HttpException catch (e) {
      throw NotificationFailure('HTTP error: ${e.message}');
    } on SocketException catch (e) {
      throw NotificationFailure('Network error: ${e.message}');
    } catch (e) {
      log('Error in markAsRead: $e');
      throw NotificationFailure('Failed to mark as read: $e');
    }
  }

  @override
  Future<bool> sendTokenDevice(String deviceToken) async {
    try {
      final platform = await _getDeviceDetails();
      final token = await SharedPreferencesStore.getUserToken(userTokenKey);

      log('platform: $platform');

      final url = Env.isDev
          ? '${Env.baseUrl}/${Endpoints.postDeviceToken}'
          : '${Env.baseUrl}/${Endpoints.postDeviceToken}';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
          'Authorization': 'Bearer ${token ?? ''}',
        },
        body: jsonEncode({
          "token": deviceToken,
          "platform":
              platform['platform']?.toString().toUpperCase() ?? 'UNKNOWN',
          "deviceName": platform['device'] ?? 'Unknown Device',
          "appVersion": platform['version'] ?? '1.0.0',
        }),
      );

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      return response.statusCode == 200;
    } catch (e, stackTrace) {
      log('Error in sendTokenDevice: $e');
      return false;
    }
  }

  Future<Map<String, String>> _getDeviceDetails() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return {
        'platform': 'ANDROID',
        'device': '${androidInfo.manufacturer} ${androidInfo.model}',
        'version': androidInfo.version.release,
      };
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return {
        'platform': 'IOS',
        'device': '${iosInfo.name} ${iosInfo.model}',
        'version': iosInfo.systemVersion,
      };
    }

    return {'platform': 'UNKNOWN', 'device': 'Unknown', 'version': '1.0.0'};
  }

  @override
  Future<NotificationResponse> getUserNotifications({
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (limit != null) queryParams['limit'] = limit.toString();
      if (offset != null) queryParams['offset'] = offset.toString();

      final uri = Uri.parse(
        Endpoints.getNotifications,
      ).replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

      final response = await _client.get(uri.toString());

      log('getUserNotifications(): ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return NotificationResponse.fromJson(jsonData);
      } else {
        throw NotificationFailure(
          'Failed to fetch notifications: ${response.statusCode}',
        );
      }
    } on FormatException {
      return Future.error(NotificationFailure('Invalid response format.'));
    } on HttpException catch (e) {
      return Future.error(NotificationFailure('HTTP error: ${e.message}'));
    } on SocketException catch (e) {
      return Future.error(NotificationFailure('Network error: ${e.message}'));
    } on Exception catch (e) {
      return Future.error(
        NotificationFailure('An unexpected error occurred: $e'),
      );
    }
  }
}
