import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:sentry/sentry.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class WebsocketService {
  io.Socket? _socket;
  bool _isConnected = false;
  final Map<String, Function(dynamic)> _eventHandlers = {};
  Function()? _onConnectCallback;

  bool get isConnected => _isConnected;

  void setOnConnectCallback(Function() callback) {
    _onConnectCallback = callback;
  }

  void connect(String baseUrl, {String? authToken}) {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }

    final options = io.OptionBuilder()
        .setTransports(['websocket', 'polling'])
        .disableAutoConnect()
        .enableForceNew();

    if (authToken?.isNotEmpty == true) {
      options.setExtraHeaders({'Authorization': 'Bearer $authToken'});
      options.setAuth({'token': authToken});
    }

    _socket = io.io(baseUrl, options.build());
    _setupSocketListeners();
    _socket!.connect();
  }

  void _setupSocketListeners() {
    _socket!.onConnect((_) {
      _isConnected = true;
      log('[WS] Connected successfully');
      Sentry.addBreadcrumb(Breadcrumb(
        message: '[WS] Connected successfully',
        category: 'websocket',
        level: SentryLevel.info,
      ));
      _eventHandlers.forEach((event, handler) {
        _socket!.off(event);
        _socket!.on(event, handler);
        log('[WS] Re-registered listener for: $event');
      });

      _onConnectCallback?.call();
    });

    _socket!.onAny((event, data) {
      log('[WS] RAW EVENT: $event — $data');
      Sentry.addBreadcrumb(Breadcrumb(
        message: '[WS] RAW EVENT: $event',
        category: 'websocket.event',
        level: SentryLevel.debug,
        data: {'event': event, 'data': data?.toString()},
      ));
    });

    _socket!.onDisconnect((_) {
      _isConnected = false;
      log('[WS] Disconnected');
      Sentry.addBreadcrumb(Breadcrumb(
        message: '[WS] Disconnected',
        category: 'websocket',
        level: SentryLevel.warning,
      ));
    });

    _socket!.onConnectError((error) {
      log('[WS] Connection error: $error');
      Sentry.addBreadcrumb(Breadcrumb(
        message: '[WS] Connection error',
        category: 'websocket',
        level: SentryLevel.error,
        data: {'error': error?.toString()},
      ));
      Sentry.captureException(
        Exception('[WS] Connection error: $error'),
        hint: Hint.withMap({'source': 'WebsocketService.onConnectError'}),
      );
    });

    _socket!.onError((error) {
      log('[WS] Error: $error');
      Sentry.addBreadcrumb(Breadcrumb(
        message: '[WS] Socket error',
        category: 'websocket',
        level: SentryLevel.error,
        data: {'error': error?.toString()},
      ));
      Sentry.captureException(
        Exception('[WS] Socket error: $error'),
        hint: Hint.withMap({'source': 'WebsocketService.onError'}),
      );
    });
  }

  void onEvent(String event, Function(dynamic) handler) {
    _socket?.off(event);
    _eventHandlers[event] = handler;
    if (_socket != null && _isConnected) {
      _socket!.on(event, handler);
      log('[WS] Listener registered immediately for: $event');
    } else {
      log('[WS] Queued listener for: $event (will bind on connect)');
    }
  }

  void emit(String event, dynamic data) {
    if (_socket != null && _isConnected) {
      _socket!.emit(event, data);
      log('[WS] Emitted: $event — $data');
      Sentry.addBreadcrumb(Breadcrumb(
        message: '[WS] Emitted: $event',
        category: 'websocket.emit',
        level: SentryLevel.info,
        data: {'event': event, 'data': data?.toString()},
      ));
    } else {
      log('[WS] Not connected — cannot emit: $event');
      Sentry.addBreadcrumb(Breadcrumb(
        message: '[WS] Emit failed — not connected: $event',
        category: 'websocket.emit',
        level: SentryLevel.warning,
        data: {'event': event},
      ));
    }
  }

  void off(String event) {
    _socket?.off(event);
    _eventHandlers.remove(event);
  }

  void disconnect() {
    _socket?.disconnect();
    _eventHandlers.clear();
    _isConnected = false;
  }

  void dispose() {
    disconnect();
    _socket?.dispose();
    _socket = null;
  }
}
