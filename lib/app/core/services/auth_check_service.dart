import 'package:flutter_template/app/core/services/user_service.dart';
import 'package:flutter_template/app/data/models/user_model.dart';

/// Service for checking user authentication status.
class AuthCheckService {
  /// Creates an [AuthCheckService] with the given [hiveService].
  AuthCheckService({required this.hiveService});

  /// The user service used for authentication checks.
  final UserService hiveService;

  /// Returns true if a user is registered.
  bool isUserRegistered() {
    final UserModel? user = hiveService.getCurrentUser();
    return user != null && user.fullName.isNotEmpty;
  }
}
