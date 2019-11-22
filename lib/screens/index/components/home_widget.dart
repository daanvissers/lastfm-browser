import 'dart:core';
import 'package:lastfm_browser/service_locator.dart';
import 'package:lastfm_browser/services/lastfmapi_service.dart';
import 'package:lastfm_browser/services/localstorage_service.dart';
import 'package:flutter/material.dart';

class HomeWidget extends StatefulWidget {
  HomeWidgetState createState() => HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget> {
  var storageService = locator<LocalStorageService>();

  String _text;
  bool _authenticated;

  @override
  void initState() {
    super.initState();

    // Initialize the State depending on authenticated user
    _authenticated = (storageService.session == null) ? true : false;
    _text = (_authenticated)
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
        _authenticated
            ? new RaisedButton(
                color: Color.fromRGBO(213, 0, 0, 1),
                textColor: Colors.white,
                child: Text("Log in"),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Color.fromRGBO(213, 0, 0, 1))),
                onPressed: () {
                  LastfmApiService.getToken();
                })
            : new Container(),
      ],
    ));
  }
}
