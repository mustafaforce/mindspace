class UserProfile {
  const UserProfile({
    required this.id,
    required this.email,
    required this.fullName,
    this.avatarUrl,
    this.bio,
  });

  final String id;
  final String email;
  final String fullName;
  final String? avatarUrl;
  final String? bio;

  UserProfile copyWith({
    String? id,
    String? email,
    String? fullName,
    String? avatarUrl,
    String? bio,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
    );
  }
}
