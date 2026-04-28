import '../../domain/entities/journal_entry.dart';

class JournalEntryModel extends JournalEntry {
  const JournalEntryModel({
    required super.id,
    required super.userId,
    super.moodLogId,
    required super.entryText,
    required super.entryType,
    super.promptQuestion,
    required super.createdAt,
    required super.updatedAt,
  });

  factory JournalEntryModel.fromMap(Map<String, dynamic> map) {
    return JournalEntryModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      moodLogId: map['mood_log_id'] as String?,
      entryText: map['entry_text'] as String,
      entryType: map['entry_type'] as String,
      promptQuestion: map['prompt_question'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toInsertMap() {
    return {
      'entry_text': entryText,
      'entry_type': entryType,
      if (moodLogId != null) 'mood_log_id': moodLogId,
      if (promptQuestion != null) 'prompt_question': promptQuestion,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'entry_text': entryText,
    };
  }
}