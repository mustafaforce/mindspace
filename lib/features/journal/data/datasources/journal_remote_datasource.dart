import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';
import '../models/journal_entry_model.dart';

class JournalRemoteDataSource {
  final SupabaseClient _client = SupabaseService.client;

  Future<List<JournalEntryModel>> getJournalEntries({int limit = 30}) async {
    final userId = _client.auth.currentUser!.id;

    final response = await _client
        .from('journal_entries')
        .select('*')
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(limit);

    return (response as List)
        .map((map) => JournalEntryModel.fromMap(map as Map<String, dynamic>))
        .toList();
  }

  Future<JournalEntryModel?> getJournalEntryById(String id) async {
    final response = await _client
        .from('journal_entries')
        .select('*')
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return JournalEntryModel.fromMap(response);
  }

  Future<JournalEntryModel> createJournalEntry({
    String? moodLogId,
    required String entryText,
    required String entryType,
    String? promptQuestion,
  }) async {
    final userId = _client.auth.currentUser!.id;

    final data = {
      'user_id': userId,
      'entry_text': entryText,
      'entry_type': entryType,
      if (moodLogId != null) 'mood_log_id': moodLogId,
      if (promptQuestion != null) 'prompt_question': promptQuestion,
    };

    final response = await _client
        .from('journal_entries')
        .insert(data)
        .select()
        .single();

    return JournalEntryModel.fromMap(response);
  }

  Future<JournalEntryModel> updateJournalEntry({
    required String id,
    required String entryText,
  }) async {
    final response = await _client
        .from('journal_entries')
        .update({'entry_text': entryText})
        .eq('id', id)
        .select()
        .single();

    return JournalEntryModel.fromMap(response);
  }

  Future<void> deleteJournalEntry(String id) async {
    await _client.from('journal_entries').delete().eq('id', id);
  }
}