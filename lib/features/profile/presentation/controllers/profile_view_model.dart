import 'package:flutter/foundation.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_current_profile_usecase.dart';
import '../../domain/usecases/update_current_profile_usecase.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({
    required GetCurrentProfileUseCase getCurrentProfileUseCase,
    required UpdateCurrentProfileUseCase updateCurrentProfileUseCase,
  }) : _getCurrentProfileUseCase = getCurrentProfileUseCase,
       _updateCurrentProfileUseCase = updateCurrentProfileUseCase;

  final GetCurrentProfileUseCase _getCurrentProfileUseCase;
  final UpdateCurrentProfileUseCase _updateCurrentProfileUseCase;

  bool isLoading = false;
  bool isSaving = false;
  String? error;
  UserProfile? profile;

  Future<void> loadProfile() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      profile = await _getCurrentProfileUseCase();
    } catch (_) {
      error = 'Failed to load profile. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveProfile({
    required String fullName,
    required String avatarUrl,
    required String bio,
  }) async {
    final current = profile;
    if (current == null) return false;

    isSaving = true;
    error = null;
    notifyListeners();

    final updated = current.copyWith(
      fullName: fullName.trim(),
      avatarUrl: avatarUrl.trim().isEmpty ? null : avatarUrl.trim(),
      bio: bio.trim().isEmpty ? null : bio.trim(),
    );

    try {
      await _updateCurrentProfileUseCase(updated);
      profile = updated;
      return true;
    } catch (_) {
      error = 'Failed to save profile. Please try again.';
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
