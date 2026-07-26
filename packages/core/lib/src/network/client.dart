import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../storage/shared_pref_keys.dart';
import '../storage/shared_preferences_store.dart';
import 'custom_client.dart';
import 'data_layer_exception.dart';

class BaseApiClients {
  BaseApiClients({required this.baseUrl, Map<String, String>? headers})
    : _headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        ...?headers,
      };

  final String baseUrl;
  final Map<String, String> _headers;
  final customClient = CustomClient();

  Future<Map<String, String>> _getHeadersWithAuth([
    Map<String, String>? additionalHeaders,
  ]) async {
    final headers = <String, String>{..._headers, ...?additionalHeaders};

    try {
      final token = await SharedPreferencesStore.getUserToken(userTokenKey);
      log('Retrieved token: ${token ?? 'null'}');
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      } else {
        log('No token found in SharedPreferences', name: 'BaseApiClients');
      }
    } catch (e) {
      log('Error getting JWT token: $e', name: 'BaseApiClients');
    }

    return headers;
  }

  Future<http.Response> get(
    String endPoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(endPoint, queryParameters: queryParameters);
      final authHeaders = await _getHeadersWithAuth(headers);
      final response = await customClient
          .get(uri, headers: authHeaders)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Request timed out'),
          );

      return response;
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw NetworkException('Request timed out');
    } on NetworkException {
      rethrow;
    } catch (e) {
      log('Network error in GET request: $e');
      throw NetworkException('Network error occurred');
    }
  }

  Future<http.Response> post(
    String endPoint, {
    required Map<String, dynamic> body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    try {
      final uri = _buildUri(endPoint, queryParameters: queryParameters);
      final encodedBody = json.encode(body);
      final requestHeaders = await _getHeadersWithAuth(headers);

      final response = await customClient
          .post(uri, headers: requestHeaders, body: encodedBody)
          .timeout(
            timeout ?? const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Request timed out'),
          );

      return response;
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw NetworkException('Request timed out');
    } on NetworkException {
      rethrow;
    } catch (e) {
      log('Network error in POST request: $e');
      throw NetworkException('Network error occurred');
    }
  }

  Future<http.Response> postMultipart(
    String endPoint, {
    required Map<String, String> fields,
    Map<String, File>? files,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(endPoint, queryParameters: queryParameters);
      final request = http.MultipartRequest('POST', uri);

      final authHeaders = await _getHeadersWithAuth(headers);
      authHeaders.remove('Content-Type');
      request.headers.addAll(authHeaders);
      request.fields.addAll(fields);
      if (files != null) {
        for (final entry in files.entries) {
          final file = entry.value;
          final fieldName = entry.key;

          log('Adding file: $fieldName with path: ${file.path}');

          final multipartFile = await http.MultipartFile.fromPath(
            fieldName,
            file.path,
            filename: file.path.split('/').last,
          );
          request.files.add(multipartFile);
        }
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('Multipart request timed out'),
      );

      return await http.Response.fromStream(streamedResponse);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw NetworkException('Request timed out');
    } on NetworkException {
      rethrow;
    } catch (e) {
      log('Network error in multipart POST request: $e');
      throw NetworkException('Network error occurred');
    }
  }

  Future<http.Response> patchMultipart(
    String endPoint, {
    required Map<String, String> fields,
    Map<String, File>? files,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(endPoint, queryParameters: queryParameters);
      final request = http.MultipartRequest('PATCH', uri);

      final authHeaders = await _getHeadersWithAuth(headers);
      authHeaders.remove('Content-Type');
      request.headers.addAll(authHeaders);
      request.fields.addAll(fields);
      if (files != null) {
        for (final entry in files.entries) {
          final file = entry.value;
          final fieldName = entry.key;

          log('Adding file: $fieldName with path: ${file.path}');

          final multipartFile = await http.MultipartFile.fromPath(
            fieldName,
            file.path,
            filename: file.path.split('/').last,
          );
          request.files.add(multipartFile);
        }
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('Multipart request timed out'),
      );

      return await http.Response.fromStream(streamedResponse);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw NetworkException('Request timed out');
    } on NetworkException {
      rethrow;
    } catch (e) {
      log('Network error in multipart PATCH request: $e');
      throw NetworkException('Network error occurred');
    }
  }

  Future<http.Response> postMultipartWithBytes(
    String endPoint, {
    required Map<String, String> fields,
    required Map<String, List<int>> fileBytes,
    required Map<String, String> fileNames,
    Map<String, String>? mimeTypes,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(endPoint, queryParameters: queryParameters);
      final request = http.MultipartRequest('POST', uri);

      log('Multipart POST (Bytes) → $uri');

      final cleanedFields = Map<String, String>.from(fields)
        ..removeWhere((_, value) => value.trim().isEmpty);
      log('Fields: $cleanedFields');
      request.fields.addAll(cleanedFields);

      final authHeaders = await _getHeadersWithAuth(headers);
      authHeaders.remove('Content-Type');
      request.headers.addAll(authHeaders);

      for (final entry in fileBytes.entries) {
        final fieldName = entry.key;
        final bytes = entry.value;
        final fileName = fileNames[fieldName] ?? 'file.jpg';
        final extension = fileName.split('.').last.toLowerCase();

        final mimeType =
            mimeTypes?[fieldName] ??
            (extension == 'png'
                ? 'image/png'
                : extension == 'jpg' || extension == 'jpeg'
                ? 'image/jpeg'
                : 'application/octet-stream');

        log(
          'Attaching file → field: $fieldName, name: $fileName, type: $mimeType, size: ${bytes.length} bytes',
        );

        request.files.add(
          http.MultipartFile.fromBytes(
            fieldName,
            bytes,
            filename: fileName,
            contentType: MediaType.parse(mimeType),
          ),
        );
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('Multipart request timed out'),
      );

      return await http.Response.fromStream(streamedResponse);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw NetworkException('Request timed out');
    } on NetworkException {
      rethrow;
    } catch (e) {
      log('Network error in multipart POST with bytes: $e');
      throw NetworkException('Network error occurred');
    }
  }

  Future<http.Response> patchMultipartWithBytes(
    String endPoint, {
    required Map<String, List<int>> fileBytes,
    required Map<String, String> fileNames,
    Map<String, String>? fields,
    Map<String, String>? mimeTypes,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(endPoint, queryParameters: queryParameters);
      final request = http.MultipartRequest('PATCH', uri);

      log('Multipart PATCH (Bytes) → $uri');

      if (fields != null) {
        final cleanedFields = Map<String, String>.from(fields)
          ..removeWhere((_, value) => value.trim().isEmpty);
        log('Fields: $cleanedFields');
        request.fields.addAll(cleanedFields);
      } else {
        log('Fields: none');
      }

      final authHeaders = await _getHeadersWithAuth(headers);
      authHeaders.remove('Content-Type');
      request.headers.addAll(authHeaders);

      for (final entry in fileBytes.entries) {
        final fieldName = entry.key;
        final bytes = entry.value;
        final fileName = fileNames[fieldName] ?? 'file.jpg';
        final extension = fileName.split('.').last.toLowerCase();

        final mimeType =
            mimeTypes?[fieldName] ??
            (extension == 'png'
                ? 'image/png'
                : extension == 'jpg' || extension == 'jpeg'
                ? 'image/jpeg'
                : 'application/octet-stream');

        log(
          'Attaching file → field: $fieldName, name: $fileName, type: $mimeType, size: ${bytes.length} bytes',
        );

        request.files.add(
          http.MultipartFile.fromBytes(
            fieldName,
            bytes,
            filename: fileName,
            contentType: MediaType.parse(mimeType),
          ),
        );
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('Multipart request timed out'),
      );

      return await http.Response.fromStream(streamedResponse);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw NetworkException('Request timed out');
    } on NetworkException {
      rethrow;
    } catch (e) {
      log('Network error in multipart PATCH with bytes: $e');
      throw NetworkException('Network error occurred');
    }
  }

  Future<http.Response> put(
    String endPoint, {
    required Map<String, dynamic> body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(endPoint, queryParameters: queryParameters);
      final encodedBody = json.encode(body);
      final authHeaders = await _getHeadersWithAuth(headers);

      final response = await customClient
          .put(uri, headers: authHeaders, body: encodedBody)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Request timed out'),
          );

      return response;
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw NetworkException('Request timed out');
    } on NetworkException {
      rethrow;
    } catch (e) {
      log('Network error in PUT request: $e');
      throw NetworkException('Network error occurred');
    }
  }

  Future<http.Response> patch(
    String endPoint, {
    required Map<String, dynamic> body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final encodedBody = json.encode(body);
      final uri = _buildUri(endPoint, queryParameters: queryParameters);
      final authHeaders = await _getHeadersWithAuth(headers);
      final response = await customClient
          .patch(uri, headers: authHeaders, body: encodedBody)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Request timed out'),
          );
      return response;
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw NetworkException('Request timed out');
    } on NetworkException {
      rethrow;
    } catch (e) {
      log('Network error in PATCH request: $e');
      throw NetworkException('Network error occurred');
    }
  }

  Future<http.Response> delete(
    String endPoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(endPoint, queryParameters: queryParameters);
      final authHeaders = await _getHeadersWithAuth(headers);
      final response = await customClient
          .delete(uri, headers: authHeaders)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Request timed out'),
          );
      return response;
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw NetworkException('Request timed out');
    } on NetworkException {
      rethrow;
    } catch (e) {
      log('Network error in DELETE request: $e');
      throw NetworkException('Network error occurred');
    }
  }

  Uri _buildUri(String endPoint, {Map<String, dynamic>? queryParameters}) {
    final fullUrl = baseUrl.endsWith('/') || endPoint.startsWith('/')
        ? '$baseUrl$endPoint'
        : '$baseUrl/$endPoint';

    log(
      'logging: ${Uri.parse(fullUrl).replace(queryParameters: queryParameters)}',
    );
    return Uri.parse(fullUrl).replace(queryParameters: queryParameters);
  }
}
