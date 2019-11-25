import 'dart:convert';

import 'package:lastfm_browser/models/session_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  // This service will use the Singleton pattern and instances will
  // be retrieved through a getInstance() static function.
  // We'll keep a static instance of the SharedPreferences
  // as well as the instance for our service.

  static const String SessionKey = 'session';
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

  // Session
  Session get session {
    var sessionJson = _getFromDisk(SessionKey);
    if (sessionJson == null) {
      return null;
    }
    return Session.fromJson(json.decode(sessionJson));
  }

  set session(Session sessionToSave) {
    _saveToDisk(SessionKey, json.encode(sessionToSave.toJson()));
  }

  // Clear session
  void clearSession() {
    _preferences.clear();
  }

  // Dark Mode
  bool get darkMode => _getFromDisk(DarkModeKey) ?? false;
  set darkMode(bool value) => _saveToDisk(DarkModeKey, value);

  dynamic _getFromDisk(String key) {
    var value = _preferences.get(key);

    // DEBUG:
    // print('(TRACE) LocalStorageService:_getFromDisk. key: $key value: $value');
    return value;
  }

  // _saveToDisk function that handles all types
  void _saveToDisk<T>(String key, T content) {

    // DEBUG:
    // print('(TRACE) LocalStorageService:_saveToDisk. key: $key value: $content');

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
