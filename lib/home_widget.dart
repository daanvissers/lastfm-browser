import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

class HomeWidget extends StatefulWidget {
  HomeWidgetState createState() => HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget> {
  String _text = "Please authenticate first!";

  @override
  Widget build(BuildContext context) {
    return Container(
        child: new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text(_text),
        new RaisedButton(
            color: Color.fromRGBO(213, 0, 0, 1),
            textColor: Colors.white,
            child: Text("Log in"),
            onPressed: _requestToken),
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

    log(token);

    setState(() {
      _text = "Succesfully authenticated!";
    });
  }
}
