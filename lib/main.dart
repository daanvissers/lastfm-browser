import 'package:flutter/material.dart';
import 'package:lastfm_browser/screens/index/index.dart';
import 'service_locator.dart';

Future<void> main() async {
  try {
    await setupLocator();
    runApp(App());
  } catch(error) {
    print('Locator setup has failed!');
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Last.fm Browser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(213, 0, 0, 1),
      ),
      home: HomePage(title: 'Last.fm Browser'),
    );
  }
}
