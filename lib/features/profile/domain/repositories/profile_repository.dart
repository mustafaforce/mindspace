import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getCurrentProfile();

  Future<void> updateCurrentProfile(UserProfile profile);
}
