import 'dart:convert';

import 'package:lastfm_browser/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  // This service will use the Singleton pattern and instances will
  // be retrieved through a getInstance() static function.
  // We'll keep a static instance of the SharedPreferences
  // as well as the instance for our service.

  static const String UserKey = 'user';
  static const String DarkModeKey = 'darkmode';

  static LocalStorageService _instance;
  static SharedPreferences _preferences;

  static Future<LocalStorageService> getInstance() async {
    if (_instance == null) {
      _instance = LocalStorageService();
    }

    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }

    return _instance;
  }

  // User
  User get user {
    var userJson = _getFromDisk(UserKey);
    if (userJson == null) {
      print("User could not be found, user is null.");
      return null;
    }

    return User.fromJson(json.decode(userJson));
  }

  set user(User userToSave) {
    _saveToDisk(UserKey, json.encode(userToSave.toJson()));
  }

  // Dark Mode
  bool get darkMode => _getFromDisk(DarkModeKey) ?? false;
  set darkMode(bool value) => _saveToDisk(DarkModeKey, value);

  dynamic _getFromDisk(String key) {
    var value = _preferences.get(key);
    print('(TRACE) LocalStorageService:_getFromDisk. key: $key value: $value');
    return value;
  }

  // _saveToDisk function that handles all types
  void _saveToDisk<T>(String key, T content) {
    print('(TRACE) LocalStorageService:_saveToDisk. key: $key value: $content');

    if (content is String) {
      _preferences.setString(key, content);
    }
    if (content is bool) {
      _preferences.setBool(key, content);
    }
    if (content is int) {
      _preferences.setInt(key, content);
    }
    if (content is double) {
      _preferences.setDouble(key, content);
    }
    if (content is List<String>) {
      _preferences.setStringList(key, content);
    }
  }
}
