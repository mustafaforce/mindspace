class GuidedExercise {
  final String id;
  final String title;
  final String description;
  final String category;
  final int durationSeconds;
  final List<ExerciseStep> steps;
  final List<int>? targetMoodScores;
  final int displayOrder;
  final bool isActive;

  GuidedExercise({
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

  String get categoryIcon {
    switch (category) {
      case 'breathing':
        return '🌬️';
      case 'grounding':
        return '🌍';
      case 'gratitude':
        return '🙏';
      case 'cognitive':
        return '🧠';
      case 'body_scan':
        return '🧘';
      default:
        return '✨';
    }
  }

  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    if (seconds == 0) return '$minutes min';
    return '$minutes:${seconds.toString().padLeft(2, '0')} min';
  }
}

class ExerciseStep {
  final String instruction;
  final int durationSeconds;

  ExerciseStep({
    required this.instruction,
    required this.durationSeconds,
  });
}