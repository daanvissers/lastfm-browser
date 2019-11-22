import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:lastfm_browser/models/user_model.dart';

class LastfmApiService {
  static const String baseUrl = "http://ws.audioscrobbler.com/2.0/";
  static const String formatJson = "format=json";
  static const String methodUser = "method=user.getInfo";

  static Future<User> getUser(String username) async {
    String apiKey = await getApiKey();
    final response = await http.get(
        '$baseUrl/?$methodUser&user=$username&api_key=$apiKey&$formatJson');

    print("Get User: '" + userFromJson(response.body).user.name + "'...");

    return userFromJson(response.body);
  }

  static Future<String> getApiKey() async {
    final jsonString = await rootBundle.loadString('assets/config.json');
    Map<String, dynamic> key = jsonDecode(jsonString);
    return key['API key'];
  }
}
