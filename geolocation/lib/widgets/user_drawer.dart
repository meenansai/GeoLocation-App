import 'package:flutter/material.dart';
import 'package:geolocation/screens/change_password_screen.dart';
import 'package:geolocation/screens/userDetailsScreen.dart';
import 'package:geolocation/utils/firebase_data.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/userProvider.dart';

class UserDrawer extends StatelessWidget {
  var userId;
  var userName;
  UserDrawer(this.userId);
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<Auth>(context).fetchedUser;
    print("user id in drawer");
    print(userId);
    return Drawer(
        child: Column(
      children: <Widget>[
        AppBar(
          title: Text('Hello, ' + user.name),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        SizedBox(
          height: 3,
        ),
        // addDrawerList(Icon(Icons.home), 'Home', '/', context, ""),
        // addDrawerList(Icon(Icons.person), 'Profile', UserDetails.routeName,
        //     context, user.id),
        // addDrawerList(Icon(Icons.border_color), 'Change Password',
        //     ChangePasswordScreen.routeName, context, ""),
        ListTile(
          title: Text("Home"),
          leading: Icon(Icons.home),
          onTap: () {
            Navigator.of(context).pushNamed('/');
          },
        ),
        ListTile(
          title: Text("profile"),
          leading: Icon(Icons.person),
          onTap: () {
            Navigator.of(context).pushNamed(UserDetails.routeName,arguments: userId);
          },
        ),
        ListTile(
          title: Text("Change Password"),
          leading: Icon(Icons.border_color),
          onTap: () {
            Navigator.of(context).pushNamed(ChangePasswordScreen.routeName);
          },
        ),
        ListTile(
          title: Text("Logout"),
          leading: Icon(Icons.keyboard_backspace),
          onTap: () {
            // Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/');
            Provider.of<Auth>(context, listen: false).logout();
          },
        ),
      ],
    ));
  }

  ListTile addDrawerList(Icon icon, String title, navroute, context, arg) {
    return ListTile(
      title: Text(title),
      leading: icon,
      onTap: () {
        Navigator.of(context).pushNamed(navroute, arguments: arg);
      },
    );
  }
}
