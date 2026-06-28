part of 'kyc_cubit.dart';

enum KycStatus {
  initial,
  loading,
  loaded,
  creatingSession,
  error,
  completing,
  completed,
}

enum UpdateBackend { initial, sending, sent, error }

enum VerificationStatus { notStarted, started, inReview, verified, declined }

class KycState extends Equatable {
  const KycState({
    this.status = KycStatus.initial,
    this.verificationStatus = VerificationStatus.notStarted,
    this.backendStatus = UpdateBackend.initial,
    this.sessionId,
    this.sessionUrl,
    this.completedAt,
    this.errorMessage,
  });

  final KycStatus status;
  final VerificationStatus verificationStatus;
  final UpdateBackend backendStatus;
  final String? sessionId;
  final String? sessionUrl;
  final DateTime? completedAt;
  final String? errorMessage;

  // Computed properties for UI state
  bool get isLoading => status == KycStatus.loading;
  bool get isCreatingSession => status == KycStatus.creatingSession;
  bool get hasError => status == KycStatus.error;

  // Verification state checks
  bool get isVerified => verificationStatus == VerificationStatus.verified;
  bool get isInReview => verificationStatus == VerificationStatus.inReview;
  bool get isDeclined => verificationStatus == VerificationStatus.declined;
  bool get isNotStarted => verificationStatus == VerificationStatus.notStarted;

  // Business logic
  bool get shouldShowKycCard => !isVerified;
  bool get canStartKyc => status != KycStatus.creatingSession && !isVerified;

  KycState copyWith({
    KycStatus? status,
    VerificationStatus? verificationStatus,
    UpdateBackend? backendStatus,
    String? sessionId,
    String? sessionUrl,
    DateTime? completedAt,
    String? errorMessage,
    bool clearError = false,
  }) {
    return KycState(
      status: status ?? this.status,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      sessionId: sessionId ?? this.sessionId,
      sessionUrl: sessionUrl ?? this.sessionUrl,
      completedAt: completedAt ?? this.completedAt,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      backendStatus: backendStatus ?? this.backendStatus,
    );
  }

  @override
  List<Object?> get props => [
    status,
    verificationStatus,
    sessionId,
    sessionUrl,
    completedAt,
    errorMessage,
    backendStatus,
  ];
}
