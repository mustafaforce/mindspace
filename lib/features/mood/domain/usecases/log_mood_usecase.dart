import '../entities/mood_log.dart';
import '../entities/mood_question_response.dart';
import '../repositories/mood_repository.dart';

class LogMoodUseCase {
  final MoodRepository repository;

  LogMoodUseCase(this.repository);

  Future<MoodLog> call({
    required int moodScore,
    required String moodLabel,
    List<MoodQuestionResponse>? responses,
  }) async {
    final moodLog = await repository.createMoodLog(
      moodScore: moodScore,
      moodLabel: moodLabel,
    );

    if (responses != null && responses.isNotEmpty) {
      await repository.saveQuestionResponses(
        moodLogId: moodLog.id,
        responses: responses,
      );
    }

    return moodLog;
  }
}