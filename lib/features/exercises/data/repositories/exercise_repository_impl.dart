import '../../domain/entities/guided_exercise.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../datasources/exercise_remote_datasource.dart';

class ExerciseRepositoryImpl implements ExerciseRepository {
  final ExerciseRemoteDatasource _datasource;

  ExerciseRepositoryImpl(this._datasource);

  @override
  Future<List<GuidedExercise>> getExercises() async {
    final models = await _datasource.getExercises();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<GuidedExercise?> getExerciseById(String id) async {
    final model = await _datasource.getExerciseById(id);
    return model?.toEntity();
  }

  @override
  Future<String> startSession(String exerciseId, int? moodBefore) async {
    return _datasource.startSession(exerciseId, moodBefore);
  }

  @override
  Future<void> completeSession(String sessionId, int? moodAfter, String? notes) async {
    return _datasource.completeSession(sessionId, moodAfter, notes);
  }
}