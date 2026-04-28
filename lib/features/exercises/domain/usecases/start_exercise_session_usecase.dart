import '../repositories/exercise_repository.dart';

class StartExerciseSessionUseCase {
  final ExerciseRepository repository;

  StartExerciseSessionUseCase(this.repository);

  Future<String> call(String exerciseId, int? moodBefore) async {
    return repository.startSession(exerciseId, moodBefore);
  }
}

class CompleteExerciseSessionUseCase {
  final ExerciseRepository repository;

  CompleteExerciseSessionUseCase(this.repository);

  Future<void> call(String sessionId, int? moodAfter, String? notes) async {
    return repository.completeSession(sessionId, moodAfter, notes);
  }
}