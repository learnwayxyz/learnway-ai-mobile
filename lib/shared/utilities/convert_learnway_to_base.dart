import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/base_models/base_course_models.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/advanced_registered_courses.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/beginner_registered_courses.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/intermediate_registered_course.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/learnway_courses.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';

import '../../features/learn_and_earn/learn_and_earn_data_source/models/enrolled_learnway_courses.dart';

class CourseConverter {
  static BeginnerRegisteredCourses toBeginnerRegisteredCourse(
    LearnWayCourses course,
  ) {
    if (!course.isEnrolled || course.enrolledAt == null) {
      throw ArgumentError(
        'Course must be enrolled to convert to registered course',
      );
    }

    final beginnerCourseModel = BeginnerRegisteredCourseModel(
      id: course.id,
      createdAt: course.createdAt,
      updatedAt: course.updatedAt,
      deletedAt: course.deletedAt,
      title: course.title,
      description: course.description,
      skillLevel: course.skillLevel,
      isActive: course.isActive,
      isPremium: course.isPremium,
      enrolledUsersCount: course.enrolledUsersCount,
      latestEnrolledUsers:
          course.latestEnrolledUsers
              .map(
                (learnWayUser) => User(
                  id: learnWayUser.id,
                  username: learnWayUser.username,
                  email: learnWayUser.email,
                  profileThumbnailUrl: learnWayUser.profileThumbnailUrl,
                  enrolledAt: learnWayUser.enrolledAt,
                ),
              )
              .toList(),
    );

    final currentUser = User(
      id: 'current-user-${course.id}',
      username: 'Current',
      email: 'current@user.com',
      profileThumbnailUrl: null,
      enrolledAt: course.enrolledAt,
    );

    return BeginnerRegisteredCourses(
      id: course.id,
      createdAt: course.createdAt,
      updatedAt: course.updatedAt,
      deletedAt: course.deletedAt,
      enrolledAt: course.enrolledAt!,
      completedAt: course.completedAt,
      progress: course.progress,
      course: beginnerCourseModel,
      user: currentUser,
    );
  }

  /// Converts LearnWayCourses to IntermediateRegisteredCourse
  static IntermediateRegisteredCourse toIntermediateRegisteredCourse(
    LearnWayCourses course,
  ) {
    if (!course.isEnrolled || course.enrolledAt == null) {
      throw ArgumentError(
        'Course must be enrolled to convert to registered course',
      );
    }

    final intermediateCourseModel = IntermediateRegisteredCourseModel(
      id: course.id,
      createdAt: course.createdAt,
      updatedAt: course.updatedAt,
      deletedAt: course.deletedAt,
      title: course.title,
      description: course.description,
      skillLevel: course.skillLevel,
      isActive: course.isActive,
      isPremium: course.isPremium,
      enrolledUsersCount: course.enrolledUsersCount,
      latestEnrolledUsers:
          course.latestEnrolledUsers
              .map(
                (learnWayUser) => User(
                  id: learnWayUser.id,
                  username: learnWayUser.username,
                  email: learnWayUser.email,
                  profileThumbnailUrl: learnWayUser.profileThumbnailUrl,
                  enrolledAt: learnWayUser.enrolledAt,
                ),
              )
              .toList(),
    );
    final currentUser = User(
      id: 'current-user-${course.id}',
      username: 'Current',
      email: 'current@user.com',
      profileThumbnailUrl: null,
      enrolledAt: course.enrolledAt,
    );
    return IntermediateRegisteredCourse(
      id: course.id,
      createdAt: course.createdAt,
      updatedAt: course.updatedAt,
      deletedAt: course.deletedAt,
      enrolledAt: course.enrolledAt!,
      completedAt: course.completedAt,
      progress: course.progress,
      course: intermediateCourseModel,
      user: currentUser,
    );
  }

  /// Converts LearnWayCourses to AdvancedRegisteredCourses
  static AdvancedRegisteredCourses toAdvancedRegisteredCourse(
    LearnWayCourses course,
  ) {
    if (!course.isEnrolled || course.enrolledAt == null) {
      throw ArgumentError(
        'Course must be enrolled to convert to registered course',
      );
    }

    final advancedCourseModel = AdvancedRegisteredCourseModel(
      id: course.id,
      createdAt: course.createdAt,
      updatedAt: course.updatedAt,
      deletedAt: course.deletedAt,
      title: course.title,
      description: course.description,
      skillLevel: course.skillLevel,
      isActive: course.isActive,
      isPremium: course.isPremium,
      enrolledUsersCount: course.enrolledUsersCount,
      latestEnrolledUsers:
          course.latestEnrolledUsers
              .map(
                (learnWayUser) => User(
                  id: learnWayUser.id,
                  username: learnWayUser.username,
                  email: learnWayUser.email,
                  profileThumbnailUrl: learnWayUser.profileThumbnailUrl,
                  enrolledAt: learnWayUser.enrolledAt,
                ),
              )
              .toList(),
    );
    final currentUser = User(
      id: 'current-user-${course.id}',
      username: 'Current',
      email: 'current@user.com',
      profileThumbnailUrl: null,
      enrolledAt: course.enrolledAt,
    );

    return AdvancedRegisteredCourses(
      id: course.id,
      createdAt: course.createdAt,
      updatedAt: course.updatedAt,
      deletedAt: course.deletedAt,
      enrolledAt: course.enrolledAt!,
      completedAt: course.completedAt,
      progress: course.progress,
      course: advancedCourseModel,
      user: currentUser,
    );
  }

  static BaseRegisteredCourses<BaseCourseModel> toBaseRegisteredCourse(
    LearnWayCourses course,
    LevelType levelType,
  ) {
    switch (levelType) {
      case LevelType.beginner:
        return toBeginnerRegisteredCourse(course);
      case LevelType.intermediate:
        return toIntermediateRegisteredCourse(course);
      case LevelType.advanced:
        return toAdvancedRegisteredCourse(course);
    }
  }
}
