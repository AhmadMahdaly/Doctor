import 'package:doctor_app/core/cache_helper/cache_values.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  CacheHelper._();

  static SharedPreferences? _sharedPreferences;
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static void _checkInstance() {
    if (_sharedPreferences == null) {
      throw Exception(
        'CacheHelper not initialized. Call CacheHelper.init() in your main.dart',
      );
    }
  }

  static Future<void> setLanguage(String langCode) async {
    await set(CacheKeys.currentLanguage, langCode);
  }

  static String getLanguage() {
    return get<String>(CacheKeys.currentLanguage) ?? 'en';
  }

  static bool isEnglish() => getLanguage() == 'en';

  static Future<bool> set(String key, dynamic value) async {
    _checkInstance();
    if (value is String) return _sharedPreferences!.setString(key, value);
    if (value is int) return _sharedPreferences!.setInt(key, value);
    if (value is bool) return _sharedPreferences!.setBool(key, value);
    if (value is double) return _sharedPreferences!.setDouble(key, value);
    return false;
  }

  static T? get<T>(String key) {
    _checkInstance();
    try {
      return _sharedPreferences!.get(key) as T?;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> remove(String key) async {
    _checkInstance();
    return _sharedPreferences!.remove(key);
  }

  static Future<bool> clear() async {
    _checkInstance();
    return _sharedPreferences!.clear();
  }

  static Future<void> setSecured(String key, String value) async {
    if (kDebugMode) {
      print('FlutterSecureStorage: Writing key: $key');
    }
    await _secureStorage.write(key: key, value: value);
  }

  static Future<String?> getSecured(String key) async {
    if (kDebugMode) {
      print('FlutterSecureStorage: Reading key: $key');
    }
    return _secureStorage.read(key: key);
  }

  static Future<void> removeSecured(String key) async {
    await _secureStorage.delete(key: key);
  }

  static Future<void> clearSecured() async {
    if (kDebugMode) {
      print('FlutterSecureStorage: Clearing all data');
    }
    await _secureStorage.deleteAll();
  }
}
