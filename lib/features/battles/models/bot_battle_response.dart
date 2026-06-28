class BotBattleResponse {
  const BotBattleResponse({
    required this.battleId,
    this.roomCode,
    required this.status,
    required this.stakeAmount,
    required this.prizePool,
    required this.adminFeeGems,
    required this.botName,
  });

  final String battleId;
  final String? roomCode;
  final String status;
  final int stakeAmount;
  final int prizePool;
  final int adminFeeGems;
  final String botName;

  factory BotBattleResponse.fromJson(Map<String, dynamic> json) {
    return BotBattleResponse(
      battleId: json['battleId'] as String,
      roomCode: json['roomCode'] as String?,
      status: json['status'] as String,
      stakeAmount: json['stakeAmount'] as int,
      prizePool: json['prizePool'] as int,
      adminFeeGems: json['adminFeeGems'] as int,
      botName: json['botName'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'battleId': battleId,
    'roomCode': roomCode,
    'status': status,
    'stakeAmount': stakeAmount,
    'prizePool': prizePool,
    'adminFeeGems': adminFeeGems,
    'botName': botName,
  };
}
