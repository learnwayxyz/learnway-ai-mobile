// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enrollment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Enrollment _$EnrollmentFromJson(Map<String, dynamic> json) => Enrollment(
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  course: Course.fromJson(json['course'] as Map<String, dynamic>),
  enrolledAt: DateTime.parse(json['enrolledAt'] as String),
  completedAt: DateTime.parse(json['completedAt'] as String),
  progress: (json['progress'] as num).toInt(),
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt: DateTime.parse(json['deletedAt'] as String),
);

Map<String, dynamic> _$EnrollmentToJson(Enrollment instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'course': instance.course.toJson(),
      'enrolledAt': instance.enrolledAt.toIso8601String(),
      'completedAt': instance.completedAt.toIso8601String(),
      'progress': instance.progress,
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt.toIso8601String(),
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
  username: json['username'] as String,
  email: json['email'] as String,
  password: json['password'] as String,
  salt: json['salt'] as String,
  isEmailVerified: json['isEmailVerified'] as bool,
  emailVerificationToken: json['emailVerificationToken'] as String,
  passwordResetToken: json['passwordResetToken'] as String,
  passwordResetExpires: DateTime.parse(json['passwordResetExpires'] as String),
  failedLoginAttempts: (json['failedLoginAttempts'] as num).toInt(),
  accountLockedUntil: DateTime.parse(json['accountLockedUntil'] as String),
  lastLoginAt: DateTime.parse(json['lastLoginAt'] as String),
  emailOtp: json['emailOtp'] as String,
  emailOtpExpires: DateTime.parse(json['emailOtpExpires'] as String),
  emailOtpAttempts: (json['emailOtpAttempts'] as num).toInt(),
  country: json['country'] as String,
  referralCode: json['referralCode'] as String,
  walletAddress: json['walletAddress'] as String,
  halfPrivateKey: json['halfPrivateKey'] as String,
  signupProvider: json['signupProvider'] as String,
  role: json['role'] as String,
  battleParticipants: (json['battleParticipants'] as List<dynamic>)
      .map((e) => BattleParticipant.fromJson(e as Map<String, dynamic>))
      .toList(),
  contests: (json['contests'] as List<dynamic>)
      .map((e) => Contest.fromJson(e as Map<String, dynamic>))
      .toList(),
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt: DateTime.parse(json['deletedAt'] as String),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'username': instance.username,
  'email': instance.email,
  'password': instance.password,
  'salt': instance.salt,
  'isEmailVerified': instance.isEmailVerified,
  'emailVerificationToken': instance.emailVerificationToken,
  'passwordResetToken': instance.passwordResetToken,
  'passwordResetExpires': instance.passwordResetExpires.toIso8601String(),
  'failedLoginAttempts': instance.failedLoginAttempts,
  'accountLockedUntil': instance.accountLockedUntil.toIso8601String(),
  'lastLoginAt': instance.lastLoginAt.toIso8601String(),
  'emailOtp': instance.emailOtp,
  'emailOtpExpires': instance.emailOtpExpires.toIso8601String(),
  'emailOtpAttempts': instance.emailOtpAttempts,
  'country': instance.country,
  'referralCode': instance.referralCode,
  'walletAddress': instance.walletAddress,
  'halfPrivateKey': instance.halfPrivateKey,
  'signupProvider': instance.signupProvider,
  'role': instance.role,
  'battleParticipants': instance.battleParticipants
      .map((e) => e.toJson())
      .toList(),
  'contests': instance.contests.map((e) => e.toJson()).toList(),
  'id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'deletedAt': instance.deletedAt.toIso8601String(),
};

BattleParticipant _$BattleParticipantFromJson(Map<String, dynamic> json) =>
    BattleParticipant(
      battle: Battle.fromJson(json['battle'] as Map<String, dynamic>),
      user: json['user'] as String,
      score: (json['score'] as num).toInt(),
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: DateTime.parse(json['deletedAt'] as String),
    );

Map<String, dynamic> _$BattleParticipantToJson(BattleParticipant instance) =>
    <String, dynamic>{
      'battle': instance.battle.toJson(),
      'user': instance.user,
      'score': instance.score,
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt.toIso8601String(),
    };

