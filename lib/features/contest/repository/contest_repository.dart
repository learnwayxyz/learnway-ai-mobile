import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:learnwayv2/features/contest/contest_exceptions.dart';
import 'package:learnwayv2/features/contest/data/contest_data_source.dart';
import 'package:learnwayv2/features/contest/model/all_contest_model.dart';
import 'package:learnwayv2/features/contest/model/join_contest_model.dart';
import 'package:learnwayv2/features/contest/model/start_contest_model.dart';
import 'package:learnwayv2/features/contest/model/submit_contest_response.dart';

class ContestRepository {
  final ContestRemoteDataSource _remoteDataSource;

  ContestRepository(this._remoteDataSource);

  Future<Either<ContestFailure, SubmitContestResponse>> submitContestResults({
    required String contestId,
    required Map<String, dynamic> submissionPayLoad,
  }) async {
    try {
      final response = await _remoteDataSource.submitContestResults(
        contestId: contestId,
        submissionPayLoad: submissionPayLoad,
      );
      return Right(response);
    } catch (e) {
      log('Error in submitContestResults: $e');
      return Left(ContestFailure(e.toString()));
    }
  }

  Future<Either<ContestFailure, List<Map<String, dynamic>>>>
  getContestLeaderboard(String contestId) async {
    try {
      final response = await _remoteDataSource.getContestLeaderboard(contestId);
      return Right(response);
    } catch (e) {
      log('Error in getContestLeaderboard: $e');
      return Left(ContestFailure(e.toString()));
    }
  }

  Future<Either<ContestFailure, AllContestData>> getAllContests({
    int page = 1,
    int limit = 10,
    String order = 'DESC',
    String sort = 'createdAt',
  }) async {
    try {
      final response = await _remoteDataSource.getAllContests(
        page: page,
        limit: limit,
        order: order,
        sort: sort,
      );
      return Right(response.data);
    } catch (e) {
      log('Error in getAllContests: $e');
      return Left(ContestFailure(e.toString()));
    }
  }

  Future<Either<ContestFailure, ContestParticipation>> joinContest(
    String contestId, {
    String? accessCode,
  }) async {
    try {
      final response = await _remoteDataSource.joinContest(
        contestId,
        accessCode: accessCode,
      );
      return Right(response.data);
    } catch (e) {
      return Left(ContestFailure(e.toString()));
    }
  }

  Future<Either<ContestFailure, StartContestData>> startContest(
    String contestId,
  ) async {
    try {
      final response = await _remoteDataSource.startContest(contestId);
      return Right(response.data);
    } catch (e) {
      return Left(ContestFailure(e.toString()));
    }
  }
}
