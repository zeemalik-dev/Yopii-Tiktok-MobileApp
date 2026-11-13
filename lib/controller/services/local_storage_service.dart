import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageService {
  // Singleton instance
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  final _storage = const FlutterSecureStorage();
  final String _keyToken = 'auth_token';
  final String _keyUserId = 'user_id';
  // Save token securely
  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  // Save user ID securely
  Future<void> saveUserId(String id) async {
    await _storage.write(key: _keyUserId, value: id);
  }

  // Retrieve token
  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  // Retrieve user ID
  Future<String?> getUserId() async {
    return await _storage.read(key: _keyUserId);
  }

  // Delete token (logout)
  Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }

  // Delete user ID
  Future<void> deleteUserId() async {
    await _storage.delete(key: _keyUserId);
  }

  // Clear all data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
