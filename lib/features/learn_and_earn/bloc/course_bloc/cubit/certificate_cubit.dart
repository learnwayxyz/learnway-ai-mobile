import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/certificate_claim.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_repository/learn_and_earn_repository.dart';

part 'certificate_state.dart';

class CertificateCubit extends Cubit<CertificateState> {
  CertificateCubit({required this.repository}) : super(CertificateInitial());

  final LearnAndEarnRepository repository;

  Future<void> claimCertificate(String courseId, String studentName) async {
    emit(CertificateClaiming());
    final result = await repository.claimCertificate(courseId, studentName);
    result.fold(
      (failure) => emit(CertificateError(failure.message)),
      (certificate) => emit(CertificateClaimed(certificate)),
    );
  }
}
