import 'package:flutter_template/app/utils/env_loader.dart';

/// Defines API route paths and helpers for network requests.
class ApiRoutes {
  /// Private constructor to prevent instantiation.
  ApiRoutes._();

  /// The base URL for API requests.
  static String get base => Env.baseUrl;

  /// Route for login endpoint.
  static const login = '/auth/login';

  /// Route for register endpoint.
  static const register = '/auth/register';

  /// Route for user profile endpoint.
  static const userProfile = '/user/profile';

  /// Route for user settings endpoint.
  static const userSettings = '/user/settings';

  /// Returns the user detail endpoint for a given [id].
  static String userDetail(String id) => '/user/$id';
}
