import 'dart:developer';

import 'package:ai_mentor/src/career_goal/models/recommendations_model.dart';
import 'package:dartz/dartz.dart';

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
    } on CareerGoalFailure catch (e) {
      log('CareerGoalRepository failure: ${e.message}');
      return Left(e);
    } catch (e) {
      log('CareerGoalRepository error: $e');
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
    } on CareerGoalFailure catch (e) {
      log('CareerGoalRepository generateRoadmap failure: ${e.message}');
      return Left(e);
    } catch (e) {
      log('CareerGoalRepository generateRoadmap error: $e');
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
    } on CareerGoalFailure catch (e) {
      log('CareerGoalRepository getDiscoveryRecommendations failure: ${e.message}');
      return Left(e);
    } catch (e) {
      log('CareerGoalRepository getDiscoveryRecommendations error: $e');
      return Left(CareerGoalFailure(e.toString()));
    }
  }

  Future<Either<CareerGoalFailure, LearningInsightsData>> recommendations(
    String userId,
  ) async {
    try {
      final recommendations = await _dataSource.recommendations(userId);
      return Right(recommendations);
    } on CareerGoalFailure catch (e) {
      log('CareerGoalRepository recommendations failure: ${e.message}');
      return Left(e);
    } catch (e) {
      log('CareerGoalRepository recommendations error: $e');
      return Left(CareerGoalFailure(e.toString()));
    }
  }
}
