import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageKeys {
  LocalStorageKeys._();

  static const String userId = 'user_id';
  static const String userType = 'user_type';
  static const String accessToken = 'access_token';
}

class LocalStorageService {
  SharedPreferences? _prefs;

  Future<SharedPreferences> get _instance async =>
      _prefs ??= await SharedPreferences.getInstance();

  Future<void> setString(String key, String value) async {
    final prefs = await _instance;
    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final prefs = await _instance;
    return prefs.getString(key);
  }

  Future<void> setBool(String key, bool value) async {
    final prefs = await _instance;
    await prefs.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    final prefs = await _instance;
    return prefs.getBool(key);
  }

  Future<void> remove(String key) async {
    final prefs = await _instance;
    await prefs.remove(key);
  }

  Future<void> clear() async {
    final prefs = await _instance;
    await prefs.clear();
  }

  Future<String?> get userId => getString(LocalStorageKeys.userId);

  Future<void> setUserId(String value) => setString(LocalStorageKeys.userId, value);

  Future<String?> get userType => getString(LocalStorageKeys.userType);

  Future<void> setUserType(String value) =>
      setString(LocalStorageKeys.userType, value);

  Future<String?> get accessToken => getString(LocalStorageKeys.accessToken);

  Future<void> setAccessToken(String value) =>
      setString(LocalStorageKeys.accessToken, value);
}
