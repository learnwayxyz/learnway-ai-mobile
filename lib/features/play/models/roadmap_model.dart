class RoadmapCourse {
  RoadmapCourse({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
    required this.isPremium,
  });

  factory RoadmapCourse.fromJson(Map<String, dynamic> json) => RoadmapCourse(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        order: json['order'] as int? ?? 0,
        isPremium: json['isPremium'] as bool? ?? false,
      );

  final String id;
  final String title;
  final String description;
  final int order;
  final bool isPremium;
}

class RoadmapPath {
  RoadmapPath({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.order,
    required this.coverImageUrl,
    required this.courses,
  });

  factory RoadmapPath.fromJson(Map<String, dynamic> json) => RoadmapPath(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        type: json['type'] as String? ?? '',
        order: json['order'] as int? ?? 0,
        coverImageUrl: json['coverImageUrl'] as String?,
        courses: (json['courses'] as List<dynamic>? ?? [])
            .map((e) => RoadmapCourse.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  final String id;
  final String title;
  final String description;
  final String type;
  final int order;
  final String? coverImageUrl;
  final List<RoadmapCourse> courses;

  bool get hasPremiumCourse => courses.any((c) => c.isPremium);
}

class RoadmapModel {
  RoadmapModel({
    required this.status,
    required this.careerGoal,
    required this.paths,
    required this.totalCourses,
    required this.coursesCompleted,
    required this.requiresPremium,
    required this.userHasAccess,
  });

  factory RoadmapModel.fromJson(Map<String, dynamic> json) {
    final roadmap = json['roadmap'] as Map<String, dynamic>? ?? const {};
    final foundations = (roadmap['foundations'] as List<dynamic>? ?? [])
        .map((e) => RoadmapPath.fromJson(e as Map<String, dynamic>))
        .toList();
    final specializations = (roadmap['specializations'] as List<dynamic>? ?? [])
        .map((e) => RoadmapPath.fromJson(e as Map<String, dynamic>))
        .toList();
    final paths = [...foundations, ...specializations]
      ..sort((a, b) => a.order.compareTo(b.order));
    return RoadmapModel(
      status: json['status'] as String? ?? '',
      careerGoal: roadmap['careerGoal'] as String? ?? '',
      paths: paths,
      totalCourses: roadmap['totalCourses'] as int? ?? 0,
      coursesCompleted: roadmap['coursesCompleted'] as int? ?? 0,
      requiresPremium: roadmap['requiresPremium'] as bool? ?? false,
      userHasAccess: roadmap['userHasAccess'] as bool? ?? false,
    );
  }

  final String status;
  final String careerGoal;
  final List<RoadmapPath> paths;
  final int totalCourses;
  final int coursesCompleted;
  final bool requiresPremium;
  final bool userHasAccess;

  bool get isReady => status == 'completed';
}
