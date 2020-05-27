import 'package:flutter/material.dart';
import 'package:geolocation/screens/change_password_screen.dart';
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
    User user=Provider.of<Auth>(context).fetchedUser;
    return Drawer(
        child: Column(
      children: <Widget>[
        AppBar(
          title: Text('Hello, '+user.name),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        SizedBox(
          height: 3,
        ),
        addDrawerList(Icon(Icons.home), 'Home', '/', context),
        addDrawerList(
            Icon(Icons.border_color), 'Change Password', ChangePasswordScreen.routeName, context),
        // addDrawerList(Icon(Icons.keyboard_backspace), 'Logout', '/', context),
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

  ListTile addDrawerList(Icon icon, String title, navroute, context) {
    return ListTile(
      title: Text(title),
      leading: icon,
      onTap: () {
        Navigator.of(context).pushNamed(navroute);
      },
    );
  }
}
