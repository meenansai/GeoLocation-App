// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:geolocation/providers/auth.dart';
import 'package:geolocation/screens/report_map_screen.dart';
import 'package:geolocation/widgets/map.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/userProvider.dart';

import 'report_screen.dart';

class UserDetailsAdmin extends StatefulWidget {
  static const routeName = '/userDetailsAdmin';

  @override
  _UserDetailsAdminState createState() => _UserDetailsAdminState();
}

class _UserDetailsAdminState extends State<UserDetailsAdmin> {
  DateTime _dateTime;
  DateFormat dateFormat = new DateFormat('dd-MM-yyyy');
  
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
    final User userSelected = user.getUser(id);
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
                                child: userSelected.profilePicture == null
                                    ? Image.network(
                                        'https://image.freepik.com/free-vector/profile-icon-male-avatar-hipster-man-wear-headphones_48369-8728.jpg')
                                    : Image.network(
                                        userSelected.profilePicture))),
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
                  Column(
                    children: <Widget>[
                      Text(
                        _dateTime == null
                            ? 'Choose Date'
                            : _dateTime.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'RobotoCondensed',
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: RaisedButton(
                                child: Text('Pick a date'),
                                textColor: Colors.black,
                                color: Colors.amber,
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                onPressed: () {
                                  showDatePicker(
                                          context: context,
                                          initialDate: _dateTime == null
                                              ? DateTime.now()
                                              : _dateTime,
                                          firstDate: DateTime.now().subtract(Duration(days: 31)),
                                          lastDate: DateTime.now())
                                      .then((date) {
                                    setState(() {  
                                      _dateTime =date;
                                    });
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: RaisedButton(
                                  child: Text(" Get Report"),
                                  textColor: Colors.black,
                                  color: Colors.amber,
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                  ),
                                  onPressed: () {
                                    if (_dateTime != null) {
                                      Navigator.of(context).pushNamed(
                                        ReportMapScreen.routeName,
                                        arguments: {
                                          'id': id,
                                          'date': _dateTime
                                        },
                                      );
                                    } else {
                                      print("Get Report: date: " +
                                          _dateTime.toString());
                                      // Scaffold.of(context)
                                      //     .showSnackBar(SnackBar(
                                      //   content: Text(
                                      //       'Select the date to Continue.'),
                                      //   duration: Duration(seconds: 1),
                                      // ));
                                    }
                                  }),
                            ),
                          ])
                    ],
                  ),
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
