import '../entities/journal_entry.dart';

abstract class JournalRepository {
  Future<List<JournalEntry>> getJournalEntries({int limit = 30});
  Future<JournalEntry?> getJournalEntryById(String id);
  Future<JournalEntry> createJournalEntry({
    String? moodLogId,
    required String entryText,
    required String entryType,
    String? promptQuestion,
  });
  Future<JournalEntry> updateJournalEntry({
    required String id,
    required String entryText,
  });
  Future<void> deleteJournalEntry(String id);
}