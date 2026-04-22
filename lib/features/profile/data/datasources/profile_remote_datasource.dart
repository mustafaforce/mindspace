import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';
import '../models/user_profile_model.dart';

class ProfileRemoteDataSource {
  const ProfileRemoteDataSource();

  Future<UserProfileModel?> fetchProfileByUserId(String userId) async {
    final profile = await SupabaseService.client
        .from('profiles')
        .select('id, full_name, email, avatar_url, bio')
        .eq('id', userId)
        .maybeSingle();

    if (profile == null) return null;
    return UserProfileModel.fromMap(profile);
  }

  Future<UserProfileModel> upsertProfile(UserProfileModel profile) async {
    final createdProfile = await SupabaseService.client
        .from('profiles')
        .upsert(profile.toUpsertMap())
        .select('id, full_name, email, avatar_url, bio')
        .single();

    return UserProfileModel.fromMap(createdProfile);
  }

  Future<void> syncUserMetadata(UserProfileModel profile) async {
    await SupabaseService.client.auth.updateUser(
      UserAttributes(
        data: {
          'full_name': profile.fullName.trim(),
          'avatar_url': profile.avatarUrl?.trim().isEmpty ?? true
              ? null
              : profile.avatarUrl?.trim(),
          'bio': profile.bio?.trim().isEmpty ?? true
              ? null
              : profile.bio?.trim(),
        },
      ),
    );
  }
}
