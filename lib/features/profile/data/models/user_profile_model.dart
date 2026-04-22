import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.email,
    required super.fullName,
    super.avatarUrl,
    super.bio,
  });

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      id: (map['id'] as String?) ?? '',
      email: (map['email'] as String?) ?? '',
      fullName: (map['full_name'] as String?) ?? '',
      avatarUrl: map['avatar_url'] as String?,
      bio: map['bio'] as String?,
    );
  }

  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      id: entity.id,
      email: entity.email,
      fullName: entity.fullName,
      avatarUrl: entity.avatarUrl,
      bio: entity.bio,
    );
  }

  Map<String, dynamic> toUpsertMap() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName.trim(),
      'avatar_url': _cleanOptional(avatarUrl),
      'bio': _cleanOptional(bio),
    };
  }

  static String? _cleanOptional(String? value) {
    final cleaned = value?.trim() ?? '';
    return cleaned.isEmpty ? null : cleaned;
  }
}