Battle _$BattleFromJson(Map<String, dynamic> json) => Battle(
  type: json['type'] as String,
  maxParticipants: (json['maxParticipants'] as num).toInt(),
  participantsCount: (json['participantsCount'] as num).toInt(),
  battleParticipants: (json['battleParticipants'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  questions: (json['questions'] as List<dynamic>)
      .map((e) => Question.fromJson(e as Map<String, dynamic>))
      .toList(),
  startedAt: DateTime.parse(json['startedAt'] as String),
  endedAt: DateTime.parse(json['endedAt'] as String),
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt: DateTime.parse(json['deletedAt'] as String),
);

Map<String, dynamic> _$BattleToJson(Battle instance) => <String, dynamic>{
  'type': instance.type,
  'maxParticipants': instance.maxParticipants,
  'participantsCount': instance.participantsCount,
  'battleParticipants': instance.battleParticipants,
  'questions': instance.questions.map((e) => e.toJson()).toList(),
  'startedAt': instance.startedAt.toIso8601String(),
  'endedAt': instance.endedAt.toIso8601String(),
  'id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'deletedAt': instance.deletedAt.toIso8601String(),
};

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
  question: json['question'] as String,
  type: json['type'] as String,
  purpose: json['purpose'] as String,
  note: json['note'] as String,
  level: (json['level'] as num).toInt(),
  options: (json['options'] as List<dynamic>)
      .map((e) => QuestionOption.fromJson(e as Map<String, dynamic>))
      .toList(),
  lesson: Lesson.fromJson(json['lesson'] as Map<String, dynamic>),
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt: DateTime.parse(json['deletedAt'] as String),
);

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
  'question': instance.question,
  'type': instance.type,
  'purpose': instance.purpose,
  'note': instance.note,
  'level': instance.level,
  'options': instance.options.map((e) => e.toJson()).toList(),
  'lesson': instance.lesson.toJson(),
  'id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'deletedAt': instance.deletedAt.toIso8601String(),
};

QuestionOption _$QuestionOptionFromJson(Map<String, dynamic> json) =>
    QuestionOption(
      option: json['option'] as String,
      correct: json['correct'] as bool,
      question: json['question'] as String,
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: DateTime.parse(json['deletedAt'] as String),
    );

Map<String, dynamic> _$QuestionOptionToJson(QuestionOption instance) =>
    <String, dynamic>{
      'option': instance.option,
      'correct': instance.correct,
      'question': instance.question,
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt.toIso8601String(),
    };

Lesson _$LessonFromJson(Map<String, dynamic> json) => Lesson(
  title: json['title'] as String,
  order: (json['order'] as num).toInt(),
  course: json['course'] as String,
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt: DateTime.parse(json['deletedAt'] as String),
);

Map<String, dynamic> _$LessonToJson(Lesson instance) => <String, dynamic>{
  'title': instance.title,
  'order': instance.order,
  'course': instance.course,
  'id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'deletedAt': instance.deletedAt.toIso8601String(),
};

Contest _$ContestFromJson(Map<String, dynamic> json) => Contest(
  title: json['title'] as String,
  description: json['description'] as String,
  maxParticipants: (json['maxParticipants'] as num).toInt(),
  entryFee: (json['entryFee'] as num).toInt(),
  participantCount: (json['participantCount'] as num).toInt(),
  active: json['active'] as bool,
  participants: (json['participants'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  questions: (json['questions'] as List<dynamic>)
      .map((e) => Question.fromJson(e as Map<String, dynamic>))
      .toList(),
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt: DateTime.parse(json['deletedAt'] as String),
);

Map<String, dynamic> _$ContestToJson(Contest instance) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'maxParticipants': instance.maxParticipants,
  'entryFee': instance.entryFee,
  'participantCount': instance.participantCount,
  'active': instance.active,
  'participants': instance.participants,
  'questions': instance.questions.map((e) => e.toJson()).toList(),
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate.toIso8601String(),
  'id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'deletedAt': instance.deletedAt.toIso8601String(),
};

Course _$CourseFromJson(Map<String, dynamic> json) => Course(
  title: json['title'] as String,
  description: json['description'] as String,
  skillLevel: json['skillLevel'] as String,
  isActive: json['isActive'] as bool,
  isPremium: json['isPremium'] as bool,
  lessons: (json['lessons'] as List<dynamic>)
      .map((e) => Lesson.fromJson(e as Map<String, dynamic>))
      .toList(),
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt: DateTime.parse(json['deletedAt'] as String),
);

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'skillLevel': instance.skillLevel,
  'isActive': instance.isActive,
  'isPremium': instance.isPremium,
  'lessons': instance.lessons.map((e) => e.toJson()).toList(),
  'id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'deletedAt': instance.deletedAt.toIso8601String(),
};
