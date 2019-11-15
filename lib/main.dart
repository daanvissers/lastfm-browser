import 'package:flutter/material.dart';
import 'package:lastfm_browser/homepage.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Last.fm Browser',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(213, 0, 0, 1),
      ),
      home: HomePage(title: 'Last.fm Browser'),
    );
  }
}
