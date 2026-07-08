class CareerPathModel {
  CareerPathModel({
    required this.id,
    required this.careerGoal,
    required this.title,
    required this.description,
    required this.completionPercentage,
    required this.totalEstimatedWeeks,
    required this.generationStatus,
  });

  factory CareerPathModel.fromJson(Map<String, dynamic> json) =>
      CareerPathModel(
        id: json['id'] as String? ?? '',
        careerGoal: json['careerGoal'] as String? ?? '',
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        completionPercentage: (json['completionPercentage'] as num? ?? 0)
            .toInt(),
        totalEstimatedWeeks: json['totalEstimatedWeeks'] as int? ?? 0,
        generationStatus: json['generationStatus'] as String? ?? '',
      );

  final String id;
  final String careerGoal;
  final String title;
  final String description;
  final int completionPercentage;
  final int totalEstimatedWeeks;
  final String generationStatus;
}
