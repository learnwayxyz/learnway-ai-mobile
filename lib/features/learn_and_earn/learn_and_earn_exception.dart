import 'package:core/core.dart';

class LearnAndEarnFailure extends Failure {
  LearnAndEarnFailure(super.message);

  factory LearnAndEarnFailure.network() =>
      LearnAndEarnFailure("Network error occurred");
  factory LearnAndEarnFailure.server() =>
      LearnAndEarnFailure("Server error occurred");
  factory LearnAndEarnFailure.unknown() =>
      LearnAndEarnFailure("An unknown error occurred");

  @override
  String toString() => 'HomeFailure: $message';
}

class AiTutorLessonLimitFailure extends LearnAndEarnFailure {
  AiTutorLessonLimitFailure()
      : super('You have reached the AI request limit for this lesson.');
}

class AiTutorDailyLimitFailure extends LearnAndEarnFailure {
  AiTutorDailyLimitFailure()
      : super(
          'You have reached your daily AI request limit. Resets at midnight.',
        );
}
