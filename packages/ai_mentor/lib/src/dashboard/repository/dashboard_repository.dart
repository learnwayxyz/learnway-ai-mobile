import 'dart:developer';

import 'package:dartz/dartz.dart';

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
    } on DashboardFailure catch (e) {
      log('DashboardRepository failure: ${e.message}');
      return Left(e);
    } catch (e) {
      log('DashboardRepository error: $e');
      return Left(DashboardFailure(e.toString()));
    }
  }
}
