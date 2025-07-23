import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Loads and provides access to environment variables from the .env file.
class Env {
  /// Private constructor to prevent instantiation.
  Env._(); // Prevents instantiation

  /// The base URL for API requests.
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';

  /// The current app environment (e.g., dev, prod).
  static String get appEnv => dotenv.env['APP_ENV'] ?? 'dev';

  /// Returns true if the app is running in development mode.
  static bool get isDev => dotenv.env['IS_DEV'] == 'true';

  /// Returns true if logging is enabled.
  static bool get loggingEnabled => dotenv.env['ENABLE_LOGGING'] == 'true';

  /// Loads environment variables from the .env file.
  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }
}
