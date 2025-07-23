import 'package:flutter/material.dart';
import 'package:flutter_template/app/core/services/user_service.dart';
import 'package:flutter_template/app/routes/app_routes.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final fullNameController = TextEditingController();
  final isLoading = false.obs;
  final nameError = RxnString(); // nullable reactive string
  final userName = RxnString(); // fetched name
  @override
  void onInit() {
    fetchUserName();
    super.onInit();
  }

  void fetchUserName() {
    final user = Get.find<UserService>().getCurrentUser();
    userName.value = user?.fullName;
  }

  Future<void> onGetStarted() async {
    final name = fullNameController.text.trim();

    if (name.isEmpty) {
      nameError.value = 'Name cannot be empty';
      return;
    }

    nameError.value = null;
    isLoading.value = true;

    await Get.find<UserService>().saveUserByName(name);
    fetchUserName();
    isLoading.value = false;
    Get.offAllNamed<void>(AppRoutes.ONBOARDINGSITEREGISTRATION);
  }

  @override
  void onClose() {
    fullNameController.dispose();
    super.onClose();
  }
}
