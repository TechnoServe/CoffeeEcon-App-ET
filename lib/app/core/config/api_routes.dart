import 'package:flutter_template/app/utils/env_loader.dart';

class ApiRoutes {
  ApiRoutes._(); // Prevents instantiation

  static String get base => Env.baseUrl;

  static const login = '/auth/login';
  static const register = '/auth/register';
  static const userProfile = '/user/profile';
  static const userSettings = '/user/settings';

  static String userDetail(String id) => '/user/$id';
}
