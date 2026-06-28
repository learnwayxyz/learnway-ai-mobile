// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationResponse _$NotificationResponseFromJson(
  Map<String, dynamic> json,
) => NotificationResponse(
  notifications: (json['notifications'] as List<dynamic>)
      .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  offset: (json['offset'] as num).toInt(),
);

Map<String, dynamic> _$NotificationResponseToJson(
  NotificationResponse instance,
) => <String, dynamic>{
  'notifications': instance.notifications,
  'total': instance.total,
  'limit': instance.limit,
  'offset': instance.offset,
};

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      isRead: json['isRead'] as bool,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      deletedAt: json['deletedAt'] as String?,
      readAt: json['readAt'] as String?,
      sentAt: json['sentAt'] as String?,
      scheduledFor: json['scheduledFor'] as String?,
      errorMessage: json['errorMessage'] as String?,
      status: json['status'] as String,
      channels: (json['channels'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      retryCount: (json['retryCount'] as num?)?.toInt(),
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'type': instance.type,
      'isRead': instance.isRead,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'readAt': instance.readAt,
      'sentAt': instance.sentAt,
      'scheduledFor': instance.scheduledFor,
      'errorMessage': instance.errorMessage,
      'status': instance.status,
      'channels': instance.channels,
      'retryCount': instance.retryCount,
      'data': instance.data,
    };
