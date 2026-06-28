import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:core/core.dart';
import 'package:learnwayv2/core/di/locator.dart';

import 'package:learnwayv2/features/badges/models/badge_model.dart';
import 'package:learnwayv2/features/badges/models/badge_catalog_model.dart';
import 'package:learnwayv2/features/badges/models/badge_exceptions.dart';

class BadgeDataSource {
  final BaseApiClients _baseApi = locator<BaseApiClients>();

  /// Fetch all badges for a specific user
  Future<List<BadgeModel>> getUserBadges(String userId) async {
    final endpoint = '${Endpoints.getUserBadges}/$userId';

    try {
      developer.log(
        'Fetching badges for user: $userId',
        name: 'BadgeDataSource',
      );
      final response = await _baseApi.get(endpoint);

      if (response.statusCode == 200) {
        try {
          final List<dynamic> decoded = json.decode(response.body);
          final badges = decoded
              .map((badge) => BadgeModel.fromJson(badge))
              .toList();
          developer.log(
            'Successfully fetched ${badges.length} badges',
            name: 'BadgeDataSource',
          );
          return badges;
        } on FormatException catch (e, stackTrace) {
          developer.log(
            'Failed to parse badges response',
            error: e,
            stackTrace: stackTrace,
            name: 'BadgeDataSource',
          );
          throw BadgeParsingException(
            details: 'Could not parse badges data',
            originalError: e,
            stackTrace: stackTrace,
          );
        } catch (e, stackTrace) {
          developer.log(
            'Failed to decode badges',
            error: e,
            stackTrace: stackTrace,
            name: 'BadgeDataSource',
          );
          throw BadgeParsingException(
            details: e.toString(),
            originalError: e,
            stackTrace: stackTrace,
          );
        }
      } else if (response.statusCode == 404) {
        throw BadgeNotFoundException('User badges not found for user: $userId');
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw const BadgeAuthException(
          details: 'Not authorized to access badges',
        );
      } else if (response.statusCode >= 500) {
        throw BadgeServerException(
          details: 'Server error (${response.statusCode})',
        );
      } else {
        throw BadgeApiException(
          'Failed to fetch user badges',
          statusCode: response.statusCode,
          details: response.body,
        );
      }
    } on SocketException catch (e, stackTrace) {
      developer.log(
        'Network error fetching badges',
        error: e,
        name: 'BadgeDataSource',
      );
      throw BadgeNetworkException(
        details: 'Please check your internet connection',
        originalError: e,
        stackTrace: stackTrace,
      );
    } on TimeoutException catch (e, stackTrace) {
      developer.log(
        'Request timeout fetching badges',
        error: e,
        name: 'BadgeDataSource',
      );
      throw BadgeServerException(
        details: 'Request timed out',
        originalError: e,
        stackTrace: stackTrace,
      );
    } on BadgeException {
      rethrow;
    } catch (e, stackTrace) {
      developer.log(
        'Unexpected error fetching badges',
        error: e,
        stackTrace: stackTrace,
        name: 'BadgeDataSource',
      );
      throw BadgeApiException(
        'Unexpected error fetching badges',
        details: e.toString(),
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Fetch user badge showcase (summary with categories)
  Future<Map<String, dynamic>> getUserBadgeShowcase(String userId) async {
    final endpoint = '${Endpoints.getUserBadgeShowcase}/$userId/showcase';

    try {
      developer.log(
        'Fetching badge showcase for user: $userId',
        name: 'BadgeDataSource',
      );
      final response = await _baseApi.get(endpoint);

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> decoded = json.decode(response.body);
          developer.log(
            'Successfully fetched badge showcase',
            name: 'BadgeDataSource',
          );
          return decoded;
        } on FormatException catch (e, stackTrace) {
          developer.log(
            'Failed to parse showcase response',
            error: e,
            stackTrace: stackTrace,
            name: 'BadgeDataSource',
          );
          throw BadgeParsingException(
            details: 'Could not parse badge showcase data',
            originalError: e,
            stackTrace: stackTrace,
          );
        } catch (e, stackTrace) {
          developer.log(
            'Failed to decode showcase',
            error: e,
            stackTrace: stackTrace,
            name: 'BadgeDataSource',
          );
          throw BadgeParsingException(
            details: e.toString(),
            originalError: e,
            stackTrace: stackTrace,
          );
        }
      } else if (response.statusCode == 404) {
        throw BadgeNotFoundException(
          'Badge showcase not found for user: $userId',
        );
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw const BadgeAuthException(
          details: 'Not authorized to access badge showcase',
        );
      } else if (response.statusCode >= 500) {
        throw BadgeServerException(
          details: 'Server error (${response.statusCode})',
        );
      } else {
        throw BadgeApiException(
          'Failed to fetch badge showcase',
          statusCode: response.statusCode,
          details: response.body,
        );
      }
    } on SocketException catch (e, stackTrace) {
      developer.log(
        'Network error fetching showcase',
        error: e,
        name: 'BadgeDataSource',
      );
      throw BadgeNetworkException(
        details: 'Please check your internet connection',
        originalError: e,
        stackTrace: stackTrace,
      );
    } on TimeoutException catch (e, stackTrace) {
      developer.log(
        'Request timeout fetching showcase',
        error: e,
        name: 'BadgeDataSource',
      );
      throw BadgeServerException(
        details: 'Request timed out',
        originalError: e,
        stackTrace: stackTrace,
      );
    } on BadgeException {
      rethrow;
    } catch (e, stackTrace) {
      developer.log(
        'Unexpected error fetching showcase',
        error: e,
        stackTrace: stackTrace,
        name: 'BadgeDataSource',
      );
      throw BadgeApiException(
        'Unexpected error fetching badge showcase',
        details: e.toString(),
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Fetch badge catalog with all badges, categories, and user progress
  Future<BadgeCatalogResponse> getBadgeCatalog(String userId) async {
    final endpoint = '${Endpoints.getBadgeCatalog}/$userId/catalog';

    try {
      developer.log(
        'Fetching badge catalog for user: $userId',
        name: 'BadgeDataSource',
      );
      final response = await _baseApi.get(endpoint);

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> decoded = json.decode(response.body);
          final catalog = BadgeCatalogResponse.fromJson(decoded);
          developer.log(
            'Successfully fetched badge catalog with ${catalog.totalBadges} badges',
            name: 'BadgeDataSource',
          );
          return catalog;
        } on FormatException catch (e, stackTrace) {
          developer.log(
            'Failed to parse catalog response',
            error: e,
            stackTrace: stackTrace,
            name: 'BadgeDataSource',
          );
          throw BadgeParsingException(
            details: 'Could not parse badge catalog data',
            originalError: e,
            stackTrace: stackTrace,
          );
        } catch (e, stackTrace) {
          developer.log(
            'Failed to decode catalog',
            error: e,
            stackTrace: stackTrace,
            name: 'BadgeDataSource',
          );
          throw BadgeParsingException(
            details: e.toString(),
            originalError: e,
            stackTrace: stackTrace,
          );
        }
      } else if (response.statusCode == 404) {
        throw BadgeNotFoundException(
          'Badge catalog not found for user: $userId',
        );
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw const BadgeAuthException(
          details: 'Not authorized to access badge catalog',
        );
      } else if (response.statusCode >= 500) {
        throw BadgeServerException(
          details: 'Server error (${response.statusCode})',
        );
      } else {
        throw BadgeApiException(
          'Failed to fetch badge catalog',
          statusCode: response.statusCode,
          details: response.body,
        );
      }
    } on SocketException catch (e, stackTrace) {
      developer.log(
        'Network error fetching catalog',
        error: e,
        name: 'BadgeDataSource',
      );
      throw BadgeNetworkException(
        details: 'Please check your internet connection',
        originalError: e,
        stackTrace: stackTrace,
      );
    } on TimeoutException catch (e, stackTrace) {
      developer.log(
        'Request timeout fetching catalog',
        error: e,
        name: 'BadgeDataSource',
      );
      throw BadgeServerException(
        details: 'Request timed out',
        originalError: e,
        stackTrace: stackTrace,
      );
    } on BadgeException {
      rethrow;
    } catch (e, stackTrace) {
      developer.log(
        'Unexpected error fetching catalog',
        error: e,
        stackTrace: stackTrace,
        name: 'BadgeDataSource',
      );
      throw BadgeApiException(
        'Unexpected error fetching badge catalog',
        details: e.toString(),
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Fetch details for a specific badge type
  Future<BadgeDetailsModel> getBadgeDetails(String badgeType) async {
    final endpoint = '${Endpoints.getBadgeDetails}/$badgeType';

    try {
      developer.log(
        'Fetching details for badge: $badgeType',
        name: 'BadgeDataSource',
      );
      final response = await _baseApi.get(endpoint);

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> decoded = json.decode(response.body);
          final details = BadgeDetailsModel.fromJson(decoded);
          developer.log(
            'Successfully fetched details for badge: $badgeType',
            name: 'BadgeDataSource',
          );
          return details;
        } on FormatException catch (e, stackTrace) {
          developer.log(
            'Failed to parse badge details response',
            error: e,
            stackTrace: stackTrace,
            name: 'BadgeDataSource',
          );
          throw BadgeParsingException(
            details: 'Could not parse badge details',
            originalError: e,
            stackTrace: stackTrace,
          );
        } catch (e, stackTrace) {
          developer.log(
            'Failed to decode badge details',
            error: e,
            stackTrace: stackTrace,
            name: 'BadgeDataSource',
          );
          throw BadgeParsingException(
            details: e.toString(),
            originalError: e,
            stackTrace: stackTrace,
          );
        }
      } else if (response.statusCode == 404) {
        throw BadgeNotFoundException('Badge not found: $badgeType');
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw const BadgeAuthException(
          details: 'Not authorized to access badge details',
        );
      } else if (response.statusCode >= 500) {
        throw BadgeServerException(
          details: 'Server error (${response.statusCode})',
        );
      } else {
        throw BadgeApiException(
          'Failed to fetch badge details',
          statusCode: response.statusCode,
          details: response.body,
        );
      }
    } on SocketException catch (e, stackTrace) {
      developer.log(
        'Network error fetching badge details',
        error: e,
        name: 'BadgeDataSource',
      );
      throw BadgeNetworkException(
        details: 'Please check your internet connection',
        originalError: e,
        stackTrace: stackTrace,
      );
    } on TimeoutException catch (e, stackTrace) {
      developer.log(
        'Request timeout fetching badge details',
        error: e,
        name: 'BadgeDataSource',
      );
      throw BadgeServerException(
        details: 'Request timed out',
        originalError: e,
        stackTrace: stackTrace,
      );
    } on BadgeException {
      rethrow;
    } catch (e, stackTrace) {
      developer.log(
        'Unexpected error fetching badge details',
        error: e,
        stackTrace: stackTrace,
        name: 'BadgeDataSource',
      );
      throw BadgeApiException(
        'Unexpected error fetching badge details',
        details: e.toString(),
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
}
