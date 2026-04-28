import 'mood_question_response.dart';

class MoodLog {
  final String id;
  final String userId;
  final int moodScore;
  final String moodLabel;
  final DateTime createdAt;
  final List<MoodQuestionResponse>? responses;

  const MoodLog({
    required this.id,
    required this.userId,
    required this.moodScore,
    required this.moodLabel,
    required this.createdAt,
    this.responses,
  });

  MoodLog copyWith({
    String? id,
    String? userId,
    int? moodScore,
    String? moodLabel,
    DateTime? createdAt,
    List<MoodQuestionResponse>? responses,
  }) {
    return MoodLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      moodScore: moodScore ?? this.moodScore,
      moodLabel: moodLabel ?? this.moodLabel,
      createdAt: createdAt ?? this.createdAt,
      responses: responses ?? this.responses,
    );
  }
}