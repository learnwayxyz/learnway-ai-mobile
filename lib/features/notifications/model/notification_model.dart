import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationResponse {
  NotificationResponse({
    required this.notifications,
    required this.total,
    required this.limit,
    required this.offset,
  });

  final List<NotificationModel> notifications;
  final int total;
  final int limit;
  final int offset;

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationResponseToJson(this);
}

@JsonSerializable()
class NotificationModel {
  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.readAt,
    this.sentAt,
    this.scheduledFor,
    this.errorMessage,
    required this.status,
    required this.channels,
    this.retryCount,
    this.data,
  });

  final String id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String? readAt;
  final String? sentAt;
  final String? scheduledFor;
  final String? errorMessage;
  final String status;
  final List<String> channels;
  final int? retryCount;
  final Map<String, dynamic>? data;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    bool? isRead,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
    String? readAt,
    String? sentAt,
    String? scheduledFor,
    String? errorMessage,
    String? status,
    List<String>? channels,
    int? retryCount,
    Map<String, dynamic>? data,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      readAt: readAt ?? this.readAt,
      sentAt: sentAt ?? this.sentAt,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      channels: channels ?? this.channels,
      retryCount: retryCount ?? this.retryCount,
      data: data ?? this.data,
    );
  }
}
