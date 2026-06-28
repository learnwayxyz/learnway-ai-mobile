import 'dart:developer';
import 'dart:io';

import 'package:learnwayv2/services/defi_service/defi_service_exception.dart';

Future<T> safeApiCall<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on SocketException catch (e) {
    throw OnRampFailure.network(e.message);
  } on HttpException catch (e) {
    throw OnRampFailure.server(e.message);
  } on OnRampFailure catch (e) {
    log('Rethrowing OnRampFailure  ${e.message}');
    rethrow;
  } catch (e) {
    log('Unknown error  ${e.toString()}');
    throw OnRampFailure.unknown(e.toString());
  }
}
