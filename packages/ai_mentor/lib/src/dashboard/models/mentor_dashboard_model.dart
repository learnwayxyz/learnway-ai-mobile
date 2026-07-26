class MentorDashboardModel {
  const MentorDashboardModel({
    required this.profile,
    required this.recentInsights,
    required this.learnerStats,
  });

  factory MentorDashboardModel.fromJson(Map<String, dynamic> json) {
    return MentorDashboardModel(
      profile: MentorProfile.fromJson(
        json['profile'] as Map<String, dynamic>? ?? const {},
      ),
      recentInsights: (json['recentInsights'] as List<dynamic>? ?? const [])
          .map((e) => MentorInsight.fromJson(e as Map<String, dynamic>))
          .toList(),
      learnerStats: LearnerStats.fromJson(
        json['learnerStats'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }

  final MentorProfile profile;
  final List<MentorInsight> recentInsights;
  final LearnerStats learnerStats;
}

class MentorProfile {
  const MentorProfile({
    required this.careerGoal,
    required this.consistencyScore,
    required this.engagementScore,
    required this.employabilityScore,
    required this.strengths,
    required this.weakAreas,
  });

  factory MentorProfile.fromJson(Map<String, dynamic> json) {
    return MentorProfile(
      careerGoal: json['careerGoal'] as String? ?? '',
      consistencyScore: (json['consistencyScore'] as num?)?.toInt() ?? 0,
      engagementScore: (json['engagementScore'] as num?)?.toInt() ?? 0,
      employabilityScore: (json['employabilityScore'] as num?)?.toInt() ?? 0,
      strengths: (json['strengths'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      weakAreas: (json['weakAreas'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  final String careerGoal;
  final int consistencyScore;
  final int engagementScore;
  final int employabilityScore;
  final List<String> strengths;
  final List<String> weakAreas;
}

class MentorInsight {
  const MentorInsight({
    required this.type,
    required this.title,
    required this.description,
  });

  factory MentorInsight.fromJson(Map<String, dynamic> json) {
    return MentorInsight(
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  final String type;
  final String title;
  final String description;
}

class LearnerStats {
  const LearnerStats({
    required this.username,
    required this.country,
    required this.totalXP,
    required this.totalGems,
    required this.currentStreak,
    required this.longestStreak,
    required this.userLevel,
    required this.lessonsCompleted,
    required this.totalTimeSpentMinutes,
    required this.quizAvgScore,
    required this.activeCourses,
    required this.totalBattlesWon,
    required this.totalContestsWon,
  });

  factory LearnerStats.fromJson(Map<String, dynamic> json) {
    return LearnerStats(
      username: json['username'] as String? ?? '',
      country: json['country'] as String? ?? '',
      totalXP: (json['totalXP'] as num?)?.toInt() ?? 0,
      totalGems: (json['totalGems'] as num?)?.toInt() ?? 0,
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
      userLevel: (json['userLevel'] as num?)?.toInt() ?? 0,
      lessonsCompleted: (json['lessonsCompleted'] as num?)?.toInt() ?? 0,
      totalTimeSpentMinutes:
          (json['totalTimeSpentMinutes'] as num?)?.toInt() ?? 0,
      quizAvgScore: (json['quizAvgScore'] as num?)?.toDouble() ?? 0,
      activeCourses: (json['activeCourses'] as List<dynamic>? ?? const [])
          .map((e) => ActiveCourse.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalBattlesWon: (json['totalBattlesWon'] as num?)?.toInt() ?? 0,
      totalContestsWon: (json['totalContestsWon'] as num?)?.toInt() ?? 0,
    );
  }

  final String username;
  final String country;
  final int totalXP;
  final int totalGems;
  final int currentStreak;
  final int longestStreak;
  final int userLevel;
  final int lessonsCompleted;
  final int totalTimeSpentMinutes;
  final double quizAvgScore;
  final List<ActiveCourse> activeCourses;
  final int totalBattlesWon;
  final int totalContestsWon;

  int get completedCourses =>
      activeCourses.where((c) => c.isCompleted).length;

  int get totalCourses => activeCourses.length;
}

class ActiveCourse {
  const ActiveCourse({
    required this.title,
    required this.progressPercent,
    required this.isCompleted,
  });

  factory ActiveCourse.fromJson(Map<String, dynamic> json) {
    final progress = (json['progress'] as num?)?.toDouble() ??
        (json['progressPercent'] as num?)?.toDouble() ??
        0;
    return ActiveCourse(
      title: json['title'] as String? ?? json['courseTitle'] as String? ?? '',
      progressPercent: progress,
      isCompleted: json['completed'] as bool? ??
          json['isCompleted'] as bool? ??
          progress >= 100,
    );
  }

  final String title;
  final double progressPercent;
  final bool isCompleted;
}
