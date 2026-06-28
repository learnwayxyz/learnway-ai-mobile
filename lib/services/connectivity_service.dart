import 'dart:async';
import 'dart:developer' as developer;
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  late InternetConnectionChecker _connectionChecker;
  final StreamController<bool> _connectionStatusController = StreamController<bool>.broadcast();
  StreamSubscription<InternetConnectionStatus>? _subscription;

  Stream<bool> get connectionStatus => _connectionStatusController.stream;
  bool _hasConnection = true;

  bool get hasConnection => _hasConnection;

  Future<void> initialize() async {
    try {
      _connectionChecker = InternetConnectionChecker.instance;

      // Check initial connection status
      _hasConnection = await _connectionChecker.hasConnection;
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
      developer.log('Error initializing connectivity service: $e', name: 'ConnectivityService');
    }
  }

  void _updateConnectionStatus(InternetConnectionStatus status) {
    final hasConnection = status == InternetConnectionStatus.connected;

    if (_hasConnection != hasConnection) {
      _hasConnection = hasConnection;
      _connectionStatusController.add(hasConnection);

      developer.log(
        'Connection status changed: ${hasConnection ? "Connected" : "Disconnected"}',
        name: 'ConnectivityService',
      );
    }
  }

  void dispose() {
    _subscription?.cancel();
    _connectionStatusController.close();
  }
}
