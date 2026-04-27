import '../../domain/entities/mood_question.dart';

class MoodQuestionModel extends MoodQuestion {
  const MoodQuestionModel({
    required super.id,
    required super.questionText,
    required super.displayOrder,
    required super.category,
    required super.isActive,
  });

  factory MoodQuestionModel.fromMap(Map<String, dynamic> map) {
    return MoodQuestionModel(
      id: map['id'] as String,
      questionText: map['question_text'] as String,
      displayOrder: map['display_order'] as int,
      category: map['category'] as String,
      isActive: map['is_active'] as bool,
    );
  }
}