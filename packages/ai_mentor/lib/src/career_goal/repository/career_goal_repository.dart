import 'package:ai_mentor/src/career_goal/models/recommendations_model.dart';
import 'package:dartz/dartz.dart';

import '../../reporting/failure_reporter.dart';
import '../career_goal_failure.dart';
import '../data_source/career_goal_data_source.dart';
import '../models/career_recommendation_model.dart';
import '../models/career_roadmap_model.dart';

class CareerGoalRepository {
  CareerGoalRepository(this._dataSource);

  final CareerGoalDataSource _dataSource;

  Future<Either<CareerGoalFailure, void>> saveCareerGoal(
    String userId,
    String goal,
  ) async {
    try {
      await _dataSource.saveCareerGoal(userId, goal);
      return const Right(null);
    } on CareerGoalFailure catch (e, st) {
      reportRepositoryFailure('saveCareerGoal', e, st, expected: true);
      return Left(e);
    } catch (e, st) {
      reportRepositoryFailure('saveCareerGoal', e, st);
      return Left(CareerGoalFailure(e.toString()));
    }
  }

  Future<Either<CareerGoalFailure, CareerRoadmap>> generateRoadmap(
    String userId,
    String goal,
  ) async {
    try {
      final roadmap = await _dataSource.generateRoadmap(userId, goal);
      return Right(roadmap);
    } on CareerGoalFailure catch (e, st) {
      reportRepositoryFailure('generateRoadmap', e, st, expected: true);
      return Left(e);
    } catch (e, st) {
      reportRepositoryFailure('generateRoadmap', e, st);
      return Left(CareerGoalFailure(e.toString()));
    }
  }

  Future<Either<CareerGoalFailure, List<CareerRecommendation>>>
      getDiscoveryRecommendations({
    required String userId,
    required List<String> goals,
    required String experience,
    required List<String> topics,
  }) async {
    try {
      final result = await _dataSource.getDiscoveryRecommendations(
        userId: userId,
        goals: goals,
        experience: experience,
        topics: topics,
      );
      return Right(result);
    } on CareerGoalFailure catch (e, st) {
      reportRepositoryFailure(
        'getDiscoveryRecommendations',
        e,
        st,
        expected: true,
      );
      return Left(e);
    } catch (e, st) {
      reportRepositoryFailure('getDiscoveryRecommendations', e, st);
      return Left(CareerGoalFailure(e.toString()));
    }
  }

  Future<Either<CareerGoalFailure, LearningInsightsData>> recommendations(
    String userId,
  ) async {
    try {
      final recommendations = await _dataSource.recommendations(userId);
      return Right(recommendations);
    } on CareerGoalFailure catch (e, st) {
      reportRepositoryFailure('recommendations', e, st, expected: true);
      return Left(e);
    } catch (e, st) {
      reportRepositoryFailure('recommendations', e, st);
      return Left(CareerGoalFailure(e.toString()));
    }
  }
}
