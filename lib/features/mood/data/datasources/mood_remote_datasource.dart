import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';
import '../models/mood_log_model.dart';
import '../models/mood_question_model.dart';
import '../models/mood_question_response_model.dart';

class MoodRemoteDataSource {
  final SupabaseClient _client = SupabaseService.client;

  // Create a new mood log
  Future<MoodLogModel> createMoodLog({
    required int moodScore,
    required String moodLabel,
  }) async {
    final userId = _client.auth.currentUser!.id;

    final response = await _client.from('mood_logs').insert({
      'user_id': userId,
      'mood_score': moodScore,
      'mood_label': moodLabel,
    }).select().single();

    return MoodLogModel.fromMap(response);
  }

  // Get mood history for current user
  Future<List<MoodLogModel>> getMoodHistory({int limit = 30}) async {
    final userId = _client.auth.currentUser!.id;

    final response = await _client
        .from('mood_logs')
        .select('*, mood_question_responses(*)')
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(limit);

    return (response as List)
        .map((map) => MoodLogModel.fromMap(map as Map<String, dynamic>))
        .toList();
  }

  // Get a single mood log by ID
  Future<MoodLogModel?> getMoodById(String id) async {
    final response = await _client
        .from('mood_logs')
        .select('*, mood_question_responses(*)')
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return MoodLogModel.fromMap(response);
  }

  // Get active mood questions (the 7 predefined)
  Future<List<MoodQuestionModel>> getActiveQuestions() async {
    final response = await _client
        .from('mood_questions')
        .select('*')
        .eq('is_active', true)
        .order('display_order', ascending: true);

    return (response as List)
        .map((map) => MoodQuestionModel.fromMap(map as Map<String, dynamic>))
        .toList();
  }

  // Save question responses for a mood log
  Future<void> saveQuestionResponses({
    required String moodLogId,
    required List<MoodQuestionResponseModel> responses,
  }) async {
    final userId = _client.auth.currentUser!.id;

    final inserts = responses.map((r) => {
      'user_id': userId,
      'mood_log_id': moodLogId,
      'question_id': r.questionId,
      'response_value': r.responseValue,
    }).toList();

    await _client.from('mood_question_responses').insert(inserts);
  }

  // Get custom mood labels for current user
  Future<List<Map<String, dynamic>>> getCustomMoodLabels() async {
    final userId = _client.auth.currentUser!.id;

    final response = await _client
        .from('custom_mood_labels')
        .select('*')
        .eq('user_id', userId);

    return (response as List).cast<Map<String, dynamic>>();
  }

  // Save/update a custom mood label
  Future<void> saveCustomMoodLabel({
    required int moodScore,
    required String label,
  }) async {
    final userId = _client.auth.currentUser!.id;

    await _client.from('custom_mood_labels').upsert({
      'user_id': userId,
      'mood_score': moodScore,
      'label': label,
    });
  }
}