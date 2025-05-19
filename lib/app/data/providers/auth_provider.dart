import 'package:dio/dio.dart';
import 'package:flutter_template/app/core/config/api_routes.dart';

class AuthProvider {
  AuthProvider(this.dio);
  final Dio dio;

  Future<Response<dynamic>> login(String email, String password) => dio.post(
        ApiRoutes.login,
        data: {
          'email': email,
          'password': password,
        },
      );
}
