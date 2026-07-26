import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../data_source/learning_path_data_source.dart';
import '../learning_path_failure.dart';
import '../models/learning_path_model.dart';
import '../models/path_course_model.dart';

class LearningPathRepository {
  LearningPathRepository(this._dataSource);

  final LearningPathDataSource _dataSource;

  Future<Either<LearningPathFailure, List<LearningPathModel>>>
      getLearningPaths() async {
    try {
      final paths = await _dataSource.getLearningPaths();
      return Right(paths);
    } on LearningPathFailure catch (e) {
      log('LearningPathRepository failure: ${e.message}');
      return Left(e);
    } catch (e) {
      log('LearningPathRepository error: $e');
      return Left(LearningPathFailure(e.toString()));
    }
  }

  Future<Either<LearningPathFailure, LearningPathModel>> getLearningPathById(
    String id,
  ) async {
    try {
      final path = await _dataSource.getLearningPathById(id);
      return Right(path);
    } on LearningPathFailure catch (e) {
      log('LearningPathRepository getLearningPathById failure: ${e.message}');
      return Left(e);
    } catch (e) {
      log('LearningPathRepository getLearningPathById error: $e');
      return Left(LearningPathFailure(e.toString()));
    }
  }

  Future<Either<LearningPathFailure, List<PathCourseModel>>> getCoursesByPath(
    String pathId,
  ) async {
    try {
      final courses = await _dataSource.getCoursesByPath(pathId);
      return Right(courses);
    } on LearningPathFailure catch (e) {
      log('LearningPathRepository getCoursesByPath failure: ${e.message}');
      return Left(e);
    } catch (e) {
      log('LearningPathRepository getCoursesByPath error: $e');
      return Left(LearningPathFailure(e.toString()));
    }
  }
}
