import 'dart:convert';
import 'dart:async';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'package:lastfm_browser/models/recenttrack_model.dart';
import 'package:lastfm_browser/models/session_model.dart';
import 'package:lastfm_browser/models/track_model.dart';
import 'package:lastfm_browser/models/user_model.dart';
import 'package:lastfm_browser/services/localstorage_service.dart';

class LastfmApiService {
  static const String baseUrl = "http://ws.audioscrobbler.com/2.0/";
  static const String formatJson = "format=json";
  static const String methodUser = "method=user.getInfo";

  ///
  /// User
  ///
  static Future<User> getUser(String username) async {
    String apiKey = await getApiKey();
    final response = await http.get(
        '$baseUrl/?$methodUser&user=$username&api_key=$apiKey&$formatJson');

    print("Get User: '" + userFromJson(response.body).user.name + "'...");

    return userFromJson(response.body);
  }

  ///
  /// Get User Recent Tracks
  ///
  static Future<List<RecentTrack>> getRecentTracks(String username) async {
    String apiKey = await getApiKey();
    final response = await http.get(
        '$baseUrl/?method=user.getrecenttracks&user=$username&api_key=$apiKey&limit=20&$formatJson');

    // Create new list of RecentTracks
    List<RecentTrack> recentTracks = List<RecentTrack>();

    // Json-response in a List
    List<dynamic> jsonTracks = json.decode(response.body)['recenttracks']['track'];

    // Encode each track in jsonTracks back, and use it to
    // create a RecentTrack model.
    for (var track in jsonTracks) {
      track = jsonEncode(track);
      RecentTrack recentTrack = recentTrackFromJson(track);
      recentTracks.add(recentTrack);
    }

    print(recentTracks.length);
    return recentTracks;
  }

  ///
  /// Auth
  ///
  static getToken() async {
    final baseUrl = "http://www.last.fm/api/auth/?api_key=";

    // First load the config.json text file.
    // Then serialize the JSON manually using dart:convert to get the key
    final jsonString = await rootBundle.loadString('assets/config.json');
    Map<String, dynamic> key = jsonDecode(jsonString);
    final apiKey = key['API key'];

    // This is the custom callback-URL. This makes the API redirect to
    // a custom Android Activity as found in the AndroidManifest.xml
    final callback = "&cb=lastfmbrowser://authenticate";

    // Present the login dialog to the user
    final result = await FlutterWebAuth.authenticate(
        url: baseUrl + apiKey + callback, callbackUrlScheme: "lastfmbrowser");

    // Extract token from resulting url.
    // Authentication tokens are user and API account specific.
    // They are valid for 60 minutes from the moment they are granted.
    String token = Uri.parse(result).queryParameters['token'];

    getSession(token);
  }

  static getSession(String token) async {
    // Get the API key + Secret from assets
    final jsonString = await rootBundle.loadString('assets/config.json');
    Map<String, dynamic> key = jsonDecode(jsonString);
    final apiKey = key['API key'];
    final secret = key['Shared secret'];

    // Generate signature by ordering all the parameters by parameter-name
    // alphabetically, and concatenating them into one string using
    // a <name><value> scheme. Afterwards, encrypt by md5
    String data =
        "api_key" + apiKey + "methodauth.getSessiontoken" + token + secret;
    var signature = md5.convert(utf8.encode(data));

    // Make the api call
    final baseUrl = "http://ws.audioscrobbler.com/2.0/?";
    final String url = baseUrl +
        "method=auth.getSession" +
        "&token=" +
        token +
        "&api_key=" +
        apiKey +
        "&api_sig=" +
        signature.toString() +
        "&format=json";
    http.Response response = await http.post(url);

    // Register the user in the Local Storage
    var storageService = LocalStorageService();
    storageService.session =
        new Session.fromJson(json.decode(response.body)['session']);

    // Debug saved user
    var mySavedUser = storageService.session;
    print("User has been saved: " + mySavedUser.name);
  }

  static Future<String> getApiKey() async {
    final jsonString = await rootBundle.loadString('assets/config.json');
    Map<String, dynamic> key = jsonDecode(jsonString);
    return key['API key'];
  }
}
