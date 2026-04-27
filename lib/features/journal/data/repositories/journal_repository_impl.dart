import '../../domain/entities/journal_entry.dart';
import '../../domain/repositories/journal_repository.dart';
import '../datasources/journal_remote_datasource.dart';

class JournalRepositoryImpl implements JournalRepository {
  final JournalRemoteDataSource dataSource;

  JournalRepositoryImpl(this.dataSource);

  @override
  Future<List<JournalEntry>> getJournalEntries({int limit = 30}) {
    return dataSource.getJournalEntries(limit: limit);
  }

  @override
  Future<JournalEntry?> getJournalEntryById(String id) {
    return dataSource.getJournalEntryById(id);
  }

  @override
  Future<JournalEntry> createJournalEntry({
    String? moodLogId,
    required String entryText,
    required String entryType,
    String? promptQuestion,
  }) {
    return dataSource.createJournalEntry(
      moodLogId: moodLogId,
      entryText: entryText,
      entryType: entryType,
      promptQuestion: promptQuestion,
    );
  }

  @override
  Future<JournalEntry> updateJournalEntry({
    required String id,
    required String entryText,
  }) {
    return dataSource.updateJournalEntry(id: id, entryText: entryText);
  }

  @override
  Future<void> deleteJournalEntry(String id) {
    return dataSource.deleteJournalEntry(id);
  }
}