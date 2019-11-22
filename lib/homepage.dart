import 'package:flutter/material.dart';
import 'package:lastfm_browser/following_widget.dart';
import 'package:lastfm_browser/home_widget.dart';
import 'package:lastfm_browser/library_widget.dart';
import 'package:lastfm_browser/models/user_model.dart';
import 'package:lastfm_browser/services/localstorage_service.dart';

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
            UserAccountsDrawerHeader(
              accountName: (localStorageService.user.name == null)
                  ? Text('')
                  : Text(localStorageService.user.name),
              accountEmail: (localStorageService.user.name == null)
                  ? Text('')
                  : Text("Local User"),
              arrowColor: Colors.white,
              currentAccountPicture: (localStorageService.user.name == null)
                  ? Text('')
                  : CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        "B",
                        style: TextStyle(fontSize: 40.0, color: Colors.black54),
                      ),
                    ),
              // child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            ),
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
            ListTile(
              title: Text('Log out'),
              leading: Icon(Icons.exit_to_app),
              onTap: () {
                _logOut();
                Navigator.pop(context);
              },
            )
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
    localStorageService.user = User();
  }
}
