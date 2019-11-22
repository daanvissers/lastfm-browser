import 'dart:convert';
import 'dart:core';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:lastfm_browser/models/session_model.dart';
import 'package:lastfm_browser/service_locator.dart';
import 'package:lastfm_browser/services/localstorage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

class HomeWidget extends StatefulWidget {
  HomeWidgetState createState() => HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget> {
  var storageService = locator<LocalStorageService>();
  String _text;
  bool _btnVisible;

  @override
  void initState() {
    super.initState();

    // Initialize the State depending on authenticated user
    _btnVisible = (storageService.session == null) ? true : false;
    _text = (storageService.session == null)
        ? "Please authenticate first."
        : "Welcome, " + storageService.session.name + "!";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text(_text),
        _btnVisible
            ? new RaisedButton(
                color: Color.fromRGBO(213, 0, 0, 1),
                textColor: Colors.white,
                child: Text("Log in"),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Color.fromRGBO(213, 0, 0, 1))),
                onPressed: _requestToken)
            : new Container(),
      ],
    ));
  }

  void _requestToken() async {
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

    _getSession(token);
  }

  void _getSession(String token) async {
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
    storageService.session =
        new Session.fromJson(json.decode(response.body)['session']);

    // Change the widget
    _btnVisible = false;
    _text = "Welcome, " + storageService.session.name + "!";

    // Debug saved user
    var mySavedUser = storageService.session;
    print("User has been saved: " + mySavedUser.name);
  }
}
