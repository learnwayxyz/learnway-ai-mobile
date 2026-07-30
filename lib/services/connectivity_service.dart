import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  /// How long the connection must stay down before it is reported as offline.
  ///
  /// The underlying checker polls by pinging hosts, so a wifi/cellular handoff,
  /// a lift, or one slow DNS response all register as a drop. Those recover
  /// well inside this window and never reach the UI. Reconnects are not
  /// debounced — they are published immediately so pending retries can fire.
  static const Duration _offlineGracePeriod = Duration(seconds: 3);

  late InternetConnectionChecker _connectionChecker;
  final StreamController<bool> _connectionStatusController =
      StreamController<bool>.broadcast();
  final ValueNotifier<bool> _connectionNotifier = ValueNotifier<bool>(true);
  StreamSubscription<InternetConnectionStatus>? _subscription;
  Timer? _offlineTimer;

  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  /// Debounced connection state, readable synchronously during build.
  ValueListenable<bool> get connectionListenable => _connectionNotifier;

  bool _hasConnection = true;

  bool get hasConnection => _hasConnection;

  Future<void> initialize() async {
    try {
      _connectionChecker = InternetConnectionChecker.instance;

      // Check initial connection status
      _hasConnection = await _connectionChecker.hasConnection;
      _connectionNotifier.value = _hasConnection;
      _connectionStatusController.add(_hasConnection);

      developer.log(
        'Initial connection status: ${_hasConnection ? "Connected" : "Disconnected"}',
        name: 'ConnectivityService',
      );

      // Listen to connection changes
      _subscription = _connectionChecker.onStatusChange.listen((status) {
        _updateConnectionStatus(status);
      });
    } catch (e) {
      developer.log(
        'Error initializing connectivity service: $e',
        name: 'ConnectivityService',
      );
    }
  }

  void _updateConnectionStatus(InternetConnectionStatus status) {
    final isConnected = status == InternetConnectionStatus.connected;

    if (isConnected) {
      _offlineTimer?.cancel();
      _offlineTimer = null;
      _publish(true);
      return;
    }

    // Already reported offline, or already waiting out the grace period.
    if (!_hasConnection || _offlineTimer != null) return;

    _offlineTimer = Timer(_offlineGracePeriod, () async {
      _offlineTimer = null;
      try {
        // Re-verify before surfacing: the checker's poll interval can lag an
        // actual recovery, so the cached status may already be stale.
        if (!await _connectionChecker.hasConnection) {
          _publish(false);
        }
      } catch (e) {
        developer.log(
          'Error confirming offline status: $e',
          name: 'ConnectivityService',
        );
      }
    });
  }

  void _publish(bool hasConnection) {
    if (_hasConnection == hasConnection) return;

    _hasConnection = hasConnection;
    _connectionNotifier.value = hasConnection;
    _connectionStatusController.add(hasConnection);

    developer.log(
      'Connection status changed: ${hasConnection ? "Connected" : "Disconnected"}',
      name: 'ConnectivityService',
    );
  }

  void dispose() {
    _offlineTimer?.cancel();
    _subscription?.cancel();
    _connectionNotifier.dispose();
    _connectionStatusController.close();
  }
}
