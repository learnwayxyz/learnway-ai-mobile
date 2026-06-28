import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/base_models/course_wrapper.dart';

String checkCourseLevelType() {
  if (locator.isRegistered<CourseDataWrapper>()) {
    return locator.get<CourseDataWrapper>().course.id;
  }
  return '';
}
