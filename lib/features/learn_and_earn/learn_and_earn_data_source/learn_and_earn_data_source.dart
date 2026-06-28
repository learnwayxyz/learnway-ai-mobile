import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:core/core.dart';
import 'package:learnwayv2/core/di/locator.dart';

import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/advanced_registered_courses.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/beginner_registered_courses.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/learnway_courses.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/enrollment_response.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/course_lesson.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/intermediate_registered_course.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/lesson_progress.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/lesson_slide.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/ai_tutor_response.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/start_lesson_response.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_exception.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';

class LearnAndEarnDataSource {
  final client = locator<BaseApiClients>();
  Future<List<LearnWayCourses>> getCourse() async {
    try {
      final token = await SharedPreferencesStore.getUserToken(userTokenKey);
      final response = await client.get(
        Endpoints.getCourses,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final List<dynamic> decoded = jsonDecode(response.body);
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw LearnAndEarnFailure('Error fetching courses}');
      }
      await getBeginnerCourse();
      return decoded.map((course) => LearnWayCourses.fromJson(course)).toList();
    } on SocketException catch (e) {
      return Future.error(LearnAndEarnFailure('Network error: ${e.message}'));
    } on HttpException catch (e) {
      return Future.error(LearnAndEarnFailure('Server error: ${e.message}'));
    } catch (e) {
      return Future.error(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<List<LearnWayCourses>> getBeginnerCourse() async {
    try {
      final token = await SharedPreferencesStore.getUserToken(userTokenKey);
      final response = await client.get(
        Endpoints.getCourses,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final List<dynamic> decoded = jsonDecode(response.body);
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw LearnAndEarnFailure('Error fetching courses}');
      }
      final beginnerCourses = decoded
          .where((course) => course['skillLevel'] == 'BEGINNER')
          .toList();

      final courses = beginnerCourses
          .map((course) => LearnWayCourses.fromJson(course))
          .toList();
      courses.sort((a, b) => a.order.compareTo(b.order));
      return courses;
    } on SocketException catch (e) {
      return Future.error(LearnAndEarnFailure('Network error: ${e.message}'));
    } on HttpException catch (e) {
      return Future.error(LearnAndEarnFailure('Server error: ${e.message}'));
    } catch (e) {
      return Future.error(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<List<LearnWayCourses>> getIntermidiateCourse() async {
    try {
      final token = await SharedPreferencesStore.getUserToken(userTokenKey);
      final response = await client.get(
        Endpoints.getCourses,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final List<dynamic> decoded = jsonDecode(response.body);
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw LearnAndEarnFailure('Error fetching courses}');
      }
      final intermidiateCourses = decoded
          .where((course) => course['skillLevel'] == 'INTERMEDIATE')
          .toList();

      intermidiateCourses.sort(
        (a, b) => (a['order'] as int).compareTo(b['order'] as int),
      );

      return intermidiateCourses
          .map((course) => LearnWayCourses.fromJson(course))
          .toList();
    } on SocketException catch (e) {
      return Future.error(LearnAndEarnFailure('Network error: ${e.message}'));
    } on HttpException catch (e) {
      return Future.error(LearnAndEarnFailure('Server error: ${e.message}'));
    } catch (e) {
      return Future.error(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<List<LearnWayCourses>> getAdvancedCourse() async {
    try {
      final token = await SharedPreferencesStore.getUserToken(userTokenKey);
      final response = await client.get(
        Endpoints.getCourses,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final List<dynamic> decoded = jsonDecode(response.body);
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw LearnAndEarnFailure('Error fetching courses}');
      }
      final advancedCourses = decoded
          .where((course) => course['skillLevel'] == 'ADVANCED')
          .toList();

      advancedCourses.sort(
        (a, b) => (a['order'] as int).compareTo(b['order'] as int),
      );
      return advancedCourses
          .map((course) => LearnWayCourses.fromJson(course))
          .toList();
    } on SocketException catch (e) {
      return Future.error(LearnAndEarnFailure('Network error: ${e.message}'));
    } on HttpException catch (e) {
      return Future.error(LearnAndEarnFailure('Server error: ${e.message}'));
    } catch (e) {
      return Future.error(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<EnrollmentResponse> enrollCourse(String courseId) async {
    try {
      final token = await SharedPreferencesStore.getUserToken(userTokenKey);
      final response = await client.post(
        '${Endpoints.enrollCourse}/$courseId',
        body: {},
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final decoded = jsonDecode(response.body);
      log('enrollCourseError() ${decoded}');
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw LearnAndEarnFailure('Error fetching courses');
      }
      return EnrollmentResponse.fromJson(decoded);
    } on SocketException catch (e) {
      return Future.error(LearnAndEarnFailure('Network error: ${e.message}'));
    } on HttpException catch (e) {
      return Future.error(LearnAndEarnFailure('Server error: ${e.message}'));
    } catch (e) {
      return Future.error(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<List<BeginnerRegisteredCourses>> getMyBeginnerCourses() async {
    try {
      final token = await SharedPreferencesStore.getUserToken(userTokenKey);
      final response = await client.get(
        Endpoints.getMyCourses,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw LearnAndEarnFailure('Error fetching courses');
      }

      final List<dynamic> decoded = jsonDecode(response.body);
      final beginnerRegisteredCourses = decoded
          .where(
            (enrollment) =>
                enrollment['course'] != null &&
                enrollment['course']['skillLevel'] == 'BEGINNER',
          )
          .toList();

      final transformed = beginnerRegisteredCourses
          .map((course) => BeginnerRegisteredCourses.fromJson(course))
          .toList();
      return transformed;
    } on SocketException catch (e) {
      return Future.error(LearnAndEarnFailure('Network error: ${e.message}'));
    } on HttpException catch (e) {
      return Future.error(LearnAndEarnFailure('Server error: ${e.message}'));
    } catch (e) {
      return Future.error(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<List<IntermediateRegisteredCourse>> getMyIntermediateCourses() async {
    try {
      final token = await SharedPreferencesStore.getUserToken(userTokenKey);
      final response = await client.get(
        Endpoints.getMyCourses,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw LearnAndEarnFailure('Error fetching courses');
      }

      final List<dynamic> decoded = jsonDecode(response.body);
      final List<dynamic> data = decoded;
      final intermediateRegisteredCourses = data
          .where(
            (enrollment) =>
                enrollment['course'] != null &&
                enrollment['course']['skillLevel'] == 'INTERMEDIATE',
          )
          .toList();
      return intermediateRegisteredCourses
          .map((course) => IntermediateRegisteredCourse.fromJson(course))
          .toList();
    } on SocketException catch (e) {
      return Future.error(LearnAndEarnFailure('Network error: ${e.message}'));
    } on HttpException catch (e) {
      return Future.error(LearnAndEarnFailure('Server error: ${e.message}'));
    } catch (e) {
      return Future.error(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<List<AdvancedRegisteredCourses>> getMyAdvancedCourses() async {
    try {
      final token = await SharedPreferencesStore.getUserToken(userTokenKey);
      final response = await client.get(
        Endpoints.getMyCourses,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw LearnAndEarnFailure('Error fetching courses');
      }

      final List<dynamic> decoded = jsonDecode(response.body);
      final List<dynamic> data = decoded;
      final advancedRegisteredCourses = data
          .where(
            (enrollment) =>
                enrollment['course'] != null &&
                enrollment['course']['skillLevel'] == 'ADVANCED',
          )
          .toList();
      return advancedRegisteredCourses
          .map((course) => AdvancedRegisteredCourses.fromJson(course))
          .toList();
    } on SocketException catch (e) {
      return Future.error(LearnAndEarnFailure('Network error: ${e.message}'));
    } on HttpException catch (e) {
      return Future.error(LearnAndEarnFailure('Server error: ${e.message}'));
    } catch (e) {
      return Future.error(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<CourseLesson> fetchCourseLessons(String id) async {
    try {
      final token = await SharedPreferencesStore.getUserToken(userTokenKey);
      final response = await client.get(
        '${Endpoints.getCourseLessons}/$id',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      log('fetchCourseLessons(): $decoded');
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw LearnAndEarnFailure('Error fetching courses}');
      }
      return CourseLesson.fromJson(decoded);
    } on SocketException catch (e) {
      return Future.error(LearnAndEarnFailure('Network error: ${e.message}'));
    } on HttpException catch (e) {
      return Future.error(LearnAndEarnFailure('Server error: ${e.message}'));
    } catch (e) {
      return Future.error(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<LessonSlidesResponse> getLssonSlides(String id) async {
    try {
      final token = await SharedPreferencesStore.getUserToken(userTokenKey);
      final response = await client.get(
        '${Endpoints.lessonSlides}/$id',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      log('getLssonSlides(): $decoded');
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw LearnAndEarnFailure('Error fetching courses}');
      }
      return LessonSlidesResponse.fromJson(decoded);
    } on SocketException catch (e) {
      return Future.error(LearnAndEarnFailure('Network error: ${e.message}'));
    } on HttpException catch (e) {
      return Future.error(LearnAndEarnFailure('Server error: ${e.message}'));
    } catch (e) {
      return Future.error(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<StartLessonResponse> startLessons(String id, String courseId) async {
    try {
      final token = await SharedPreferencesStore.getUserToken(userTokenKey);
      final response = await client.post(
        body: {},
        '${Endpoints.startLesson}/$id?courseId=$courseId',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      log('startLessons(): $decoded');
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw LearnAndEarnFailure('Error starting lesson');
      }
      return StartLessonResponse.fromJson(decoded);
    } on SocketException catch (e) {
      return Future.error(LearnAndEarnFailure('Network error: ${e.message}'));
    } on HttpException catch (e) {
      return Future.error(LearnAndEarnFailure('Server error: ${e.message}'));
    } catch (e) {
      return Future.error(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<LessonProgressResponse> getLessonProgress(String courseId) async {
    try {
      final token = await SharedPreferencesStore.getUserToken(userTokenKey);
      final response = await client.get(
        '${Endpoints.getLessonProgress}/$courseId',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final responseBody = jsonDecode(response.body);
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw LearnAndEarnFailure('Error fetching lesson progress');
      }
      log('getLessonProgress(): $responseBody');
      return LessonProgressResponse.fromJson(responseBody);
    } on SocketException catch (e) {
      return Future.error(LearnAndEarnFailure('Network error: ${e.message}'));
    } on HttpException catch (e) {
      return Future.error(LearnAndEarnFailure('Server error: ${e.message}'));
    } catch (e) {
      return Future.error(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<AiTutorResponseData> askAiTutor({
    required String lessonId,
    required AiTutorPromptType promptType,
    String? customQuestion,
  }) async {
    assert(
      promptType != AiTutorPromptType.custom || customQuestion != null,
      'customQuestion is required when promptType is custom',
    );
    if (customQuestion != null && customQuestion.length > 500) {
      return Future.error(
        LearnAndEarnFailure('Question must be 500 characters or fewer.'),
      );
    }

    try {
      final token = await SharedPreferencesStore.getUserToken(userTokenKey);
      final body = <String, dynamic>{
        'lessonId': lessonId,
        'promptType': promptType.apiValue,
        'customQuestion': ?customQuestion,
      };
      final response = await client.post(
        Endpoints.aiTutorAsk,
        body: body,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      log('askAiTutor(): $decoded');

      if (response.statusCode != 200 && response.statusCode != 201) {
        if (response.statusCode == 403) {
          final message = decoded['message'] as String? ?? '';
          if (message.toLowerCase().contains('lesson')) {
            throw AiTutorLessonLimitFailure();
          } else {
            throw AiTutorDailyLimitFailure();
          }
        }
        final message =
            decoded['message'] as String? ?? 'Failed to get AI tutor response';
        throw LearnAndEarnFailure(message);
      }

      return AiTutorResponseData.fromJson(
        decoded['data'] as Map<String, dynamic>,
      );
    } on LearnAndEarnFailure catch (e) {
      return Future.error(e);
    } on SocketException catch (e) {
      return Future.error(LearnAndEarnFailure('Network error: ${e.message}'));
    } on HttpException catch (e) {
      return Future.error(LearnAndEarnFailure('Server error: ${e.message}'));
    } catch (e) {
      return Future.error(LearnAndEarnFailure(e.toString()));
    }
  }

  Future<int> fetchDailyLessonsRemaining() async {
    try {
      final token = await SharedPreferencesStore.getUserToken(userTokenKey);
      final response = await client.get(
        Endpoints.dailyLessonsRemaining,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw LearnAndEarnFailure('Error fetching daily lessons remaining');
      }
      final decoded = jsonDecode(response.body);
      log('fetchDailyLessonsRemaining(): $decoded');
      final data = decoded is Map<String, dynamic>
          ? (decoded['data'] ?? decoded) as Map<String, dynamic>
          : decoded as Map<String, dynamic>;
      final remaining =
          data['dailyLessonsRemaining'] as int? ??
          data['remaining'] as int? ??
          0;
      LocalStorageService.updateDailyLessonsRemaining(remaining);
      return remaining;
    } on SocketException catch (e) {
      return Future.error(LearnAndEarnFailure('Network error: ${e.message}'));
    } on HttpException catch (e) {
      return Future.error(LearnAndEarnFailure('Server error: ${e.message}'));
    } catch (e) {
      return Future.error(LearnAndEarnFailure(e.toString()));
    }
  }
}
