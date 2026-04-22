import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/user_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<UserProfile> getCurrentProfile() async {
    final user = SupabaseService.client.auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found.');
    }

    final existing = await _remoteDataSource.fetchProfileByUserId(user.id);
    if (existing != null) return existing;

    final fallback = UserProfileModel(
      id: user.id,
      email: user.email ?? '',
      fullName: (user.userMetadata?['full_name'] as String?) ?? '',
      avatarUrl: user.userMetadata?['avatar_url'] as String?,
      bio: user.userMetadata?['bio'] as String?,
    );

    return _remoteDataSource.upsertProfile(fallback);
  }

  @override
  Future<void> updateCurrentProfile(UserProfile profile) async {
    final user = SupabaseService.client.auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found.');
    }

    final profileModel = UserProfileModel(
      id: user.id,
      email: user.email ?? profile.email,
      fullName: profile.fullName,
      avatarUrl: profile.avatarUrl,
      bio: profile.bio,
    );

    await _remoteDataSource.upsertProfile(profileModel);
    await _remoteDataSource.syncUserMetadata(profileModel);
  }
}
