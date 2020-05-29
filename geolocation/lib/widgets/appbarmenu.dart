import 'package:flutter/material.dart';
import 'package:geolocation/providers/userProvider.dart';
import 'package:geolocation/screens/images_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/usereditscreen.dart';

class AppBarMenu extends StatelessWidget {
  @override
  Widget buildMenuItems(Icon icon, String title, navroute, context) {
    return Container(
      child: ListTile(
        leading: icon,
        title: Text(title),
        onTap: () {
          Navigator.of(context).pushNamed(navroute);
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    var id=Provider.of<Auth>(context).userid;
    User admin=Provider.of<UserProvider>(context,listen: false).getUser(id);
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello, '+admin.name),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          SizedBox(
            height: 5,
          ),
          buildMenuItems(Icon(Icons.person_add), 'Add User',
              UserProdEditScreen.routeName, context),
          buildMenuItems(
              Icon(Icons.image), 'Images', ImageScreen.routeName, context),
          Container(
            child: ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Logout"),
              onTap: () {
                // Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
          ),
        ],
      ),
    );
  }
}
