import '../entities/mood_question.dart';
import '../repositories/mood_repository.dart';

class GetMoodQuestionsUseCase {
  final MoodRepository repository;

  GetMoodQuestionsUseCase(this.repository);

  Future<List<MoodQuestion>> call() {
    return repository.getActiveQuestions();
  }
}