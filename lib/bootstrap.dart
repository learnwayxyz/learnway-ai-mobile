import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry/sentry.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    Sentry.captureException(
      error,
      stackTrace: stackTrace,
      hint: Hint.withMap({'bloc': bloc.runtimeType.toString()}),
    );
    super.onError(bloc, error, stackTrace);
  }
}
