import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:learnwayv2/app/app.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/bloc/registered_course_bloc.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/base_models/course_wrapper.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/learnway_courses.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';

bool checkEnrollmentAndRoute(
  BuildContext context,
  LearnWayCourses course,
  LevelType levelType,
) {
  final registeredCoursesBloc = locator.get<RegisteredCoursesBloc>();
  final currentState = registeredCoursesBloc.state;

  switch (levelType) {
    case LevelType.beginner:
      if (currentState is LoadedBeginnerRegisteredCourses) {
        final alreadyEnrolled = currentState.registeredCourses.any(
          (registeredCourse) => registeredCourse.course.id == course.id,
        );

        if (alreadyEnrolled) {
          final enrolledCourse = currentState.registeredCourses.firstWhere(
            (registeredCourse) => registeredCourse.course.id == course.id,
          );
          registerCourseData(enrolledCourse, LevelType.beginner);
          appRouter.push(LessonRoute(levelType: LevelType.beginner));
          return true;
        }
      }
      break;

    case LevelType.intermediate:
      if (currentState is LoadedIntermediateRegisteredCourses) {
        final alreadyEnrolled = currentState.registeredCourses.any(
          (registeredCourse) => registeredCourse.course.id == course.id,
        );

        if (alreadyEnrolled) {
          final enrolledCourse = currentState.registeredCourses.firstWhere(
            (registeredCourse) => registeredCourse.course.id == course.id,
          );
          registerCourseData(enrolledCourse, LevelType.intermediate);
          context.router.push(LessonRoute(levelType: LevelType.intermediate));
          return true;
        }
      }
      break;

    case LevelType.advanced:
      if (currentState is LoadedAdvancedRegisteredCourses) {
        final alreadyEnrolled = currentState.registeredCourses.any(
          (registeredCourse) => registeredCourse.course.id == course.id,
        );

        if (alreadyEnrolled) {
          final enrolledCourse = currentState.registeredCourses.firstWhere(
            (registeredCourse) => registeredCourse.course.id == course.id,
          );
          registerCourseData(enrolledCourse, LevelType.advanced);
          context.router.push(LessonRoute(levelType: LevelType.advanced));
          return true;
        }
      }
      break;
  }

  return false;
}
