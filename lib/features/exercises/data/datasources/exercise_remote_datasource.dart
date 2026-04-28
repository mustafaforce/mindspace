import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/guided_exercise_model.dart';

class ExerciseRemoteDatasource {
  final SupabaseClient _client = SupabaseService.client;

  Future<List<GuidedExerciseModel>> getExercises() async {
    final response = await _client
        .from('guided_exercises')
        .select()
        .eq('is_active', true)
        .order('display_order');

    return (response as List)
        .map((json) => GuidedExerciseModel.fromJson(json))
        .toList();
  }

  Future<GuidedExerciseModel?> getExerciseById(String id) async {
    final response = await _client
        .from('guided_exercises')
        .select()
        .eq('id', id)
        .single();

    return GuidedExerciseModel.fromJson(response);
  }

  Future<String> startSession(String exerciseId, int? moodBefore) async {
    final response = await _client.from('exercise_sessions').insert({
      'exercise_id': exerciseId,
      'mood_before': moodBefore,
    }).select('id').single();

    return response['id'] as String;
  }

  Future<void> completeSession(String sessionId, int? moodAfter, String? notes) async {
    await _client.from('exercise_sessions').update({
      'completed_at': DateTime.now().toIso8601String(),
      'mood_after': moodAfter,
      'notes': notes,
    }).eq('id', sessionId);
  }
}