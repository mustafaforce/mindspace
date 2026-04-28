class CustomMoodLabel {
  final String id;
  final String userId;
  final int moodScore;
  final String label;
  final DateTime createdAt;

  const CustomMoodLabel({
    required this.id,
    required this.userId,
    required this.moodScore,
    required this.label,
    required this.createdAt,
  });

  CustomMoodLabel copyWith({
    String? id,
    String? userId,
    int? moodScore,
    String? label,
    DateTime? createdAt,
  }) {
    return CustomMoodLabel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      moodScore: moodScore ?? this.moodScore,
      label: label ?? this.label,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}