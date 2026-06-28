import 'dart:async';
import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/services/kyc_service/kyc_sync_queue.dart';
import 'package:learnwayv2/services/kyc_service/model/didit_session_status.dart';
import 'package:learnwayv2/services/kyc_service/model/session_decision.dart';
import 'package:learnwayv2/services/kyc_service/verification_service.dart';
import 'package:core/core.dart';
import 'dart:io';

part 'kyc_state.dart';

class KycCubit extends Cubit<KycState> {
  KycCubit({required VerificationService verificationService})
    : _verificationService = verificationService,
      super(const KycState());

  final VerificationService _verificationService;

  Future<void> initialize() async {
    final cachedKycStatus = await SharedPreferencesStore.getKycStatus(
      kycStatusKey,
    );

    if (cachedKycStatus == true) {
      log('Using cached KYC status: verified');
      final cachedSessionId = await SharedPreferencesStore.getKycSessionId(
        kycSessionIdKey,
      );
      emit(
        state.copyWith(
          status: KycStatus.loaded,
          verificationStatus: VerificationStatus.verified,
          sessionId: cachedSessionId,
        ),
      );
      _refreshFromBackend();
      return;
    }

    emit(state.copyWith(status: KycStatus.loading));
    try {
      VerificationStatus verificationStatus = VerificationStatus.notStarted;
      final backendStatus = await _verificationService.getKycStatus();
      final isVerified = backendStatus['isVerified'] ?? false;
      var sessionId = backendStatus['verificationReference'] as String?;
      if (isVerified && sessionId != null) {
        emit(
          state.copyWith(
            status: KycStatus.loaded,
            verificationStatus: VerificationStatus.verified,
            sessionId: sessionId,
          ),
        );
        await SharedPreferencesStore.saveKycStatus(kycStatusKey, isVerified);
        return;
      }

      if (isVerified == false) {
        log('User not verified according to backend status.');
        final myid = await SharedPreferencesStore.getKycSessionId(
          kycSessionIdKey,
        );
        log('Using session ID from storage: $myid');

        if (myid != null && myid.isNotEmpty) {
          sessionId = myid;
        }

        if (sessionId != null) {
          final decision =
              await _verificationService.getSessionDecision(sessionId);
          verificationStatus = _mapStatusToVerification(decision.status);
          log('Session status: ${decision.status.name}');
        }

        emit(
          state.copyWith(
            status: KycStatus.loaded,
            verificationStatus: verificationStatus,
            sessionId: sessionId,
          ),
        );
      }
      emit(
        state.copyWith(
          backendStatus: UpdateBackend.sent,
          verificationStatus: verificationStatus,
          sessionId: sessionId,
        ),
      );
    } catch (e) {
      log('Failed to fetch KYC status from backend: $e');
    }
  }

