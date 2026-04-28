import '../../domain/entities/guided_exercise.dart';

class GuidedExerciseModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final int durationSeconds;
  final List<dynamic> steps;
  final List<int>? targetMoodScores;
  final int displayOrder;
  final bool isActive;

  GuidedExerciseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.durationSeconds,
    required this.steps,
    this.targetMoodScores,
    required this.displayOrder,
    required this.isActive,
  });

  factory GuidedExerciseModel.fromJson(Map<String, dynamic> json) {
    return GuidedExerciseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      durationSeconds: json['duration_seconds'] as int,
      steps: json['steps'] as List<dynamic>,
      targetMoodScores: json['target_mood_scores'] != null
          ? List<int>.from(json['target_mood_scores'] as List)
          : null,
      displayOrder: json['display_order'] as int,
      isActive: json['is_active'] as bool,
    );
  }

  GuidedExercise toEntity() {
    return GuidedExercise(
      id: id,
      title: title,
      description: description,
      category: category,
      durationSeconds: durationSeconds,
      steps: steps.map((s) => ExerciseStep(
        instruction: s['instruction'] as String,
        durationSeconds: s['duration_seconds'] as int,
      )).toList(),
      targetMoodScores: targetMoodScores,
      displayOrder: displayOrder,
      isActive: isActive,
    );
  }
}