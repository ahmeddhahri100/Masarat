import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Storage service for managing local data persistence
/// Uses SharedPreferences for non-sensitive data and FlutterSecureStorage for sensitive data
class StorageService {
  StorageService._();
  static final StorageService _instance = StorageService._();
  static StorageService get instance => _instance;

  late final SharedPreferences _preferences;
  late final FlutterSecureStorage _secureStorage;

  /// Initialize storage service
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    _secureStorage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    );
  }

  // ============================================================
  // Regular Storage (SharedPreferences)
  // ============================================================

  /// Save a string value
  Future<bool> setString(String key, String value) async {
    return await _preferences.setString(key, value);
  }

  /// Get a string value
  String? getString(String key) {
    return _preferences.getString(key);
  }

  /// Save an integer value
  Future<bool> setInt(String key, int value) async {
    return await _preferences.setInt(key, value);
  }

  /// Get an integer value
  int? getInt(String key) {
    return _preferences.getInt(key);
  }

  /// Save a double value
  Future<bool> setDouble(String key, double value) async {
    return await _preferences.setDouble(key, value);
  }

  /// Get a double value
  double? getDouble(String key) {
    return _preferences.getDouble(key);
  }

  /// Save a boolean value
  Future<bool> setBool(String key, bool value) async {
    return await _preferences.setBool(key, value);
  }

  /// Get a boolean value
  bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  /// Save a list of strings
  Future<bool> setStringList(String key, List<String> value) async {
    return await _preferences.setStringList(key, value);
  }

  /// Get a list of strings
  List<String>? getStringList(String key) {
    return _preferences.getStringList(key);
  }

  /// Remove a value
  Future<bool> remove(String key) async {
    return await _preferences.remove(key);
  }

  /// Check if a key exists
  bool containsKey(String key) {
    return _preferences.containsKey(key);
  }

  /// Get all keys
  Set<String> getKeys() {
    return _preferences.getKeys();
  }

  /// Clear all regular storage
  Future<bool> clear() async {
    return await _preferences.clear();
  }

  /// Reload preferences from disk
  Future<void> reload() async {
    await _preferences.reload();
  }

  // ============================================================
  // Secure Storage (FlutterSecureStorage)
  // ============================================================

  /// Save a value securely
  Future<void> setSecureValue(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  /// Get a secure value
  Future<String?> getSecureValue(String key) async {
    return await _secureStorage.read(key: key);
  }

  /// Delete a secure value
  Future<void> deleteSecureValue(String key) async {
    await _secureStorage.delete(key: key);
  }

  /// Check if a secure key exists
  Future<bool> containsSecureKey(String key) async {
    return await _secureStorage.containsKey(key: key);
  }

  /// Get all secure keys and values
  Future<Map<String, String>> getAllSecureValues() async {
    return await _secureStorage.readAll();
  }

  /// Delete all secure values
  Future<void> deleteAllSecureValues() async {
    await _secureStorage.deleteAll();
  }

  // ============================================================
  // Convenience Methods for Common Operations
  // ============================================================

  /// Save access token securely
  Future<void> saveAccessToken(String token) async {
    await setSecureValue('access_token', token);
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    return await getSecureValue('access_token');
  }

  /// Save refresh token securely
  Future<void> saveRefreshToken(String token) async {
    await setSecureValue('refresh_token', token);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await getSecureValue('refresh_token');
  }

  /// Save user ID
  Future<void> saveUserId(String userId) async {
    await setString('user_id', userId);
  }

  /// Get user ID
  String? getUserId() {
    return getString('user_id');
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear all auth data
  Future<void> clearAuthData() async {
    await deleteSecureValue('access_token');
    await deleteSecureValue('refresh_token');
    await remove('user_id');
  }

  /// Save onboarding completion status
  Future<void> setOnboardingCompleted(bool completed) async {
    await setBool('onboarding_completed', completed);
  }

  /// Check if onboarding is completed
  bool isOnboardingCompleted() {
    return getBool('onboarding_completed') ?? false;
  }

  /// Save theme mode (light/dark/system)
  Future<void> setThemeMode(String mode) async {
    await setString('theme_mode', mode);
  }

  /// Get theme mode
  String getThemeMode() {
    return getString('theme_mode') ?? 'system';
  }

  /// Save language code
  Future<void> setLanguageCode(String code) async {
    await setString('language_code', code);
  }

  /// Get language code
  String? getLanguageCode() {
    return getString('language_code');
  }

  /// Clear all storage (both regular and secure)
  Future<void> clearAll() async {
    await clear();
    await deleteAllSecureValues();
  }
}
