class SubmitContestResponse {
  final String id;
  final ContestUser user;
  final ContestSubmittedData contest;
  final int score;
  final int timeTaken;
  final DateTime startedAt;
  final DateTime completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int rank;
  final int totalParticipants;

  SubmitContestResponse({
    required this.id,
    required this.user,
    required this.contest,
    required this.score,
    required this.timeTaken,
    required this.startedAt,
    required this.completedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.rank,
    required this.totalParticipants,
  });

  factory SubmitContestResponse.fromJson(Map<String, dynamic> json) {
    return SubmitContestResponse(
      id: json['id'] ?? '',
      user: ContestUser.fromJson(json['user'] ?? {}),
      contest: ContestSubmittedData.fromJson(json['contest'] ?? {}),
      score: json['score']?.toInt() ?? 0,
      timeTaken: json['timeTaken']?.toInt() ?? 0,
      startedAt: DateTime.parse(
        json['startedAt'] ?? DateTime.now().toIso8601String(),
      ),
      completedAt: DateTime.parse(
        json['completedAt'] ?? DateTime.now().toIso8601String(),
      ),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      rank: json['rank']?.toInt() ?? 0,
      totalParticipants: json['totalParticipants']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'contest': contest.toJson(),
      'score': score,
      'timeTaken': timeTaken,
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'rank': rank,
      'totalParticipants': totalParticipants,
    };
  }
}

class ContestUser {
  final String id;

  ContestUser({required this.id});

  factory ContestUser.fromJson(Map<String, dynamic> json) {
    return ContestUser(id: json['id'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}

class ContestSubmittedData {
  final String id;
  final String title;
  final String? description;

  ContestSubmittedData({
    required this.id,
    required this.title,
    this.description,
  });

  factory ContestSubmittedData.fromJson(Map<String, dynamic> json) {
    return ContestSubmittedData(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      if (description != null) 'description': description,
    };
  }
}
