class CareerRecommendation {
  const CareerRecommendation({
    required this.careerTitle,
    required this.matchScore,
    required this.description,
    required this.whyItFitsYou,
    this.relevantCourses = const [],
  });

  final String careerTitle;
  final int matchScore;
  final String description;
  final String whyItFitsYou;
  final List<String> relevantCourses;

  factory CareerRecommendation.fromJson(Map<String, dynamic> json) {
    return CareerRecommendation(
      careerTitle: json['careerTitle'] as String,
      matchScore: json['matchScore'] as int,
      description: json['description'] as String,
      whyItFitsYou: json['whyItFitsYou'] as String? ?? '',
      relevantCourses: (json['relevantCourses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}
