class LeaderboardUser {
  LeaderboardUser({
    required this.rank,
    required this.name,
    required this.score,
    required this.avatar,
    this.isCurrentUser = false,
    required this.xp,
  });

  final int rank;
  final String name;
  final int score;
  final String avatar;
  final bool isCurrentUser;
  final String xp;
}
