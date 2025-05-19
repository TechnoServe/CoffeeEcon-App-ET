import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();
  static const _firstLaunchKey = 'is_first_launch';

  Future<SecureStorageService> init() async => this;

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async => await _storage.read(key: key);

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<bool> isFirstLaunch() async {
    final flag = await _storage.read(key: _firstLaunchKey);
    if (flag == null) {
      await _storage.write(key: _firstLaunchKey, value: 'false');
      return true;
    }
    return false;
  }
}
