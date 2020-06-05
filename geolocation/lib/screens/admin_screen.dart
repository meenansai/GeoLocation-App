import 'package:flutter/material.dart';
import 'package:geolocation/screens/adminmapscreen.dart';

import 'package:geolocation/widgets/appbarmenu.dart';
import 'package:provider/provider.dart';
import '../providers/userProvider.dart';
import '../widgets/profile.dart';
import '../widgets/report.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  var _isinit = true;
  var _isLoading = false;
  var userName;

  void didChangeDependencies() {
    if (_isinit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<UserProvider>(context, listen: false).fetchItem().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  int _currentIndex = 0;
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget build(BuildContext context) {
    var usersList = Provider.of<UserProvider>(context, listen: false).users;

    final List<Widget> _children = [
      Report(usersList),
      Profile(usersList: usersList),
    ];
    return _isLoading
        ? Scaffold(
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            drawer: AppBarMenu(),
            appBar: AppBar(
              title: _currentIndex == 0 ? Text('Report') : Text('Users'),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Refresh',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    )
                    // Icon(Icons.refresh,color: Colors.wh,),
                    ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.shifting,
              selectedItemColor: Colors.indigo,
              unselectedItemColor: Colors.blueGrey,
              onTap: onTabTapped, // new
              currentIndex: _currentIndex, // new
              items: [
                BottomNavigationBarItem(
                  icon: new Icon(Icons.library_books),
                  title: new Text('Report'),
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), title: Text('Profile'))
              ],
            ),
            body: _children[_currentIndex],
            
          );
  }
}
