import 'package:flutter_template/app/utils/env_loader.dart';

/// Defines API route paths and helpers for network requests.
/// This class centralizes all API endpoint definitions to ensure consistency
/// and make it easier to manage API changes across the application.
class ApiRoutes {
  /// Private constructor to prevent instantiation.
  /// This class is designed to be used as a static utility class.
  ApiRoutes._();

  /// The base URL for API requests.
  /// Retrieved from environment variables to support different environments
  /// (development, staging, production).
  static String get base => Env.baseUrl;

  /// Route for login endpoint.
  /// Used for user authentication and obtaining access tokens.
  static const login = '/auth/login';

  /// Route for register endpoint.
  /// Used for creating new user accounts and registration.
  static const register = '/auth/register';

  /// Route for user profile endpoint.
  /// Used for fetching and updating user profile information.
  static const userProfile = '/user/profile';

  /// Route for user settings endpoint.
  /// Used for fetching and updating user preferences and settings.
  static const userSettings = '/user/settings';

  /// Returns the user detail endpoint for a given [id].
  /// This method generates dynamic routes for specific user details
  /// based on the provided user ID.
  /// 
  /// [id] - The unique identifier of the user
  /// Returns the complete endpoint path for the specified user
  static String userDetail(String id) => '/user/$id';
}
