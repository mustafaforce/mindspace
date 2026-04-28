import '../../domain/entities/mood_log.dart';
import 'mood_question_response_model.dart';

class MoodLogModel extends MoodLog {
  const MoodLogModel({
    required super.id,
    required super.userId,
    required super.moodScore,
    required super.moodLabel,
    required super.createdAt,
    super.responses,
  });

  factory MoodLogModel.fromMap(Map<String, dynamic> map) {
    List<MoodQuestionResponseModel>? responses;
    if (map['mood_question_responses'] != null) {
      responses = (map['mood_question_responses'] as List)
          .map((r) => MoodQuestionResponseModel.fromMap(r as Map<String, dynamic>))
          .toList();
    }

    return MoodLogModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      moodScore: map['mood_score'] as int,
      moodLabel: map['mood_label'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      responses: responses,
    );
  }

  Map<String, dynamic> toInsertMap() {
    return {
      'mood_score': moodScore,
      'mood_label': moodLabel,
    };
  }
}