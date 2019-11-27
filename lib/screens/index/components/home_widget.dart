import 'dart:core';
import 'package:flutter/material.dart';
import 'package:lastfm_browser/models/recenttrack_model.dart';
import 'package:flutter/src/widgets/image.dart' as Img;
import 'package:lastfm_browser/service_locator.dart';
import 'package:lastfm_browser/services/lastfmapi_service.dart';
import 'package:lastfm_browser/services/localstorage_service.dart';

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
    _authenticated = (storageService.session == null) ? false : true;

    print("Authenticated: " + _authenticated.toString());

    _text = (_authenticated)
        ? "Welcome, " + storageService.session.name + "!"
        : "Please authenticate first!";
  }

  @override
  Widget build(BuildContext context) {
    return (storageService.session != null)
        ? _buildRecentTracks()
        : Container(
            child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(_text),
              _authenticated
                  ? new Container()
                  : new RaisedButton(
                  color: Color.fromRGBO(213, 0, 0, 1),
                  textColor: Colors.white,
                  child: Text("Log in"),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side:
                      BorderSide(color: Color.fromRGBO(213, 0, 0, 1))),
                  onPressed: () {
                    LastfmApiService.getToken();
                  }),
            ],
          ));
  }

  Widget _buildRecentTracks() {
    return FutureBuilder<List<RecentTrack>>(
        future: LastfmApiService.getRecentTracks(storageService.session.name),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: snapshot.data.length,
              itemBuilder: (context, i) {
                if (i.isOdd) return Divider();
                return _buildRow(snapshot.data.elementAt(i));
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget _buildRow(RecentTrack track) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0.9),
      leading: Img.Image(
        image: NetworkImage(track.image[0].text),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            track.name,
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          ),
          Text(
            track.artist.text,
            style: TextStyle(fontSize: 14.0),
          ),
        ],
      ),
      trailing: Icon(
        Icons.more_vert,
        color: Colors.black54,
      ),
    );
  }
}
