import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/config/env_config.dart';
import '../../../../core/services/supabase_service.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return SupabaseService.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUp({
    required String fullName,
    required String email,
    required String password,
  }) {
    return SupabaseService.client.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: EnvConfig.supabaseEmailRedirectTo,
      data: {'full_name': fullName},
    );
  }
}
