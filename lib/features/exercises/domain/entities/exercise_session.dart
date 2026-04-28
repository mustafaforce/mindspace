class ExerciseSession {
  final String id;
  final String userId;
  final String exerciseId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int? moodBefore;
  final int? moodAfter;
  final String? notes;
  final DateTime createdAt;

  ExerciseSession({
    required this.id,
    required this.userId,
    required this.exerciseId,
    required this.startedAt,
    this.completedAt,
    this.moodBefore,
    this.moodAfter,
    this.notes,
    required this.createdAt,
  });

  bool get isCompleted => completedAt != null;

  Duration get duration {
    final end = completedAt ?? DateTime.now();
    return end.difference(startedAt);
  }
}