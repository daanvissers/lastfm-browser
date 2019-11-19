import 'dart:convert';
import 'dart:developer';
import 'dart:core';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

class HomeWidget extends StatefulWidget {
  HomeWidgetState createState() => HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget> {
  String _text = "Please authenticate first!";
  bool _btnVisible = true;

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
                    side: BorderSide(color: Color.fromRGBO(213, 0, 0, 1))
                ),
                onPressed: _requestToken)
            : new Container(),
      ],
    ));
  }

  void _requestToken() async {
    final BASE_URL = "http://www.last.fm/api/auth/?api_key=";

    // First load the config.json text file.
    // Then serialize the JSON manually using dart:convert to get the key
    final jsonString = await rootBundle.loadString('assets/config.json');
    Map<String, dynamic> key = jsonDecode(jsonString);
    final API_KEY = key['API key'];

    // This is the custom callback-URL. This makes the API redirect to
    // a custom Android Activity as found in the AndroidManifest.xml
    final CALLBACK = "&cb=lastfmbrowser://authenticate";

    // Present the login dialog to the user
    final result = await FlutterWebAuth.authenticate(
        url: BASE_URL + API_KEY + CALLBACK, callbackUrlScheme: "lastfmbrowser");

    // Extract token from resulting url.
    // Authentication tokens are user and API account specific.
    // They are valid for 60 minutes from the moment they are granted.
    String token = Uri.parse(result).queryParameters['token'];

    log("Token: " + token);

    _getSession(token);
  }

  void _getSession(String token) async {
    // Get the API key + Secret from assets
    final jsonString = await rootBundle.loadString('assets/config.json');
    Map<String, dynamic> key = jsonDecode(jsonString);
    final api_key = key['API key'];
    final secret = key['Shared secret'];

    // Generate signature by ordering all the parameters by parameter-name
    // alphabetically, and concatenating them into one string using
    // a <name><value> scheme. Afterwards, encrypt by md5
    String data =
        "api_key" + api_key + "methodauth.getSessiontoken" + token + secret;
    var signature = md5.convert(utf8.encode(data));

    // Make the api call
    final BASE_URL = "http://ws.audioscrobbler.com/2.0/?";
    final String url = BASE_URL
        + "method=auth.getSession"
        + "&token=" + token
        + "&api_key=" + api_key
        + "&api_sig=" + signature.toString()
        + "&format=json";
    http.Response response = await http.post(url);

    // Decode the api response
    Map<String, dynamic> jsonData = json.decode(response.body);

    setState(() {
      _btnVisible = false;
      _text = "Welcome, " + jsonData['session']['name'].toString() + "!";
    });
  }
}
