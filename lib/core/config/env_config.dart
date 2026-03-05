import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  EnvConfig._();

  static bool _loaded = false;

  static Future<void> load() async {
    if (_loaded) return;
    await dotenv.load(fileName: '.env');
    _loaded = true;
  }

  static String get supabaseUrl => _getRequired('SUPABASE_URL');
  static String get supabaseAnonKey => _getRequired('SUPABASE_ANON_KEY');
  static String? get supabaseEmailRedirectTo =>
      _getOptional('SUPABASE_EMAIL_REDIRECT_TO');

  static String _getRequired(String key) {
    final value = dotenv.env[key]?.trim() ?? '';
    if (value.isEmpty) {
      throw Exception('Missing required env variable: $key');
    }
    return value;
  }

  static String? _getOptional(String key) {
    final value = dotenv.env[key]?.trim() ?? '';
    return value.isEmpty ? null : value;
  }
}
