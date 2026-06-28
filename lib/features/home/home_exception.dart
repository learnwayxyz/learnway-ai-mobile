import 'package:core/core.dart';

class HomeFailure extends Failure {
  HomeFailure(super.message);

  factory HomeFailure.network() => HomeFailure("Network error occurred");
  factory HomeFailure.server() => HomeFailure("Server error occurred");
  factory HomeFailure.unknown() => HomeFailure("An unknown error occurred");

  @override
  String toString() => 'HomeFailure: $message';
}
