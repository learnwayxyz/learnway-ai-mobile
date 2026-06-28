class BattleRoomParticipant {
  final String userId;
  final String role;
  final String username;
  final String? profileImageUrl;

  const BattleRoomParticipant({
    required this.userId,
    required this.role,
    required this.username,
    this.profileImageUrl,
  });

  factory BattleRoomParticipant.fromJson(Map<String, dynamic> json) {
    return BattleRoomParticipant(
      userId: json['userId'] as String,
      role: json['role'] as String,
      username: json['username'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }
}
