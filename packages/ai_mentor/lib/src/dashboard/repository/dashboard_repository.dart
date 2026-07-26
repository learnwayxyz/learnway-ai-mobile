import 'package:dartz/dartz.dart';

import '../../reporting/failure_reporter.dart';
import '../dashboard_failure.dart';
import '../data_source/dashboard_data_source.dart';
import '../models/mentor_dashboard_model.dart';

class DashboardRepository {
  DashboardRepository(this._dataSource);

  final DashboardDataSource _dataSource;

  Future<Either<DashboardFailure, MentorDashboardModel>> getDashboard(
    String userId,
  ) async {
    try {
      final dashboard = await _dataSource.getDashboard(userId);
      return Right(dashboard);
    } on DashboardFailure catch (e, st) {
      reportRepositoryFailure('getDashboard', e, st, expected: true);
      return Left(e);
    } catch (e, st) {
      reportRepositoryFailure('getDashboard', e, st);
      return Left(DashboardFailure(e.toString()));
    }
  }
}
