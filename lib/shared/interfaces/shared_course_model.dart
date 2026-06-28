import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/registered_courses.dart';

abstract class CourseCompletion {
  DateTime? get completedAt;
  RegisteredCourseModel get course;
}
