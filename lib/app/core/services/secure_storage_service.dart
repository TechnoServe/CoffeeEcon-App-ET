import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for securely storing key-value pairs using FlutterSecureStorage.
class SecureStorageService {
  /// The underlying secure storage instance.
  static const _storage = FlutterSecureStorage();

  /// The key for tracking first launch.
  static const _firstLaunchKey = 'is_first_launch';

  /// Initializes the secure storage service.
  Future<SecureStorageService> init() async => this;

  /// Writes a value to secure storage for the given [key].
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Reads a value from secure storage for the given [key].
  Future<String?> read(String key) async => await _storage.read(key: key);

  /// Deletes a value from secure storage for the given [key].
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Returns true if this is the first launch of the app.
  Future<bool> isFirstLaunch() async {
    final flag = await _storage.read(key: _firstLaunchKey);
    if (flag == null) {
      await _storage.write(key: _firstLaunchKey, value: 'false');
      return true;
    }
    return false;
  }
}
