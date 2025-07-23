/// Defines general constants and keys used throughout the app.
class AppConstants {
  // General
  /// The application name.
  static const String appName = 'AblazeApp';

  /// The delay duration for the splash screen.
  static const Duration splashDelay = Duration(seconds: 2);

  /// The default page size for pagination.
  static const int pageSize = 20;

  // Error messages
  /// Error message for no internet connection.
  static const String noInternet = 'No internet connection';

  /// Error message for unexpected errors.
  static const String unexpectedError = 'Something went wrong';

  // Storage keys
  /// Key for storing the authentication token.
  static const String tokenKey = 'TOKEN_KEY';

  /// Key for storing user preferences.
  static const String userPrefsKey = 'USER_PREFS';
}
