class MoodQuestion {
  final String id;
  final String questionText;
  final int displayOrder;
  final String category;
  final bool isActive;

  const MoodQuestion({
    required this.id,
    required this.questionText,
    required this.displayOrder,
    required this.category,
    required this.isActive,
  });

  MoodQuestion copyWith({
    String? id,
    String? questionText,
    int? displayOrder,
    String? category,
    bool? isActive,
  }) {
    return MoodQuestion(
      id: id ?? this.id,
      questionText: questionText ?? this.questionText,
      displayOrder: displayOrder ?? this.displayOrder,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
    );
  }
}