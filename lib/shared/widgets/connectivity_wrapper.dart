import 'package:flutter/material.dart';
import 'package:learnwayv2/services/connectivity_service.dart';
import 'package:learnwayv2/services/notification_service.dart';

class ConnectivityWrapper extends StatefulWidget {
  const ConnectivityWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _hasConnection = true;
  bool _hasShownInitialStatus = false;

  @override
  void initState() {
    super.initState();
    _hasConnection = _connectivityService.hasConnection;

    _connectivityService.connectionStatus.listen((hasConnection) {
      if (mounted) {
        final bool wasConnected = _hasConnection;
        setState(() {
          _hasConnection = hasConnection;
        });

        // Only show notifications after initial status is set
        if (_hasShownInitialStatus) {
          if (!hasConnection && wasConnected) {
            // Connection lost - show warning snackbar
            NotificationService.showNotification(
              message: 'Please check your internet connection',
              type: NotificationType.warning,
              duration: const Duration(seconds: 3),
            );
          } else if (hasConnection && !wasConnected) {
            // Connection restored - show success snackbar
            NotificationService.showNotification(
              message: 'Internet connection restored',
              type: NotificationType.success,
              duration: const Duration(seconds: 2),
            );
          }
        } else {
          _hasShownInitialStatus = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Always show the child widget, snackbars will handle notifications
    return widget.child;
  }
}
