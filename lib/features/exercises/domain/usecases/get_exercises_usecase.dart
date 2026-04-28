import '../entities/guided_exercise.dart';
import '../repositories/exercise_repository.dart';

class GetExercisesUseCase {
  final ExerciseRepository repository;

  GetExercisesUseCase(this.repository);

  Future<List<GuidedExercise>> call() async {
    return repository.getExercises();
  }
}

class GetExerciseByIdUseCase {
  final ExerciseRepository repository;

  GetExerciseByIdUseCase(this.repository);

  Future<GuidedExercise?> call(String id) async {
    return repository.getExerciseById(id);
  }
}