import '../../domain/entities/mood_question_response.dart';

class MoodQuestionResponseModel extends MoodQuestionResponse {
  const MoodQuestionResponseModel({
    required super.id,
    required super.userId,
    required super.moodLogId,
    required super.questionId,
    required super.responseValue,
    required super.createdAt,
  });

  factory MoodQuestionResponseModel.fromMap(Map<String, dynamic> map) {
    return MoodQuestionResponseModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      moodLogId: map['mood_log_id'] as String,
      questionId: map['question_id'] as String,
      responseValue: map['response_value'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toInsertMap() {
    return {
      'mood_log_id': moodLogId,
      'question_id': questionId,
      'response_value': responseValue,
    };
  }
}