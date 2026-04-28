import 'package:flutter/material.dart';
import '../controllers/exercise_view_model.dart';
import '../widgets/exercise_card.dart';
import '../../../../core/services/navigation_service.dart';

class ExerciseListScreen extends StatefulWidget {
  const ExerciseListScreen({super.key});

  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  final ExerciseViewModel _viewModel = ExerciseViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.loadExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guided Exercises'),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_viewModel.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${_viewModel.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _viewModel.loadExercises(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (_viewModel.exercises.isEmpty) {
            return const Center(
              child: Text('No exercises available'),
            );
          }

          final grouped = <String, List<dynamic>>{};
          for (final exercise in _viewModel.exercises) {
            grouped.putIfAbsent(exercise.category, () => []).add(exercise);
          }

          return ListView(
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            children: grouped.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      _capitalizeCategory(entry.key),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ...entry.value.map((exercise) => ExerciseCard(
                    exercise: exercise,
                    onTap: () {
                      _viewModel.selectExercise(exercise);
                      NavigationService.instance.pushNamed('/exercises/${exercise.id}');
                    },
                  )),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }

  String _capitalizeCategory(String category) {
    return category[0].toUpperCase() + category.substring(1).replaceAll('_', ' ');
  }
}