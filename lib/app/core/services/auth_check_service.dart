import 'package:flutter_template/app/core/services/user_service.dart';
import 'package:flutter_template/app/data/models/user_model.dart';

/// Service for checking user authentication status.
/// This service provides a centralized way to verify if a user is authenticated
/// and has completed the registration process.
class AuthCheckService {
  /// Creates an [AuthCheckService] with the given [hiveService].
  /// 
  /// [hiveService] - The user service that handles user data persistence
  AuthCheckService({required this.hiveService});

  /// The user service used for authentication checks.
  /// This service provides access to user data stored locally.
  final UserService hiveService;

  /// Returns true if a user is registered.
  /// This method checks if a user exists in local storage and has
  /// completed the registration process by having a non-empty full name.
  /// 
  /// Returns true if user exists and has a valid full name, false otherwise
  bool isUserRegistered() {
    // Retrieve the current user from local storage
    final UserModel? user = hiveService.getCurrentUser();
    // Check if user exists and has completed registration
    return user != null && user.fullName.isNotEmpty;
  }
}
