import 'package:json_annotation/json_annotation.dart';

part 'file_upload_response.g.dart';

@JsonSerializable()
class FileUploadResponse {
  final bool success;
  final String message;
  final FileData data;

  FileUploadResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory FileUploadResponse.fromJson(Map<String, dynamic> json) =>
      _$FileUploadResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FileUploadResponseToJson(this);
}

@JsonSerializable()
class FileData {
  final String fileId;
  final String name;
  final String url;
  final String thumbnailUrl;
  final int size;
  final String filePath;
  final String fileType;

  FileData({
    required this.fileId,
    required this.name,
    required this.url,
    required this.thumbnailUrl,
    required this.size,
    required this.filePath,
    required this.fileType,
  });

  factory FileData.fromJson(Map<String, dynamic> json) =>
      _$FileDataFromJson(json);

  Map<String, dynamic> toJson() => _$FileDataToJson(this);
}
