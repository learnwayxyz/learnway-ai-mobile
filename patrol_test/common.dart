import 'package:core/core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/app/app.dart';
import 'package:learnwayv2/bootstrap.dart';
import 'package:learnwayv2/firebase_options_dev.dart' as firebase_dev;
import 'package:learnwayv2/main_common.dart';
import 'package:patrol/patrol.dart';

bool _initialized = false;

/// Boots the dev flavor the same way `main_dev.dart` does, minus Sentry,
/// FCM and notification permission prompts, which would make tests flaky.
Future<void> initApp() async {
  if (_initialized) return;
  Bloc.observer = const AppBlocObserver();
  Env.setFlavor(Flavor.dev);
  await Firebase.initializeApp(
    name: 'dev',
    options: firebase_dev.DefaultFirebaseOptions.currentPlatform,
  );
  await mainCommon();
  _initialized = true;
}

/// Starts the app and waits until [firstScreen] is visible.
///
/// While waiting it accepts any native permission prompt, such as the iOS App
/// Tracking Transparency dialog that the splash screen requests on a fresh
/// install, so it can't cover the app.
Future<void> launchApp(
  PatrolIntegrationTester $, {
  required PatrolFinder firstScreen,
  Duration timeout = const Duration(seconds: 45),
}) async {
  await initApp();
  await $.pumpWidget(const App());

  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    if (await $.platform.mobile.isPermissionDialogVisible()) {
      await $.platform.mobile.grantPermissionWhenInUse();
    }
    await $.pump(const Duration(milliseconds: 500));
    if (firstScreen.hitTestable().evaluate().isNotEmpty) return;
  }
  await firstScreen.waitUntilVisible(timeout: Duration.zero);
}
