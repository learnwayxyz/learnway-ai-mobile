import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';

class VerificationManager {
  static final VerificationManager _instance = VerificationManager._internal();
  factory VerificationManager() => _instance;
  VerificationManager._internal();

  final _appLinks = AppLinks();
  StreamSubscription? _linkSubscription;
  Function(Uri)? _onDeepLinkReceived;

  void initDeepLinks({required Function(Uri) onDeepLinkReceived}) {
    _onDeepLinkReceived = onDeepLinkReceived;

    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        debugPrint('Deep link received (app open): $uri');
        _onDeepLinkReceived?.call(uri);
      },
      onError: (err) {
        debugPrint('Deep link error: $err');
      },
    );

    _appLinks.getInitialLink().then((uri) {
      if (uri != null) {
        debugPrint('Deep link received (app launch): $uri');
        _onDeepLinkReceived?.call(uri);
      }
    });
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
