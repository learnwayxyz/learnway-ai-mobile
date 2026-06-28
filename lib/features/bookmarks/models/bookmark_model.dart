class BookmarkModel {
  final String id;
  final String title;
  final String author;
  final String question;
  final String description;
  final String? imageUrl;
  final DateTime createdAt;
  final String? lessonId;
  final String? courseId;

  const BookmarkModel({
    required this.id,
    required this.title,
    required this.author,
    required this.question,
    required this.description,
    this.imageUrl,
    required this.createdAt,
    this.lessonId,
    this.courseId,
  });

  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    return BookmarkModel(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      question: json['question'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lessonId: json['lessonId'] as String?,
      courseId: json['courseId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'question': question,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'lessonId': lessonId,
      'courseId': courseId,
    };
  }

  BookmarkModel copyWith({
    String? id,
    String? title,
    String? author,
    String? question,
    String? description,
    String? imageUrl,
    DateTime? createdAt,
    String? lessonId,
    String? courseId,
  }) {
    return BookmarkModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      question: question ?? this.question,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      lessonId: lessonId ?? this.lessonId,
      courseId: courseId ?? this.courseId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BookmarkModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
