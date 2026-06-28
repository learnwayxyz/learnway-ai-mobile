import 'package:core/core.dart';

class CoinMarketCapException extends Failure {
  CoinMarketCapException(super.message);

  factory CoinMarketCapException.network() =>
      CoinMarketCapException("Network error occurred");
  factory CoinMarketCapException.server() =>
      CoinMarketCapException("Server error occurred");
  factory CoinMarketCapException.unknown() =>
      CoinMarketCapException("An unknown error occurred");

  @override
  String toString() => 'CoinMarketCapException: $message';
}
