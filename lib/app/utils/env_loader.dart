import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Loads and provides access to environment variables from the .env file.
/// This class provides a centralized way to access environment-specific
/// configuration values like API URLs, environment flags, and feature toggles.
class Env {
  /// Private constructor to prevent instantiation.
  /// This class is designed to be used as a static utility class.
  Env._(); // Prevents instantiation

  /// The base URL for API requests.
  /// Retrieved from the BASE_URL environment variable.
  /// Returns empty string if not defined.
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';

  /// The current app environment (e.g., dev, prod).
  /// Retrieved from the APP_ENV environment variable.
  /// Defaults to 'dev' if not defined.
  static String get appEnv => dotenv.env['APP_ENV'] ?? 'dev';

  /// Returns true if the app is running in development mode.
  /// Retrieved from the IS_DEV environment variable.
  /// Returns true if the value is 'true', false otherwise.
  static bool get isDev => dotenv.env['IS_DEV'] == 'true';

  /// Returns true if logging is enabled.
  /// Retrieved from the ENABLE_LOGGING environment variable.
  /// Returns true if the value is 'true', false otherwise.
  static bool get loggingEnabled => dotenv.env['ENABLE_LOGGING'] == 'true';

  /// Loads environment variables from the .env file.
  /// This method must be called before accessing any environment variables.
  /// Typically called during app initialization in main().
  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }
}
