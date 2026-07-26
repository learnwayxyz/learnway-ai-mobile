import 'dart:async';
import 'dart:developer' as developer;

import 'package:sentry/sentry.dart';

/// Reports a repository-layer failure to the local log and to Sentry.
///
/// `dart:developer` output only reaches the VM service, so it is invisible in
/// release builds. Sentry is the only channel that surfaces these failures from
/// a shipped app.
///
/// Set [expected] for domain failures the API told us about (a non-2xx with a
/// message); those report at warning level so they can be filtered apart from
/// unexpected errors.
void reportRepositoryFailure(
  String operation,
  Object error,
  StackTrace? stackTrace, {
  bool expected = false,
}) {
  developer.log('$operation failed: $error', stackTrace: stackTrace);
  unawaited(
    Sentry.captureException(
      error,
      stackTrace: stackTrace,
      withScope: (scope) {
        scope
          ..setTag('layer', 'repository')
          ..setTag('operation', operation)
          ..level = expected ? SentryLevel.warning : SentryLevel.error;
      },
    ),
  );
}
