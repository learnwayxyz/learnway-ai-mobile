enum DiditSessionStatus {
  notStarted,
  inProgress,
  approved,
  declined,
  inReview,
  resubmitted,
  expired,
  abandoned,
  kycExpired,
  unknown;

  bool get shouldUpdateBackend => switch (this) {
        DiditSessionStatus.approved ||
        DiditSessionStatus.declined ||
        DiditSessionStatus.inReview ||
        DiditSessionStatus.resubmitted ||
        DiditSessionStatus.abandoned ||
        DiditSessionStatus.kycExpired =>
          true,
        _ => false,
      };

  bool get isApproved => this == DiditSessionStatus.approved;
}
