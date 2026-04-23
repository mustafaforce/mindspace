import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

class MockProfileRepository implements ProfileRepository {
  const MockProfileRepository();

  static final UserProfile _profile = UserProfile(
    id: 'mock-user-id',
    email: 'demo@mindspace.app',
    fullName: 'Demo User',
    avatarUrl: null,
    bio: 'This is a demo bio for the Mind Space app.',
  );

  @override
  Future<UserProfile> getCurrentProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _profile;
  }

  @override
  Future<void> updateCurrentProfile(UserProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _profile.copyWith(
      fullName: profile.fullName,
      avatarUrl: profile.avatarUrl,
      bio: profile.bio,
    );
  }
}
