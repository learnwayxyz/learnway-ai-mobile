import 'dart:developer';

import 'package:http/http.dart' as http;

class CustomClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    try {
      final http.StreamedResponse streamResponse = await _inner.send(request);
      final http.Response response = await http.Response.fromStream(
        streamResponse,
      );

      log('Maintaince body ${response.body.contains('maintenance')}');

      return http.StreamedResponse(
        Stream.value(response.bodyBytes),
        response.statusCode,
        request: response.request,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}
