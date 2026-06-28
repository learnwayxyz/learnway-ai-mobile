import 'package:flutter/material.dart';
import 'package:learnwayv2/services/connectivity_service.dart';
import 'package:learnwayv2/services/screen_load_state_service.dart';
import 'package:learnwayv2/shared/widgets/no_internet_screen.dart';

/// A wrapper widget for screens that need to handle no-internet scenarios intelligently.
///
/// This widget will:
/// - Show NoInternetScreen if there's no connection AND the screen hasn't loaded data yet
/// - Show the child widget if there's connection OR if data has been loaded previously
/// - Automatically mark the screen as loaded when onDataLoaded is called
///
/// Usage:
/// ```dart
/// ScreenConnectivityWrapper(
///   routeName: '/home',
///   child: YourScreenContent(
///     onDataLoaded: () {
///       // This will be called automatically by the wrapper
///     },
///   ),
/// )
/// ```
class ScreenConnectivityWrapper extends StatefulWidget {
  const ScreenConnectivityWrapper({
    super.key,
    required this.routeName,
    required this.child,
    this.onRetry,
  });

  /// The unique route name for this screen (e.g., '/home', '/profile')
  final String routeName;

  /// The child widget to display when connection is available or data is loaded
  final Widget child;

  /// Optional callback when user taps retry on NoInternetScreen
  final VoidCallback? onRetry;

  @override
  State<ScreenConnectivityWrapper> createState() => _ScreenConnectivityWrapperState();
}

class _ScreenConnectivityWrapperState extends State<ScreenConnectivityWrapper> {
  final ConnectivityService _connectivityService = ConnectivityService();
  final ScreenLoadStateService _loadStateService = ScreenLoadStateService();

  bool _hasConnection = true;

  @override
  void initState() {
    super.initState();
    _hasConnection = _connectivityService.hasConnection;

    _connectivityService.connectionStatus.listen((hasConnection) {
      if (mounted) {
        setState(() {
          _hasConnection = hasConnection;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isRouteLoaded = _loadStateService.isRouteLoaded(widget.routeName);

    // Show NoInternetScreen only if:
    // 1. There's no internet connection AND
    // 2. This screen hasn't loaded its data yet
    if (!_hasConnection && !isRouteLoaded) {
      return NoInternetScreen(
        onRetry: () {
          if (widget.onRetry != null) {
            widget.onRetry!();
          } else {
            // Default retry: just rebuild to check connection
            setState(() {});
          }
        },
      );
    }

    // Either connection is available or data was previously loaded
    // Show the child widget
    return widget.child;
  }
}

/// Mixin for screens to easily mark themselves as loaded
///
/// Usage:
/// ```dart
/// class MyScreen extends StatefulWidget {
///   // ...
/// }
///
/// class _MyScreenState extends State<MyScreen> with ScreenLoadStateMixin {
///   @override
///   String get routeName => '/my-screen';
///
///   void _fetchData() async {
///     final data = await api.getData();
///     // Mark screen as loaded when data is fetched
///     markAsLoaded();
///   }
/// }
/// ```
mixin ScreenLoadStateMixin<T extends StatefulWidget> on State<T> {
  final ScreenLoadStateService _loadStateService = ScreenLoadStateService();

  /// Override this to provide the route name for this screen
  String get routeName;

  /// Mark this screen as having successfully loaded its data
  void markAsLoaded() {
    _loadStateService.markRouteAsLoaded(routeName);
  }

  /// Check if this screen has been loaded
  bool get isLoaded => _loadStateService.isRouteLoaded(routeName);

  /// Clear the loaded state for this screen
  void clearLoadedState() {
    _loadStateService.clearRoute(routeName);
  }
}
