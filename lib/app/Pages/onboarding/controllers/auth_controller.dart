import 'package:flutter/material.dart';
import 'package:flutter_template/app/core/services/user_service.dart';
import 'package:flutter_template/app/routes/app_routes.dart';
import 'package:get/get.dart';

/// Controller for managing user authentication and onboarding flow.
///
/// This controller handles the initial user setup process including:
/// - User name input and validation
/// - User data persistence and retrieval
/// - Loading states during authentication
/// - Navigation to the next onboarding step
///
/// The controller integrates with the UserService for data persistence
/// and manages the transition from authentication to site registration.
class AuthController extends GetxController {
  /// Text controller for user's full name input
  final fullNameController = TextEditingController();
  /// Whether the authentication process is currently loading
  final isLoading = false.obs;
  /// Error message for name validation (nullable)
  final nameError = RxnString(); // nullable reactive string
  /// The user's name fetched from storage
  final userName = RxnString(); // fetched name
  
  @override
  void onInit() {
    // Fetch existing user name on initialization
    fetchUserName();
    super.onInit();
  }

  /// Fetches the current user's name from the user service.
  ///
  /// Updates the userName observable with the stored user's full name.
  void fetchUserName() {
    final user = Get.find<UserService>().getCurrentUser();
    userName.value = user?.fullName;
  }

  /// Handles the "Get Started" button action for user registration.
  ///
  /// Validates the user's name input, saves the user data, and navigates
  /// to the site registration step of the onboarding process.
  ///
  /// The method includes:
  /// - Name validation (non-empty check)
  /// - Loading state management
  /// - User data persistence
  /// - Navigation to next onboarding step
  Future<void> onGetStarted() async {
    final name = fullNameController.text.trim();

    // Validate that name is not empty
    if (name.isEmpty) {
      nameError.value = 'Name cannot be empty';
      return;
    }

    // Clear any previous errors and start loading
    nameError.value = null;
    isLoading.value = true;

    // Save user data and navigate to next step
    await Get.find<UserService>().saveUserByName(name);
    fetchUserName();
    isLoading.value = false;
    Get.offAllNamed<void>(AppRoutes.ONBOARDINGSITEREGISTRATION);
  }

  @override
  void onClose() {
    // Dispose text controller to prevent memory leaks
    fullNameController.dispose();
    super.onClose();
  }
}
