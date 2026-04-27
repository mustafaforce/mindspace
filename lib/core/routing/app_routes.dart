import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/signup_screen.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/journal/presentation/pages/journal_screen.dart';
import '../../features/journal/presentation/pages/journal_entry_screen.dart';
import '../../features/mood/presentation/pages/mood_logger_screen.dart';
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/usecases/get_current_profile_usecase.dart';
import '../../features/profile/domain/usecases/update_current_profile_usecase.dart';
import '../../features/profile/presentation/controllers/profile_view_model.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String home = '/home';
  static const String moodLog = '/mood-log';
  static const String journal = '/journal';
  static const String journalNew = '/journal/new';
  static const String journalEdit = '/journal/edit';
  static const String profile = '/profile';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case signUp:
        return MaterialPageRoute<void>(
          builder: (_) => const SignUpScreen(),
          settings: settings,
        );
      case home:
        return MaterialPageRoute<void>(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      case moodLog:
        return MaterialPageRoute<void>(
          builder: (_) => const MoodLoggerScreen(),
          settings: settings,
        );
      case journal:
        return MaterialPageRoute<void>(
          builder: (_) => const JournalScreen(),
          settings: settings,
        );
      case journalNew:
        return MaterialPageRoute<void>(
          builder: (_) => const JournalEntryScreen(),
          settings: settings,
        );
      case journalEdit:
        final entry = settings.arguments;
        return MaterialPageRoute<void>(
          builder: (_) => JournalEntryScreen(entry: entry as dynamic),
          settings: settings,
        );
      case profile:
        final repository = ProfileRepositoryImpl(
          remoteDataSource: const ProfileRemoteDataSource(),
        );
        final viewModel = ProfileViewModel(
          getCurrentProfileUseCase: GetCurrentProfileUseCase(repository),
          updateCurrentProfileUseCase: UpdateCurrentProfileUseCase(repository),
        );
        return MaterialPageRoute<void>(
          builder: (_) => ProfileScreen(viewModel: viewModel),
          settings: settings,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
    }
  }
}
