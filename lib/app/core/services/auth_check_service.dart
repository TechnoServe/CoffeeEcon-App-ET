import 'package:flutter_template/app/core/services/user_service.dart';
import 'package:flutter_template/app/data/models/user_model.dart';

class AuthCheckService {
  AuthCheckService({required this.hiveService});
  final UserService hiveService;

  bool isUserRegistered() {
    final UserModel? user = hiveService.getCurrentUser();
    return user != null && user.fullName.isNotEmpty;
  }
}
