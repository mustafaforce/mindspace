import '../entities/journal_entry.dart';
import '../repositories/journal_repository.dart';

class CreateJournalEntryUseCase {
  final JournalRepository repository;

  CreateJournalEntryUseCase(this.repository);

  Future<JournalEntry> call({
    String? moodLogId,
    required String entryText,
    required String entryType,
    String? promptQuestion,
  }) {
    return repository.createJournalEntry(
      moodLogId: moodLogId,
      entryText: entryText,
      entryType: entryType,
      promptQuestion: promptQuestion,
    );
  }
}