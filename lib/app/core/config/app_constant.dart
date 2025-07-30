/// Defines general constants and keys used throughout the app.
/// This class centralizes application-wide constants to ensure consistency
/// and make it easier to maintain configuration values across the app.
class AppConstants {
  // General application constants
  /// The application name.
  /// Used for app title, branding, and display purposes.
  static const String appName = 'AblazeApp';

  /// The delay duration for the splash screen.
  /// Controls how long the splash screen is displayed before transitioning
  /// to the main application.
  static const Duration splashDelay = Duration(seconds: 2);

  /// The default page size for pagination.
  /// Used for API requests and list pagination to control how many
  /// items are loaded at once.
  static const int pageSize = 20;

  // Error messages for consistent user feedback
  /// Error message for no internet connection.
  /// Displayed when the app cannot connect to the internet.
  static const String noInternet = 'No internet connection';

  /// Error message for unexpected errors.
  /// Generic error message for unhandled exceptions and unknown errors.
  static const String unexpectedError = 'Something went wrong';

  // Storage keys for secure data persistence
  /// Key for storing the authentication token.
  /// Used in secure storage to persist user authentication state.
  static const String tokenKey = 'TOKEN_KEY';

  /// Key for storing user preferences.
  /// Used in secure storage to persist user settings and preferences.
  static const String userPrefsKey = 'USER_PREFS';
}
