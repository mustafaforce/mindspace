import '../entities/guided_exercise.dart';

abstract class ExerciseRepository {
  Future<List<GuidedExercise>> getExercises();
  Future<GuidedExercise?> getExerciseById(String id);
  Future<String> startSession(String exerciseId, int? moodBefore);
  Future<void> completeSession(String sessionId, int? moodAfter, String? notes);
}