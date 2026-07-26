///
class OfferedCoursesPayload {
  OfferedCoursesPayload({
    required this.userId,
    required this.goals,
    required this.experience,
    required this.topics,
  });
  final String userId;
  final List<String> goals;
  final String experience;
  final List<String> topics;

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'goals': goals,
      'experience': experience,
      'topics': topics,
    };
  }
}
