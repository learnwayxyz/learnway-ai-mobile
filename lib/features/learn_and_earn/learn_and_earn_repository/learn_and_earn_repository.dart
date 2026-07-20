import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/advanced_registered_courses.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/beginner_registered_courses.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/learnway_courses.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/enrollment_response.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/learn_and_earn_data_source.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/course_lesson.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/intermediate_registered_course.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/certificate_claim.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/course_project.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/lesson_info_details.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/lesson_progress.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/lesson_slide.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/ai_tutor_response.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/start_lesson_response.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_exception.dart';
import 'package:core/core.dart';

class LearnAndEarnRepository {
  LearnAndEarnRepository(this._dataSource);

  final LearnAndEarnDataSource _dataSource;
  Future<Either<Failure, List<LearnWayCourses>>> getLearnAndEarnList() async {
    try {
      final result = await _dataSource.getCourse();
      return Right(result);
    } on LearnAndEarnFailure catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    } on Exception catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<LearnWayCourses>>> getBeginnerCourse() async {
    try {
      final result = await _dataSource.getBeginnerCourse();
      return Right(result);
    } on LearnAndEarnFailure catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    } on Exception catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<LearnWayCourses>>> getIntermediateCourse() async {
    try {
      final result = await _dataSource.getIntermidiateCourse();
      return Right(result);
    } on LearnAndEarnFailure catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    } on Exception catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<LearnWayCourses>>> getAdvancedCourse() async {
    try {
      final result = await _dataSource.getAdvancedCourse();
      return Right(result);
    } on LearnAndEarnFailure catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    } on Exception catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<Either<Failure, EnrollmentResponse>> enrollCourse(
    String courseId,
  ) async {
    try {
      final result = await _dataSource.enrollCourse(courseId);
      return Right(result);
    } on LearnAndEarnFailure catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    } on Exception catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<BeginnerRegisteredCourses>>>
  getMyBeginnerCourses() async {
    try {
      final result = await _dataSource.getMyBeginnerCourses();
      return Right(result);
    } on LearnAndEarnFailure catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    } on Exception catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<IntermediateRegisteredCourse>>>
  getMyIntermediateCourses() async {
    try {
      final result = await _dataSource.getMyIntermediateCourses();
      return Right(result);
    } on LearnAndEarnFailure catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    } on Exception catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<AdvancedRegisteredCourses>>>
  getMyAdvancedCourses() async {
    try {
      final result = await _dataSource.getMyAdvancedCourses();
      return Right(result);
    } on LearnAndEarnFailure catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    } on Exception catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<Either<Failure, CourseLesson>> getCourseLessons(String id) async {
    try {
      final result = await _dataSource.fetchCourseLessons(id);
      return Right(result);
    } on LearnAndEarnFailure catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    } on Exception catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<Either<Failure, LessonSlidesResponse>> getLessonSlides(
    String id,
  ) async {
    try {
      final result = await _dataSource.getLssonSlides(id);
      return Right(result);
    } on LearnAndEarnFailure catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    } on Exception catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<Either<Failure, StartLessonResponse>> startLesson(
    String lessonId,
    String courseId,
  ) async {
    try {
      final result = await _dataSource.startLessons(lessonId, courseId);
      return Right(result);
    } on LearnAndEarnFailure catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    } on Exception catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<Either<Failure, LessonProgressResponse>> getLessonProgress(
    String courseId,
  ) async {
    try {
      final result = await _dataSource.getLessonProgress(courseId);
      return Right(result);
    } on LearnAndEarnFailure catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    } on Exception catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<Either<Failure, AiTutorResponseData>> askAiTutor({
    required String lessonId,
    required AiTutorPromptType promptType,
    String? customQuestion,
  }) async {
    try {
      final result = await _dataSource.askAiTutor(
        lessonId: lessonId,
        promptType: promptType,
        customQuestion: customQuestion,
      );
      return Right(result);
    } on AiTutorLessonLimitFailure catch (e) {
      return Left(e);
    } on AiTutorDailyLimitFailure catch (e) {
      return Left(e);
    } on LearnAndEarnFailure catch (e) {
      return Left(e);
    } on Exception catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<Either<Failure, int>> fetchDailyLessonsRemaining() async {
    try {
      final result = await _dataSource.fetchDailyLessonsRemaining();
      return Right(result);
    } on LearnAndEarnFailure catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    } on Exception catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<Either<Failure, LessonInfoDetails>> fetchLessonInfoDetails(
    String lessonId,
  ) async {
    try {
      final result = await _dataSource.fetchLessonInfoDetails(lessonId);
      return Right(result);
    } on LearnAndEarnFailure catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    } on Exception catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> uploadProjectFile(File file) async {
    try {
      final result = await _dataSource.uploadProjectFile(file);
      return Right(result);
    } on LearnAndEarnFailure catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    } on Exception catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<Either<Failure, Unit>> sendCourseProject(
    String courseId, {
    required String submissionType,
    required String content,
    required bool isDraft,
  }) async {
    try {
      await _dataSource.sendCourseProject(
        courseId,
        submissionType: submissionType,
        content: content,
        isDraft: isDraft,
      );
      return const Right(unit);
    } on LearnAndEarnFailure catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    } on Exception catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<Either<Failure, CourseProject?>> fetchCourseProject(
    String courseId,
  ) async {
    try {
      final result = await _dataSource.fetchCourseProject(courseId);
      return Right(result);
    } on LearnAndEarnFailure catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    } on Exception catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<Either<Failure, CertificateClaim>> claimCertificate(
    String courseId,
    String studentName,
  ) async {
    try {
      final result = await _dataSource.claimCertificate(courseId, studentName);
      return Right(result);
    } on LearnAndEarnFailure catch (e) {
      return Left(e);
    } on Exception catch (e) {
      return Left(LearnAndEarnFailure(e.toString()));
    }
  }
}
