import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/core/di/locator.dart';

import 'package:learnwayv2/services/kyc_service/kyc_exception.dart';
import 'package:learnwayv2/services/kyc_service/model/session_decision.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:core/src/config/env/env.dart';

abstract class VerificationService {
  Future<Map<String, dynamic>> createSession({
    required String callbackUrl,
    Map<String, dynamic>? metadata,
  });

  Future<SessionDecision> getSessionDecision(String sessionId);

  Future<void> updateBackendKycStatus({
    required String sessionId,
    required SessionDecision decision,
  });

  Future<Map<String, dynamic>> getKycStatus();
}

class KycServiceImpl implements VerificationService {
  final BaseApiClients client;

  KycServiceImpl(this.client);

  @override
  Future<Map<String, dynamic>> createSession({
    required String callbackUrl,
    Map<String, dynamic>? metadata,
  }) async {
    final userData = LocalStorageService.getUserSync();
    try {
      final response = await client.post(
        '/v2/session/',
        body: {
          'workflow_id': Env.workFlowId,
          'vendor_data': userData?.id,
          'callback': callbackUrl,
          'metadata': metadata,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        log('Session created: $data');
        return {
          'session_id': data['session_id'],
          'session_token': data['session_token'],
          'url': data['url'],
          'status': data['status'],
        };
      } else {
        throw Exception('Failed to create session: ${response.body}');
      }
    } on SocketException catch (e) {
      throw KycException('Network error: $e');
    } on HttpException catch (e) {
      throw KycException('HTTP error creating session: $e');
    } catch (e) {
      throw KycException('Error creating session: $e');
    }
  }

  @override
  Future<SessionDecision> getSessionDecision(String sessionId) async {
    log('Getting session decision for: $sessionId');
    try {
      final response = await client.get('/v2/session/$sessionId/decision/');

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final decision = SessionDecision.fromJson(data);
        log('Session decision status: ${decision.status.name}');
        return decision;
      } else {
        throw Exception('Failed to get session decision: ${response.body}');
      }
    } on SocketException catch (e) {
      throw KycException('Network error: $e');
    } on HttpException catch (e) {
      throw KycException('HTTP error getting session decision: $e');
    } catch (e) {
      throw KycException('Something went wrong fetching session decision');
    }
  }

  @override
  Future<void> updateBackendKycStatus({
    required String sessionId,
    required SessionDecision decision,
  }) async {
    if (!decision.status.shouldUpdateBackend) {
      log(
        'Skipping backend KYC update — status "${decision.status.name}" does not warrant an update',
      );
      return;
    }

    try {
      final learnwayClient = locator<BaseApiClients>();
      final userToken = await SharedPreferencesStore.getUserToken(userTokenKey);

      if (userToken == null || userToken.isEmpty) {
        throw KycException('User token not found');
      }

      log(
        'Updating backend KYC status for sessionId: $sessionId, status: ${decision.status.name}',
      );

      final response = await learnwayClient.post(
        Endpoints.updateVerificationStatus,
        body: {
          "isVerified": decision.status.isApproved,
          "verificationReference": sessionId,
          "verificationNotes": "Verified via third-party provider didit.me",
          "verifiedAt": DateTime.now().toIso8601String(),
          "verificationDecision": decision.rawDecision,
        },
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('KYC status updated successfully in backend');
      } else {
        throw Exception(
          'Backend returned status ${response.statusCode}: ${response.body}',
        );
      }
    } on SocketException catch (e) {
      throw KycException('Network error updating backend: $e');
    } on HttpException catch (e) {
      throw KycException('HTTP error updating backend: $e');
    } catch (e) {
      throw KycException('Error updating backend KYC status: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getKycStatus() async {
    try {
      final learnwayClient = locator<BaseApiClients>();
      final userToken = await SharedPreferencesStore.getUserToken(userTokenKey);

      if (userToken == null || userToken.isEmpty) {
        throw KycException('User token not found');
      }

      final response = await learnwayClient.get(
        Endpoints.getKycStatus,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final isverified = data['kycStatus']['isVerified'] as bool? ?? false;
        final isverifiedAt = data['kycStatus']['verifiedAt'] as String? ?? '';
        final sessionId =
            data['kycStatus']['verificationReference'] as String? ?? '';
        return {
          'isVerified': isverified,
          'verifiedAt': isverifiedAt,
          'verificationReference': sessionId,
        };
      } else {
        throw KycException(
          'Backend returned status ${response.statusCode}: ${response.body}',
        );
      }
    } on SocketException catch (e) {
      throw KycException('Network error fetching KYC status: $e');
    } on HttpException catch (e) {
      throw KycException('HTTP error fetching KYC status: $e');
    } on FormatException catch (e) {
      throw KycException('Invalid response format: $e');
    } catch (e) {
      throw KycException('Error fetching KYC status: $e');
    }
  }
}
