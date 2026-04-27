import '../entities/mood_log.dart';
import '../repositories/mood_repository.dart';

class GetMoodHistoryUseCase {
  final MoodRepository repository;

  GetMoodHistoryUseCase(this.repository);

  Future<List<MoodLog>> call({int limit = 30}) {
    return repository.getMoodHistory(limit: limit);
  }
}