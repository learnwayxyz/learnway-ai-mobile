class LanguagePrefResponse {
  const LanguagePrefResponse({
    required this.success,
    required this.message,
    required this.preferredLanguage,
  });

  final bool success;
  final String message;
  final String preferredLanguage;

  factory LanguagePrefResponse.fromJson(Map<String, dynamic> json) {
    return LanguagePrefResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      preferredLanguage: json['data']['preferredLanguage'] as String,
    );
  }
}
