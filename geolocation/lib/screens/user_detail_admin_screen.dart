import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocation/providers/auth.dart';
import 'package:geolocation/widgets/map.dart';
import 'package:provider/provider.dart';

import '../providers/userProvider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'report_screen.dart';

class UserDetailsAdmin extends StatefulWidget {
  static const routeName = '/userDetailsAdmin';

  @override
  _UserDetailsAdminState createState() => _UserDetailsAdminState();
}

class _UserDetailsAdminState extends State<UserDetailsAdmin> {
  Widget buildTile(Icon icon, String title, String value) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Container(
        child: ListTile(
          leading: icon,
          title: Text(title),
          subtitle: Text(value),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    print("user id in admin screen");
    print(id);
    final user = Provider.of<UserProvider>(context, listen: false);
    var isAdmin = Provider.of<Auth>(context, listen: false).isAdminCh;
    final User userSelected =user.getUser(id);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    var padding = MediaQuery.of(context).padding;
    double height1 = height - padding.top - padding.bottom;
    double heightMap = height1 / 3.25;
    return Scaffold(
        appBar: AppBar(
          title: Text('Details'),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              // Container(
              //   height: height1/3,
              //   width: width,
              //   // decoration: BoxDecoration(color: Colors.blueGrey),

              // ),
              Container(
                height: heightMap,
                width: width,
                child: Card(
                  elevation: 5,
                  child: MapScreen(userSelected),
                ),
              ),
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: heightMap - 80, right: 50),
                    height: 125,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 110,
                        width: 110,
                        child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100)),
                            child: ClipOval(
                              child: Image.network(
                                  'https://image.freepik.com/free-vector/profile-icon-male-avatar-hipster-man-wear-headphones_48369-8728.jpg'),
                            )),
                      ),
                    ),
                  ),
                  buildTile(
                      Icon(
                        Icons.person,
                        size: 30,
                      ),
                      'Name',
                      userSelected.name),
                  buildTile(Icon(Icons.work, size: 30), 'Designation',
                      userSelected.designation),
                  // buildTile(Icon(Icons.home, size: 30), 'Address',
                  //     userSelected.address),
                  buildTile(
                      Icon(Icons.mail, size: 30), 'Email', userSelected.email),
                  buildTile(Icon(Icons.phone, size: 30), 'Phone Number',
                      userSelected.phno),
                  SizedBox(
                    height: 12,
                  ),
                  RaisedButton(
                      child: Text(" get report"),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          ReportScreen.routeName,
                          arguments: id,
                        );
                      }),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
