class MoodQuestionResponse {
  final String id;
  final String userId;
  final String moodLogId;
  final String questionId;
  final int responseValue;
  final DateTime createdAt;

  const MoodQuestionResponse({
    required this.id,
    required this.userId,
    required this.moodLogId,
    required this.questionId,
    required this.responseValue,
    required this.createdAt,
  });

  MoodQuestionResponse copyWith({
    String? id,
    String? userId,
    String? moodLogId,
    String? questionId,
    int? responseValue,
    DateTime? createdAt,
  }) {
    return MoodQuestionResponse(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      moodLogId: moodLogId ?? this.moodLogId,
      questionId: questionId ?? this.questionId,
      responseValue: responseValue ?? this.responseValue,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}