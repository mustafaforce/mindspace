import '../entities/mood_log.dart';
import '../entities/mood_question.dart';
import '../entities/mood_question_response.dart';
import '../entities/custom_mood_label.dart';

abstract class MoodRepository {
  // Mood Logs
  Future<MoodLog> createMoodLog({
    required int moodScore,
    required String moodLabel,
  });
  Future<List<MoodLog>> getMoodHistory({int limit = 30});
  Future<MoodLog?> getMoodById(String id);

  // Mood Questions
  Future<List<MoodQuestion>> getActiveQuestions();

  // Question Responses
  Future<void> saveQuestionResponses({
    required String moodLogId,
    required List<MoodQuestionResponse> responses,
  });

  // Custom Mood Labels
  Future<List<CustomMoodLabel>> getCustomMoodLabels();
  Future<void> saveCustomMoodLabel({
    required int moodScore,
    required String label,
  });
}