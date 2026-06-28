class LessonProgressResponse {
  final bool success;
  final String message;
  final List<LessonProgress> data;

  LessonProgressResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LessonProgressResponse.fromJson(Map<String, dynamic> json) {
    return LessonProgressResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => LessonProgress.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class LessonProgress {
  final String id;
  final LessonProgressUser user;
  final Lesson lesson;
  final CourseProgress course;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  LessonProgress({
    required this.id,
    required this.user,
    required this.lesson,
    required this.course,
    this.startedAt,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LessonProgress.fromJson(Map<String, dynamic> json) {
    return LessonProgress(
      id: json['id'],
      user: LessonProgressUser.fromJson(json['user']),
      lesson: Lesson.fromJson(json['lesson']),
      course: CourseProgress.fromJson(json['course']),
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'])
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'lesson': lesson.toJson(),
      'course': course.toJson(),
      'startedAt': startedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class LessonProgressUser {
  final String id;

  LessonProgressUser({required this.id});

  factory LessonProgressUser.fromJson(Map<String, dynamic> json) {
    return LessonProgressUser(id: json['id']);
  }

  Map<String, dynamic> toJson() => {'id': id};
}

class Lesson {
  final String id;
  final String title;
  final int order;
  final DateTime createdAt;
  final DateTime updatedAt;

  Lesson({
    required this.id,
    required this.title,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      order: json['order'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'order': order,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class CourseProgress {
  final String id;

  CourseProgress({required this.id});

  factory CourseProgress.fromJson(Map<String, dynamic> json) {
    return CourseProgress(id: json['id']);
  }

  Map<String, dynamic> toJson() => {'id': id};
}
