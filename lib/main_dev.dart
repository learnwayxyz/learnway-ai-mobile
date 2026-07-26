import 'dart:async';
import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:learnwayv2/app/app.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/bootstrap.dart';
import 'package:learnwayv2/main_common.dart';
import 'package:learnwayv2/services/notification_service/fcm_service.dart';
import 'package:learnwayv2/services/notification_service/local_notification_service.dart';
import 'package:sentry/sentry.dart';
import 'firebase_options_dev.dart' as firebase_dev;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'GlobalNavigator',
);

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      Bloc.observer = const AppBlocObserver();
      unawaited(MobileAds.instance.initialize());

      Env.setFlavor(Flavor.dev);

      await Sentry.init((options) {
        options.dsn = Env.sentryDsn;
        options.environment = 'development';
        options.tracesSampleRate = 1.0;
      });

      FlutterError.onError = (details) {
        Sentry.captureException(
          details.exception,
          stackTrace: details.stack,
          hint: Hint.withMap({'source': 'FlutterError.onError'}),
        );
      };

      await Firebase.initializeApp(
        name: 'dev',
        options: firebase_dev.DefaultFirebaseOptions.currentPlatform,
      );
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

      await LocalNotificationService().initialize();

      await mainCommon();

      runApp(const App());

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          await FCMService.instance.initialize();
          await FCMService.instance.handlePendingNotification();
        } catch (e, st) {
          log(
            'FCM post-frame init failed: $e',
            name: 'LearnWay',
            stackTrace: st,
          );
        }
      });
    },
    (exception, stackTrace) async {
      await Sentry.captureException(exception, stackTrace: stackTrace);
    },
  );
}
