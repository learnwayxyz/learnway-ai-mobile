import 'dart:convert';
import 'dart:developer';
import 'package:core/core.dart';
import 'package:learnwayv2/core/di/locator.dart';

class ReferralDataSource {
  /// Generate referral code for user
  Future<Map<String, dynamic>> generateReferralCode() async {
    try {
      final baseApi = locator<BaseApiClients>();
      final response = await baseApi.post(
        Endpoints.generateReferralCode,
        body: {},
      );
      return jsonDecode(response.body);
    } catch (e) {
      log('Error generating referral code: $e', name: 'ReferralDataSource');
      rethrow;
    }
  }

  /// Process referral bonus for new user
  Future<Map<String, dynamic>> processReferral(String referralCode) async {
    final baseApi = locator<BaseApiClients>();
    final response = await baseApi.post(
      '${Endpoints.processReferral}/$referralCode',
      body: {},
    );
    log('processReferral response [${response.statusCode}]: ${response.body}');
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200 || response.statusCode == 201) {
      return body;
    } else {
      final message = body['message'] ?? 'Unknown error';
      throw Exception(message);
    }
  }

  /// Get user referral statistics
  Future<Map<String, dynamic>> getReferralStats() async {
    try {
      final baseApi = locator<BaseApiClients>();
      final response = await baseApi.get(Endpoints.referralStats);
      log('getReferralStats() [${response.statusCode}]: ${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      log('Error getting referral stats: $e', name: 'ReferralDataSource');
      rethrow;
    }
  }

  /// Generate shareable referral link
  Future<Map<String, dynamic>> generateShareLink() async {
    try {
      final baseApi = locator<BaseApiClients>();
      final response = await baseApi.post(
        Endpoints.generateShareLink,
        body: {},
      );
      return jsonDecode(response.body);
    } catch (e) {
      rethrow;
    }
  }
}
