import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_template/app/data/models/user_model.dart';
import 'package:uuid/uuid.dart';

class UserService {
  Future<UserService> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());

    await Hive.openBox<UserModel>('users');

    return this;
  }

  Box<UserModel> get userBox => Hive.box<UserModel>('users');

  Future<void> saveUserByName(String fullName) async {
    final uuid = const Uuid().v4();
    final user = UserModel(id: uuid, fullName: fullName);
    await userBox.put('current', user);
  }

  UserModel? getCurrentUser() => userBox.get('current');

  Future<void> clearUsers() async {
    await userBox.clear();
  }
}
