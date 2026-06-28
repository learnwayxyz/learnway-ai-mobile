class SubmitQuizResponse {
  SubmitQuizResponse({
    required this.id,
    required this.user,
    required this.lesson,
    required this.course,
    required this.score,
    required this.timeTaken,
    required this.startedAt,
    required this.completedAt,
    required this.createdAt,
    required this.updatedAt,
    this.dailyLessonsRemaining,
    required this.doubleGemsApplied,
  });

  final String id;
  final QuizUser user;
  final QuizLesson lesson;
  final QuizCourse course;
  final int score;
  final int timeTaken;
  final DateTime startedAt;
  final DateTime completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? dailyLessonsRemaining;
  final bool doubleGemsApplied;

  factory SubmitQuizResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final lessonRecord = data['lesson'] as Map<String, dynamic>? ?? data;
    return SubmitQuizResponse(
      id: lessonRecord['id'] ?? '',
      user: QuizUser.fromJson(lessonRecord['user'] ?? {}),
      lesson: QuizLesson.fromJson(lessonRecord['lesson'] ?? {}),
      course: QuizCourse.fromJson(lessonRecord['course'] ?? {}),
      score: lessonRecord['score']?.toInt() ?? 0,
      timeTaken: lessonRecord['timeTaken']?.toInt() ?? 0,
      startedAt: DateTime.parse(
        lessonRecord['startedAt'] ?? DateTime.now().toIso8601String(),
      ),
      completedAt: DateTime.parse(
        lessonRecord['completedAt'] ?? DateTime.now().toIso8601String(),
      ),
      createdAt: DateTime.parse(
        lessonRecord['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        lessonRecord['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      dailyLessonsRemaining: data['dailyLessonsRemaining'] as int?,
      doubleGemsApplied: data['doubleGemsApplied'] as bool? ?? false,
    );
  }
}

class QuizUser {
  final String id;

  QuizUser({required this.id});

  factory QuizUser.fromJson(Map<String, dynamic> json) {
    return QuizUser(id: json['id'] ?? '');
  }
}

class QuizLesson {
  final String id;

  QuizLesson({required this.id});

  factory QuizLesson.fromJson(Map<String, dynamic> json) {
    return QuizLesson(id: json['id'] ?? '');
  }
}

class QuizCourse {
  final String id;

  QuizCourse({required this.id});

  factory QuizCourse.fromJson(Map<String, dynamic> json) {
    return QuizCourse(id: json['id'] ?? '');
  }
}
