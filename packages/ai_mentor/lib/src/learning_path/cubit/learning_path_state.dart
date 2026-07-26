import '../models/learning_path_model.dart';
import '../models/path_course_model.dart';

enum LearningPathStatus { initial, loading, success, failure }

class LearningPathState {
  const LearningPathState({
    this.status = LearningPathStatus.initial,
    this.paths = const [],
    this.errorMessage,
    this.pathCoursesStatus = LearningPathStatus.initial,
    this.pathCourses = const [],
    this.pathCoursesError,
  });

  final LearningPathStatus status;
  final List<LearningPathModel> paths;
  final String? errorMessage;

  final LearningPathStatus pathCoursesStatus;
  final List<PathCourseModel> pathCourses;
  final String? pathCoursesError;

  LearningPathState copyWith({
    LearningPathStatus? status,
    List<LearningPathModel>? paths,
    String? errorMessage,
    LearningPathStatus? pathCoursesStatus,
    List<PathCourseModel>? pathCourses,
    String? pathCoursesError,
  }) {
    return LearningPathState(
      status: status ?? this.status,
      paths: paths ?? this.paths,
      errorMessage: errorMessage ?? this.errorMessage,
      pathCoursesStatus: pathCoursesStatus ?? this.pathCoursesStatus,
      pathCourses: pathCourses ?? this.pathCourses,
      pathCoursesError: pathCoursesError ?? this.pathCoursesError,
    );
  }
}
