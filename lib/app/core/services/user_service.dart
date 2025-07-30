import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_template/app/data/models/user_model.dart';
import 'package:uuid/uuid.dart';

/// Service for managing user information using Hive storage.
/// This service provides methods to store, retrieve, and manage user data
/// using Hive as a local database for offline functionality.
class UserService {
  /// Initializes the user service and opens the Hive box.
  /// This method sets up Hive for Flutter, registers the UserModel adapter,
  /// and opens the users box for data storage.
  /// 
  /// Returns the initialized service instance
  Future<UserService> init() async {
    // Initialize Hive for Flutter
    await Hive.initFlutter();
    // Register the UserModel adapter for Hive serialization
    Hive.registerAdapter(UserModelAdapter());

    // Open the users box for storing user data
    await Hive.openBox<UserModel>('users');

    return this;
  }

  /// The Hive box for user information.
  /// Provides access to the local database for user data operations.
  Box<UserModel> get userBox => Hive.box<UserModel>('users');

  /// Saves a user by their [fullName].
  /// This method creates a new user with a unique ID and stores it
  /// as the current user in local storage.
  /// 
  /// [fullName] - The full name of the user to save
  Future<void> saveUserByName(String fullName) async {
    // Generate a unique identifier for the user
    final uuid = const Uuid().v4();
    // Create a new user model with the provided name
    final user = UserModel(id: uuid, fullName: fullName);
    // Store the user as the current user in local storage
    await userBox.put('current', user);
  }

  /// Returns the current user, or null if not found.
  /// This method retrieves the currently logged-in user from local storage.
  /// 
  /// Returns the current user model or null if no user is stored
  UserModel? getCurrentUser() => userBox.get('current');

  /// Clears all users from storage.
  /// This method removes all user data from local storage.
  /// Useful for logout functionality or data cleanup.
  Future<void> clearUsers() async {
    await userBox.clear();
  }
}
