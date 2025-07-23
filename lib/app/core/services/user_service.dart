import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_template/app/data/models/user_model.dart';
import 'package:uuid/uuid.dart';

/// Service for managing user information using Hive storage.
class UserService {
  /// Initializes the user service and opens the Hive box.
  Future<UserService> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());

    await Hive.openBox<UserModel>('users');

    return this;
  }

  /// The Hive box for user information.
  Box<UserModel> get userBox => Hive.box<UserModel>('users');

  /// Saves a user by their [fullName].
  Future<void> saveUserByName(String fullName) async {
    final uuid = const Uuid().v4();
    final user = UserModel(id: uuid, fullName: fullName);
    await userBox.put('current', user);
  }

  /// Returns the current user, or null if not found.
  UserModel? getCurrentUser() => userBox.get('current');

  /// Clears all users from storage.
  Future<void> clearUsers() async {
    await userBox.clear();
  }
}
