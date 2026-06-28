import 'package:json_annotation/json_annotation.dart';

part 'enrollment.g.dart';

@JsonSerializable(explicitToJson: true)
class Enrollment {
  final User user;
  final Course course;
  final DateTime enrolledAt;
  final DateTime completedAt;
  final int progress;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime deletedAt;

  Enrollment({
    required this.user,
    required this.course,
    required this.enrolledAt,
    required this.completedAt,
    required this.progress,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) =>
      _$EnrollmentFromJson(json);
  Map<String, dynamic> toJson() => _$EnrollmentToJson(this);
}

@JsonSerializable(explicitToJson: true)
class User {
  final String username;
  final String email;
  final String password;
  final String salt;
  final bool isEmailVerified;
  final String emailVerificationToken;
  final String passwordResetToken;
  final DateTime passwordResetExpires;
  final int failedLoginAttempts;
  final DateTime accountLockedUntil;
  final DateTime lastLoginAt;
  final String emailOtp;
  final DateTime emailOtpExpires;
  final int emailOtpAttempts;
  final String country;
  final String referralCode;
  final String walletAddress;
  final String halfPrivateKey;
  final String signupProvider;
  final String role;
  final List<BattleParticipant> battleParticipants;
  final List<Contest> contests;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime deletedAt;

  User({
    required this.username,
    required this.email,
    required this.password,
    required this.salt,
    required this.isEmailVerified,
    required this.emailVerificationToken,
    required this.passwordResetToken,
    required this.passwordResetExpires,
    required this.failedLoginAttempts,
    required this.accountLockedUntil,
    required this.lastLoginAt,
    required this.emailOtp,
    required this.emailOtpExpires,
    required this.emailOtpAttempts,
    required this.country,
    required this.referralCode,
    required this.walletAddress,
    required this.halfPrivateKey,
    required this.signupProvider,
    required this.role,
    required this.battleParticipants,
    required this.contests,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BattleParticipant {
  final Battle battle;
  final String user;
  final int score;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime deletedAt;

  BattleParticipant({
    required this.battle,
    required this.user,
    required this.score,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory BattleParticipant.fromJson(Map<String, dynamic> json) =>
      _$BattleParticipantFromJson(json);
  Map<String, dynamic> toJson() => _$BattleParticipantToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Battle {
  final String type;
  final int maxParticipants;
  final int participantsCount;
  final List<String> battleParticipants;
  final List<Question> questions;
  final DateTime startedAt;
  final DateTime endedAt;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime deletedAt;

  Battle({
    required this.type,
    required this.maxParticipants,
    required this.participantsCount,
    required this.battleParticipants,
    required this.questions,
    required this.startedAt,
    required this.endedAt,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Battle.fromJson(Map<String, dynamic> json) => _$BattleFromJson(json);
  Map<String, dynamic> toJson() => _$BattleToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Question {
  final String question;
  final String type;
  final String purpose;
  final String note;
  final int level;
  final List<QuestionOption> options;
  final Lesson lesson;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime deletedAt;

  Question({
    required this.question,
    required this.type,
    required this.purpose,
    required this.note,
    required this.level,
    required this.options,
    required this.lesson,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}

@JsonSerializable()
class QuestionOption {
  final String option;
  final bool correct;
  final String question;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime deletedAt;

  QuestionOption({
    required this.option,
    required this.correct,
    required this.question,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) =>
      _$QuestionOptionFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionOptionToJson(this);
}

@JsonSerializable()
class Lesson {
  final String title;
  final int order;
  final String course;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime deletedAt;

  Lesson({
    required this.title,
    required this.order,
    required this.course,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
  Map<String, dynamic> toJson() => _$LessonToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Contest {
  final String title;
  final String description;
  final int maxParticipants;
  final int entryFee;
  final int participantCount;
  final bool active;
  final List<String> participants;
  final List<Question> questions;
  final DateTime startDate;
  final DateTime endDate;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime deletedAt;

  Contest({
    required this.title,
    required this.description,
    required this.maxParticipants,
    required this.entryFee,
    required this.participantCount,
    required this.active,
    required this.participants,
    required this.questions,
    required this.startDate,
    required this.endDate,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Contest.fromJson(Map<String, dynamic> json) =>
      _$ContestFromJson(json);
  Map<String, dynamic> toJson() => _$ContestToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Course {
  final String title;
  final String description;
  final String skillLevel;
  final bool isActive;
  final bool isPremium;
  final List<Lesson> lessons;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime deletedAt;

  Course({
    required this.title,
    required this.description,
    required this.skillLevel,
    required this.isActive,
    required this.isPremium,
    required this.lessons,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
  Map<String, dynamic> toJson() => _$CourseToJson(this);
}
