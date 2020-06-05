import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocation/providers/userProvider.dart';
import 'package:intl/intl.dart';

import '../screens/report_map_screen.dart';
import '../widgets/design.dart';

class Report extends StatefulWidget {
  List<User> userList;
  Report(this.userList);
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  DateTime _dateTime;
  User _selectedUser;
  DateFormat dateFormat = new DateFormat('dd-MM-yyyy');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  _showSnackBar() {
    final snackBar = new SnackBar(
      content: Text(
        "select date to continue.",
        textAlign: TextAlign.center,
      ),
      duration: new Duration(seconds: 1),
      backgroundColor: Colors.red,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.userList);
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: <Widget>[
          MyHeader(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Color(0xFFE5E5E5),
              ),
            ),
            child: Row(
              children: <Widget>[
                Icon(Icons.person),
                SizedBox(width: 20),
                Expanded(
                  child: DropdownButton(
                    isExpanded: true,
                    underline: SizedBox(),
                    hint: Text('Select a User'),
                    icon: Icon(Icons.keyboard_arrow_down),
                    //  SvgPicture.asset("assets/icons/dropdown.svg"),
                    value: _selectedUser,
                    onChanged: (newValue) {
                      // print(newValue);
                      setState(() {
                        _selectedUser = newValue;
                      });
                    },
                    items: widget.userList.map((role) {
                      // print(role.name);
                      return DropdownMenuItem(
                        child: new Text(role.name),
                        value: role,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // SizedBox(
                  //   height: 30,
                  // ),
                  Text(
                    _dateTime == null
                        ? 'Choose Date'
                        : DateFormat('dd-MM-yyyy').format(_dateTime),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'RobotoCondensed',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: RaisedButton(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 15),
                                width: 250,
                                child: Text(
                                  'Pick a date',
                                  textAlign: TextAlign.center,
                                )),
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
                                      firstDate: DateTime.now()
                                          .subtract(Duration(days: 31)),
                                      lastDate: DateTime.now())
                                  .then((date) {
                                setState(() {
                                  print(date);
                                  _dateTime = date;
                                });
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: RaisedButton(
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 15),
                                width: 250,
                                child: Text(" Get Report",textAlign: TextAlign.center,)),
                              textColor: Colors.black,
                              color: Colors.amber,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              onPressed: () {
                                if (_dateTime != null) {
                                  print("date picked");
                                  Navigator.of(context).pushNamed(
                                    ReportMapScreen.routeName,
                                    arguments: {
                                      'id': _selectedUser.id,
                                      'date': _dateTime
                                    },
                                  );
                                } else {
                                  _showSnackBar();
                                }
                              }),
                        ),
                      ])
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
