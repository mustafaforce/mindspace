import '../../domain/entities/mood_log.dart';
import '../../domain/entities/mood_question.dart';
import '../../domain/entities/mood_question_response.dart';
import '../../domain/entities/custom_mood_label.dart';
import '../../domain/repositories/mood_repository.dart';
import '../datasources/mood_remote_datasource.dart';
import '../models/mood_question_response_model.dart';

class MoodRepositoryImpl implements MoodRepository {
  final MoodRemoteDataSource dataSource;

  MoodRepositoryImpl(this.dataSource);

  @override
  Future<MoodLog> createMoodLog({
    required int moodScore,
    required String moodLabel,
  }) {
    return dataSource.createMoodLog(
      moodScore: moodScore,
      moodLabel: moodLabel,
    );
  }

  @override
  Future<List<MoodLog>> getMoodHistory({int limit = 30}) {
    return dataSource.getMoodHistory(limit: limit);
  }

  @override
  Future<MoodLog?> getMoodById(String id) {
    return dataSource.getMoodById(id);
  }

  @override
  Future<List<MoodQuestion>> getActiveQuestions() {
    return dataSource.getActiveQuestions();
  }

  @override
  Future<void> saveQuestionResponses({
    required String moodLogId,
    required List<MoodQuestionResponse> responses,
  }) {
    final models = responses
        .map((r) => MoodQuestionResponseModel(
              id: r.id,
              userId: r.userId,
              moodLogId: moodLogId,
              questionId: r.questionId,
              responseValue: r.responseValue,
              createdAt: r.createdAt,
            ))
        .toList();

    return dataSource.saveQuestionResponses(
      moodLogId: moodLogId,
      responses: models,
    );
  }

  @override
  Future<List<CustomMoodLabel>> getCustomMoodLabels() async {
    final data = await dataSource.getCustomMoodLabels();
    return data
        .map((map) => CustomMoodLabel(
              id: map['id'] as String,
              userId: map['user_id'] as String,
              moodScore: map['mood_score'] as int,
              label: map['label'] as String,
              createdAt: DateTime.parse(map['created_at'] as String),
            ))
        .toList();
  }

  @override
  Future<void> saveCustomMoodLabel({
    required int moodScore,
    required String label,
  }) {
    return dataSource.saveCustomMoodLabel(
      moodScore: moodScore,
      label: label,
    );
  }
}