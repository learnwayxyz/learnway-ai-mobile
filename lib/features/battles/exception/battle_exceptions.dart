import 'package:core/core.dart';

class BattleExceptions extends Failure {
  BattleExceptions(super.message);

  factory BattleExceptions.network() =>
      BattleExceptions("Network error occurred");
  factory BattleExceptions.server() =>
      BattleExceptions("Server error occurred");
  factory BattleExceptions.unknown() =>
      BattleExceptions("An unknown error occurred");

  @override
  String toString() => 'BattleException: $message';
}