  Future<Map<String, dynamic>?> createVerificationSession() async {
    if (!canStartKyc) return null;

    final deviceUsed = Platform.isAndroid ? 'android' : 'ios';
    emit(state.copyWith(status: KycStatus.creatingSession));

    try {
      final sessionData = await _verificationService.createSession(
        callbackUrl: 'learnway://verification/callback',
        metadata: {
          'user_type': 'standard',
          'source': deviceUsed,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      log('Created KYC session data: $sessionData');
      final sessionId = sessionData['session_id'] as String;
      await SharedPreferencesStore.saveKycSessionId(kycSessionIdKey, sessionId);
      log('Saved session ID to storage: $sessionId');

      emit(
        state.copyWith(
          status: KycStatus.loaded,
          verificationStatus: VerificationStatus.notStarted,
          sessionId: sessionId,
          sessionUrl: sessionData['url'],
        ),
      );

      return sessionData;
    } catch (e) {
      emit(
        state.copyWith(
          status: KycStatus.error,
          errorMessage: 'Failed to create verification session: $e',
        ),
      );
      return null;
    }
  }

  Future<void> handleKycCompletion(
    String sessionId,
    Map<String, dynamic> decisionParams,
  ) async {
    log('Handling KYC completion from deeplink: $sessionId');
    try {
      emit(state.copyWith(status: KycStatus.completing));
      await SharedPreferencesStore.saveKycSessionId(kycSessionIdKey, sessionId);

      final decision = SessionDecision.fromJson({
        'session_id': sessionId,
        ...decisionParams,
      });

      final verificationStatus = _mapStatusToVerification(decision.status);

      await _verificationService.updateBackendKycStatus(
        sessionId: sessionId,
        decision: decision,
      );

      emit(
        state.copyWith(
          status: KycStatus.completed,
          verificationStatus: verificationStatus,
        ),
      );

      if (verificationStatus == VerificationStatus.verified) {
        await SharedPreferencesStore.saveKycStatus(kycStatusKey, true);
      }
    } catch (e) {
      log('Failed to handle KYC completion: $e');
    }
  }

  Future<void> getSessioDecision() async {
    emit(state.copyWith(status: KycStatus.loading));
    try {
      final sessionId = await SharedPreferencesStore.getKycSessionId(
        kycSessionIdKey,
      );
      log('Retrieved session ID from storage: $sessionId');

      if (sessionId == null || sessionId.isEmpty) {
        log('No session ID found in storage, cannot check decision');
        emit(
          state.copyWith(
            status: KycStatus.error,
            errorMessage: 'No session ID found',
          ),
        );
        return;
      }

      final decision = await _verificationService.getSessionDecision(sessionId);
      log('Session decision status: ${decision.status.name}');

      final verificationStatus = _mapStatusToVerification(decision.status);

      await _verificationService.updateBackendKycStatus(
        sessionId: sessionId,
        decision: decision,
      );

      emit(
        state.copyWith(
          status: KycStatus.completed,
          verificationStatus: verificationStatus,
        ),
      );

      if (verificationStatus == VerificationStatus.verified) {
        await SharedPreferencesStore.saveKycStatus(kycStatusKey, true);
      }
    } catch (e) {
      log('Error in getSessioDecision: $e');
      emit(
        state.copyWith(
          status: KycStatus.error,
          errorMessage: 'Failed to get session decision: $e',
        ),
      );
      rethrow;
    }
  }

  Future<void> syncPendingUpdates() async {
    log('Syncing pending updates...');
    final pendingItems = await KycSyncQueue.getPendingItems();
    if (pendingItems.isEmpty) return;
    for (final item in pendingItems) {
      try {
        final decision = SessionDecision.fromJson(
          item['sessionDecision'] as Map<String, dynamic>,
        );
        await _verificationService.updateBackendKycStatus(
          sessionId: item['sessionId'] as String,
          decision: decision,
        );
        await KycSyncQueue.removeFromQueue(item['sessionId'] as String);
        log('Successfully synced pending update for session: ${item['sessionId']}');
      } catch (e) {
        log('Failed to sync session: $e');
      }
    }
  }

  VerificationStatus _mapStatusToVerification(DiditSessionStatus status) {
    log('Mapping didit status: ${status.name}');
    return switch (status) {
      DiditSessionStatus.approved => VerificationStatus.verified,
      DiditSessionStatus.declined ||
      DiditSessionStatus.abandoned =>
        VerificationStatus.declined,
      DiditSessionStatus.inReview ||
      DiditSessionStatus.resubmitted ||
      DiditSessionStatus.kycExpired =>
        VerificationStatus.inReview,
      DiditSessionStatus.inProgress => VerificationStatus.started,
      _ => VerificationStatus.notStarted,
    };
  }

  @override
  Future<void> resetKyc() async {
    try {
      await SharedPreferencesStore.clearKycData();
      emit(const KycState());
    } catch (e) {
      log('Error resetting KYC: $e');
    }
  }

  bool get canStartKyc => state.canStartKyc;

  Future<void> _refreshFromBackend() async {
    try {
      final backendStatus = await _verificationService.getKycStatus();
      final isVerified = backendStatus['isVerified'] ?? false;
      final sessionId = backendStatus['verificationReference'] as String?;

      if (isVerified && sessionId != null) {
        await SharedPreferencesStore.saveKycStatus(kycStatusKey, true);
        await SharedPreferencesStore.saveKycSessionId(
          kycSessionIdKey,
          sessionId,
        );
        log('Background refresh: KYC status verified, cache updated');
      } else if (!isVerified) {
        await SharedPreferencesStore.saveKycStatus(kycStatusKey, false);
        log('Background refresh: KYC status not verified, cache cleared');
        emit(state.copyWith(verificationStatus: VerificationStatus.notStarted));
      }
    } catch (e) {
      log('Background refresh failed: $e');
    }
  }
}
