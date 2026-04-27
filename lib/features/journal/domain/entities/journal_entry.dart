class JournalEntry {
  final String id;
  final String userId;
  final String? moodLogId;
  final String entryText;
  final String entryType;
  final String? promptQuestion;
  final DateTime createdAt;
  final DateTime updatedAt;

  const JournalEntry({
    required this.id,
    required this.userId,
    this.moodLogId,
    required this.entryText,
    required this.entryType,
    this.promptQuestion,
    required this.createdAt,
    required this.updatedAt,
  });

  JournalEntry copyWith({
    String? id,
    String? userId,
    String? moodLogId,
    String? entryText,
    String? entryType,
    String? promptQuestion,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      moodLogId: moodLogId ?? this.moodLogId,
      entryText: entryText ?? this.entryText,
      entryType: entryType ?? this.entryType,
      promptQuestion: promptQuestion ?? this.promptQuestion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}