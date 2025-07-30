import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for securely storing key-value pairs using FlutterSecureStorage.
/// This service provides a secure way to store sensitive data like tokens,
/// user credentials, and app preferences using platform-specific encryption.
class SecureStorageService {
  /// The underlying secure storage instance.
  /// Uses FlutterSecureStorage for platform-specific secure storage.
  static const _storage = FlutterSecureStorage();

  /// The key for tracking first launch.
  /// Used to determine if this is the first time the app is being launched.
  static const _firstLaunchKey = 'is_first_launch';

  /// Initializes the secure storage service.
  /// This method is called during app startup to ensure the service is ready.
  /// 
  /// Returns the initialized service instance
  Future<SecureStorageService> init() async => this;

  /// Writes a value to secure storage for the given [key].
  /// This method encrypts and stores sensitive data securely.
  /// 
  /// [key] - The unique identifier for the stored value
  /// [value] - The value to store securely
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Reads a value from secure storage for the given [key].
  /// This method retrieves and decrypts stored sensitive data.
  /// 
  /// [key] - The unique identifier for the stored value
  /// Returns the stored value or null if not found
  Future<String?> read(String key) async => await _storage.read(key: key);

  /// Deletes a value from secure storage for the given [key].
  /// This method removes sensitive data from secure storage.
  /// 
  /// [key] - The unique identifier for the value to delete
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Returns true if this is the first launch of the app.
  /// This method checks if the app has been launched before by reading
  /// a flag from secure storage. If no flag exists, it sets one and
  /// returns true for the first launch.
  /// 
  /// Returns true if this is the first launch, false otherwise
  Future<bool> isFirstLaunch() async {
    // Check if the first launch flag exists
    final flag = await _storage.read(key: _firstLaunchKey);
    if (flag == null) {
      // If no flag exists, this is the first launch
      await _storage.write(key: _firstLaunchKey, value: 'false');
      return true;
    }
    // Flag exists, so this is not the first launch
    return false;
  }
}
