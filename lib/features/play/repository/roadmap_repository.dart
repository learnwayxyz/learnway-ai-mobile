import 'dart:developer';

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:learnwayv2/features/play/data_source/roadmap_data_source.dart';
import 'package:learnwayv2/features/play/models/career_path_model.dart';
import 'package:learnwayv2/features/play/models/roadmap_model.dart';
import 'package:learnwayv2/features/play/play_failure.dart';

class RoadmapRepository {
  RoadmapRepository(this._dataSource);

  final RoadmapDataSource _dataSource;

  Future<Either<Failure, RoadmapModel>> fetchMyRoadmap() async {
    try {
      final roadmap = await _dataSource.fetchMyRoadmap();
      return Right(roadmap);
    } on PlayFailure catch (e) {
      log('RoadmapRepository failure: ${e.message}');
      return Left(e);
    } catch (e) {
      log('RoadmapRepository error: $e');
      return Left(PlayFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<CareerPathModel>>> fetchCareerPaths(
    String userId,
  ) async {
    try {
      final paths = await _dataSource.fetchCareerPaths(userId);
      return Right(paths);
    } on PlayFailure catch (e) {
      log('RoadmapRepository fetchCareerPaths failure: ${e.message}');
      return Left(e);
    } catch (e) {
      log('RoadmapRepository fetchCareerPaths error: $e');
      return Left(PlayFailure(e.toString()));
    }
  }
}
