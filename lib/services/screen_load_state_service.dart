import 'dart:developer' as developer;

/// Service to track which screens have successfully loaded their data.
/// This is used to determine whether to show the NoInternetScreen or
/// keep displaying previously loaded content when connection is lost.
class ScreenLoadStateService {
  static final ScreenLoadStateService _instance = ScreenLoadStateService._internal();
  factory ScreenLoadStateService() => _instance;
  ScreenLoadStateService._internal();

  /// Set of route names that have successfully loaded their data
  final Set<String> _loadedRoutes = {};

  /// Check if a route has been loaded successfully
  bool isRouteLoaded(String routeName) {
    return _loadedRoutes.contains(routeName);
  }

  /// Mark a route as successfully loaded
  void markRouteAsLoaded(String routeName) {
    _loadedRoutes.add(routeName);
    developer.log(
      'Route marked as loaded: $routeName',
      name: 'ScreenLoadStateService',
    );
  }

  /// Remove a route from loaded state (useful for refresh/logout)
  void clearRoute(String routeName) {
    _loadedRoutes.remove(routeName);
    developer.log(
      'Route cleared: $routeName',
      name: 'ScreenLoadStateService',
    );
  }

  /// Clear all loaded routes (useful for logout)
  void clearAll() {
    _loadedRoutes.clear();
    developer.log(
      'All routes cleared',
      name: 'ScreenLoadStateService',
    );
  }

  /// Get all loaded routes (for debugging)
  Set<String> get loadedRoutes => Set.unmodifiable(_loadedRoutes);
}
