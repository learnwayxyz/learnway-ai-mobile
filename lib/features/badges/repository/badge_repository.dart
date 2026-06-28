import 'package:learnwayv2/features/badges/data/badge_data_source.dart';
import 'package:learnwayv2/features/badges/models/badge_model.dart';
import 'package:learnwayv2/features/badges/models/badge_catalog_model.dart';

class BadgeRepository {
  final BadgeDataSource _dataSource;

  BadgeRepository({BadgeDataSource? dataSource})
      : _dataSource = dataSource ?? BadgeDataSource();

  /// Get all badges for a user
  Future<List<BadgeModel>> getUserBadges(String userId) async {
    try {
      return await _dataSource.getUserBadges(userId);
    } catch (e) {
      rethrow;
    }
  }

  /// Get user badge showcase with categories
  Future<Map<String, dynamic>> getUserBadgeShowcase(String userId) async {
    try {
      return await _dataSource.getUserBadgeShowcase(userId);
    } catch (e) {
      rethrow;
    }
  }

  /// Get earned badges only
  Future<List<BadgeModel>> getEarnedBadges(String userId) async {
    try {
      final badges = await _dataSource.getUserBadges(userId);
      return badges.where((badge) => badge.isEarned).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get badges grouped by category
  Future<Map<String, List<BadgeModel>>> getBadgesByCategory(
    String userId,
  ) async {
    try {
      final badges = await _dataSource.getUserBadges(userId);
      final Map<String, List<BadgeModel>> categorizedBadges = {};

      for (final badge in badges) {
        final category = badge.category ?? 'Other';
        if (!categorizedBadges.containsKey(category)) {
          categorizedBadges[category] = [];
        }
        categorizedBadges[category]!.add(badge);
      }

      return categorizedBadges;
    } catch (e) {
      rethrow;
    }
  }

  /// Get badge catalog with all badges and user progress
  Future<BadgeCatalogResponse> getBadgeCatalog(String userId) async {
    try {
      return await _dataSource.getBadgeCatalog(userId);
    } catch (e) {
      rethrow;
    }
  }

  /// Get details for a specific badge
  Future<BadgeDetailsModel> getBadgeDetails(String badgeType) async {
    try {
      return await _dataSource.getBadgeDetails(badgeType);
    } catch (e) {
      rethrow;
    }
  }
}
