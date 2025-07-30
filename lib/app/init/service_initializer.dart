import 'package:flutter/material.dart';
import 'package:flutter_template/app/core/services/calculation_service.dart';
import 'package:flutter_template/app/core/services/plan_service.dart';
import 'package:flutter_template/app/core/services/user_service.dart';
import 'package:flutter_template/app/core/services/secure_storage_service.dart';
import 'package:flutter_template/app/core/services/wet_mill_service.dart';
import 'package:get/get.dart';

/// Initializes all required services for the application.
/// This function sets up all core services that need to be initialized
/// before the app can function properly, including storage, user management,
/// and business logic services.
Future<void> initServices() async {
  // Ensure Flutter bindings are initialized before any platform channels
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize secure storage service for sensitive data
  await Get.putAsync(() => SecureStorageService().init());
  
  // Initialize calculation service for business logic
  await Get.putAsync(() => CalculationService().init());
  
  // Initialize user service for user data management
  await Get.putAsync(() => UserService().init());
  
  // Initialize site service for wet mill site management
  await Get.putAsync(() => SiteService().init());
  
  // Initialize plan service for operational planning
  await Get.putAsync(() => PlanService().init());
}
