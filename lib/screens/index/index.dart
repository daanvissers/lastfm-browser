import 'package:flutter/material.dart';
import 'package:lastfm_browser/models/session_model.dart';
import 'package:lastfm_browser/models/user_model.dart';
import 'package:lastfm_browser/services/lastfmapi_service.dart';
import 'package:lastfm_browser/services/localstorage_service.dart';
import 'package:lastfm_browser/screens/index/components/following_widget.dart';
import 'package:lastfm_browser/screens/index/components/home_widget.dart';
import 'package:lastfm_browser/screens/index/components/library_widget.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LocalStorageService localStorageService = LocalStorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            // First make sure that the session is set at all
            (localStorageService.session != null &&
                    localStorageService.session.name != null)
                // When there is a session, FutureBuild a UserAccountsDrawerHeader
                ? FutureBuilder<User>(

                    // Get the user from the session
                    future: LastfmApiService.getUser(
                        localStorageService.session.name),
                    builder: (context, snapshot) {
                      // If the LastfmApiService is done loading
                      if (snapshot.connectionState == ConnectionState.done) {
                        print("ConnectionState is done. Loading DrawerHeader...");
                        return UserAccountsDrawerHeader(

                          accountName: (localStorageService.session == null)
                              ? Text('Username')
                              : Text(localStorageService.session.name),
                          accountEmail: (localStorageService.session == null)
                              ? Text('')
                              : Text(snapshot.data.user.realname +
                                  " • " +
                                  snapshot.data.user.playcount +
                                  " scrobbles"),
                          arrowColor: Colors.white,
                          currentAccountPicture:
                              (localStorageService.session == null)
                                  ? Text('')
                                  : CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          snapshot.data.user.image[2].text),
                                      backgroundColor: Colors.black,
                                      child: Container(
                                        alignment: Alignment(-1.0, -1.0),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 7,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.black,
                                            radius: 5,
                                          ),
                                        ),
                                      )),
                        );
                      } else {
                        // When the FutureBuilder is still loading, return this
                        return UserAccountsDrawerHeader();
                      }
                    })
                : Container(),
            ListTile(
              title: Text('Trending'),
              leading: Icon(Icons.trending_up),
              onTap: () {
                Navigator.pop(context);
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (BuildContext context) => SecondRoute()));
              },
            ),
            ListTile(
              title: Text('Settings'),
              leading: Icon(Icons.settings),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            Divider(),
            // If session is not null, show 'Log out'-ListTile
            // TODO: 'Log out'-ListTile doesn't immediately show when user authenticates
            (localStorageService.session != null)
                ? ListTile(
                    title: Text('Log out'),
                    leading: Icon(Icons.exit_to_app),
                    onTap: () {
                      _logOut();
                      Navigator.pop(context);
                    },
                  )
                : Container()
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // BottomNavigationBar items
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            title: Text('Library'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('Following'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromRGBO(213, 0, 0, 1),
        onTap: _onItemTapped,
      ),
    );
  }

  // Default page to load
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    HomeWidget(),
    LibraryWidget(),
    FollowingWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logOut() {
    // Clear the logged in user with a blank one
    LocalStorageService localStorageService = LocalStorageService();
    localStorageService.session = Session();
  }
}
