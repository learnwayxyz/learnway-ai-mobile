class StartLessonResponse {
  final bool success;
  final DateTime timestamp;
  final StartLessonResponseData data;

  StartLessonResponse({
    required this.success,
    required this.timestamp,
    required this.data,
  });

  factory StartLessonResponse.fromJson(Map<String, dynamic> json) {
    return StartLessonResponse(
      success: json['success'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      data: StartLessonResponseData.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'timestamp': timestamp.toIso8601String(),
      'data': data.toJson(),
    };
  }
}

class StartLessonResponseData {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int progress;
  final int? score;
  final int? timeTaken;

  StartLessonResponseData({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.startedAt,
    this.completedAt,
    required this.progress,
    this.score,
    this.timeTaken,
  });

  factory StartLessonResponseData.fromJson(Map<String, dynamic> json) {
    return StartLessonResponseData(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] != null
          ? DateTime.tryParse(json['deletedAt'] as String)
          : null,
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'] as String)
          : null,
      progress: json['progress'] as int,
      score: json['score'] != null ? json['score'] as int : null,
      timeTaken: json['timeTaken'] != null ? json['timeTaken'] as int : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'progress': progress,
      'score': score,
      'timeTaken': timeTaken,
    };
  }
}
