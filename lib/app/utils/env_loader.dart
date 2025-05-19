import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  Env._(); // Prevents instantiation

  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
  static String get appEnv => dotenv.env['APP_ENV'] ?? 'dev';
  static bool get isDev => dotenv.env['IS_DEV'] == 'true';
  static bool get loggingEnabled => dotenv.env['ENABLE_LOGGING'] == 'true';

  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }
}
