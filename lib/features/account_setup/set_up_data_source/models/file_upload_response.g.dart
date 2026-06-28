// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_upload_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileUploadResponse _$FileUploadResponseFromJson(Map<String, dynamic> json) =>
    FileUploadResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: FileData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FileUploadResponseToJson(FileUploadResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

FileData _$FileDataFromJson(Map<String, dynamic> json) => FileData(
  fileId: json['fileId'] as String,
  name: json['name'] as String,
  url: json['url'] as String,
  thumbnailUrl: json['thumbnailUrl'] as String,
  size: (json['size'] as num).toInt(),
  filePath: json['filePath'] as String,
  fileType: json['fileType'] as String,
);

Map<String, dynamic> _$FileDataToJson(FileData instance) => <String, dynamic>{
  'fileId': instance.fileId,
  'name': instance.name,
  'url': instance.url,
  'thumbnailUrl': instance.thumbnailUrl,
  'size': instance.size,
  'filePath': instance.filePath,
  'fileType': instance.fileType,
};
