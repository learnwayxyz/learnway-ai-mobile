part of 'certificate_cubit.dart';

sealed class CertificateState extends Equatable {
  const CertificateState();

  @override
  List<Object?> get props => [];
}

final class CertificateInitial extends CertificateState {}

final class CertificateLoading extends CertificateState {}

final class CertificateNotClaimed extends CertificateState {}

final class CertificateClaiming extends CertificateState {}

final class CertificateClaimed extends CertificateState {
  const CertificateClaimed(this.certificate);

  final CertificateClaim certificate;

  @override
  List<Object?> get props => [certificate];
}

final class CertificateError extends CertificateState {
  const CertificateError(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
