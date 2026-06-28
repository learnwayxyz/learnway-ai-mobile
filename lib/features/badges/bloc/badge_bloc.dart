import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/features/badges/bloc/badge_event.dart';
import 'package:learnwayv2/features/badges/bloc/badge_state.dart';
import 'package:learnwayv2/features/badges/models/badge_catalog_model.dart';
import 'package:learnwayv2/features/badges/models/badge_model.dart';
import 'package:learnwayv2/features/badges/models/badge_tier_item.dart';
import 'package:learnwayv2/features/badges/repository/badge_repository.dart';

class BadgeBloc extends Bloc<BadgeEvent, BadgeState> {
  final BadgeRepository _repository;

  static final Map<String, BadgeLoaded> _cacheByUser = {};

  static String? _currentUserId;

  BadgeBloc({BadgeRepository? repository})
    : _repository = repository ?? BadgeRepository(),
      super(BadgeInitial()) {
    on<LoadUserBadges>(_onLoadUserBadges);
    on<RefreshBadges>(_onRefreshBadges);
    on<ClearCache>(_onClearCache);
  }

  static void clearCache({String? userId}) {
    if (userId != null) {
      _cacheByUser.remove(userId);
      developer.log('Cleared badge cache for user: $userId', name: 'BadgeBloc');
    } else {
      _cacheByUser.clear();
      developer.log('Cleared all badge caches', name: 'BadgeBloc');
    }
  }

  Future<void> _onClearCache(ClearCache event, Emitter<BadgeState> emit) async {
    developer.log(
      'ClearCache event received for userId: ${event.userId}',
      name: 'BadgeBloc',
    );

    clearCache(userId: event.userId);

    _currentUserId = null;

    emit(BadgeInitial());
  }

  Map<String, List<BadgeTierItem>> _expandBadgesByCategory(
    Map<String, List<BadgeCatalogItem>> catalogByCategory,
  ) {
    developer.log('Expanding badges by category', name: 'BadgeBloc');
    final Map<String, List<BadgeTierItem>> expandedByCategory = {};

    for (final entry in catalogByCategory.entries) {
      final category = entry.key;
      final catalogItems = entry.value;

      final expandedItems = BadgeTierItem.expandBadges(catalogItems);
      expandedByCategory[category] = expandedItems;

      developer.log(
        'Category "$category": ${catalogItems.length} items -> ${expandedItems.length} display items',
        name: 'BadgeBloc',
      );
    }

    return expandedByCategory;
  }

  Future<void> _onLoadUserBadges(
    LoadUserBadges event,
    Emitter<BadgeState> emit,
  ) async {
    final bool userChanged =
        _currentUserId != null && _currentUserId != event.userId;

    if (userChanged) {
      clearCache(userId: _currentUserId);
    }

    _currentUserId = event.userId;

    final cachedData = !userChanged ? _cacheByUser[event.userId] : null;

    if (cachedData != null) {
      emit(cachedData);

      try {
        final results = await Future.wait([
          _repository.getBadgeCatalog(event.userId),
          _repository.getEarnedBadges(event.userId),
        ]);

        final catalog = results[0] as BadgeCatalogResponse;
        final earnedBadges = results[1] as List<BadgeModel>;

        final expandedBadges = _expandBadgesByCategory(catalog.categories);

        final newData = BadgeLoaded(
          badgesByCategory: expandedBadges,
          earnedBadges: earnedBadges,
          totalBadges: catalog.totalBadges,
          totalEarned: catalog.userBadgeStats.totalEarned,
          totalGems: catalog.userBadgeStats.totalGems,
          totalBadgeImages: expandedBadges.values
              .expand((e) => expandedBadges.values)
              .toList()
              .length,
          completionPercentage: catalog.userBadgeStats.completionPercentage,
        );

        _cacheByUser[event.userId] = newData;
        emit(newData);
        developer.log(
          'Background refresh completed for user: ${event.userId}, earned: ${earnedBadges.length}',
          name: 'BadgeBloc',
        );
      } catch (e, stackTrace) {
        developer.log(
          'Background refresh failed for user: ${event.userId}',
          error: e,
          stackTrace: stackTrace,
          name: 'BadgeBloc',
        );
      }
      return;
    }

    developer.log(
      'No cached data, loading badges for user: ${event.userId}',
      name: 'BadgeBloc',
    );
    emit(BadgeLoading());

    try {
      final results = await Future.wait([
        _repository.getBadgeCatalog(event.userId),
        _repository.getEarnedBadges(event.userId),
      ]);

      final catalog = results[0] as BadgeCatalogResponse;
      final earnedBadges = results[1] as List<BadgeModel>;

      final expandedBadges = _expandBadgesByCategory(catalog.categories);

      final loadedData = BadgeLoaded(
        badgesByCategory: expandedBadges,
        earnedBadges: earnedBadges,
        totalBadges: catalog.totalBadges,
        totalEarned: catalog.userBadgeStats.totalEarned,
        totalGems: catalog.userBadgeStats.totalGems,
        completionPercentage: catalog.userBadgeStats.completionPercentage,
      );

      _cacheByUser[event.userId] = loadedData;
      emit(loadedData);
      developer.log(
        'Badges loaded successfully for user: ${event.userId}, earned: ${earnedBadges.length}',
        name: 'BadgeBloc',
      );
    } catch (e, stackTrace) {
      developer.log(
        'Failed to load badges for user: ${event.userId}',
        error: e,
        stackTrace: stackTrace,
        name: 'BadgeBloc',
      );
      emit(BadgeError(e.toString()));
    }
  }

  Future<void> _onRefreshBadges(
    RefreshBadges event,
    Emitter<BadgeState> emit,
  ) async {
    developer.log(
      'Manually refreshing badges for user: ${event.userId}',
      name: 'BadgeBloc',
    );

    try {
      final results = await Future.wait([
        _repository.getBadgeCatalog(event.userId),
        _repository.getEarnedBadges(event.userId),
      ]);

      final catalog = results[0] as BadgeCatalogResponse;
      final earnedBadges = results[1] as List<BadgeModel>;

      final expandedBadges = _expandBadgesByCategory(catalog.categories);

      final loadedData = BadgeLoaded(
        badgesByCategory: expandedBadges,
        earnedBadges: earnedBadges,
        totalBadges: catalog.totalBadges,
        totalEarned: catalog.userBadgeStats.totalEarned,
        totalGems: catalog.userBadgeStats.totalGems,
        completionPercentage: catalog.userBadgeStats.completionPercentage,
      );

      _cacheByUser[event.userId] = loadedData;
      emit(loadedData);
      developer.log(
        'Manual refresh completed for user: ${event.userId}, earned: ${earnedBadges.length}',
        name: 'BadgeBloc',
      );
    } catch (e, stackTrace) {
      developer.log(
        'Manual refresh failed for user: ${event.userId}',
        error: e,
        stackTrace: stackTrace,
        name: 'BadgeBloc',
      );
      emit(BadgeError(e.toString()));
    }
  }
}
