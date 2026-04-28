import '../../domain/entities/exercise_session.dart';

class ExerciseSessionModel {
  final String id;
  final String userId;
  final String exerciseId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int? moodBefore;
  final int? moodAfter;
  final String? notes;
  final DateTime createdAt;

  ExerciseSessionModel({
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

  factory ExerciseSessionModel.fromJson(Map<String, dynamic> json) {
    return ExerciseSessionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      exerciseId: json['exercise_id'] as String,
      startedAt: DateTime.parse(json['started_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      moodBefore: json['mood_before'] as int?,
      moodAfter: json['mood_after'] as int?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  ExerciseSession toEntity() {
    return ExerciseSession(
      id: id,
      userId: userId,
      exerciseId: exerciseId,
      startedAt: startedAt,
      completedAt: completedAt,
      moodBefore: moodBefore,
      moodAfter: moodAfter,
      notes: notes,
      createdAt: createdAt,
    );
  }
}