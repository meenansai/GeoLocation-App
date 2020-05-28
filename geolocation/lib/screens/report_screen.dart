import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocation/providers/userProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatefulWidget {
  static const routeName = '/ReportScreen';
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<Address> results = [];
  var street;
  var area;
  var button = "today";

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    final user = Provider.of<UserProvider>(context);
    final User userSelected = user.getUser(id);
    return Scaffold(
        appBar: AppBar(
          title: Text("User Report"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Padding(
              //   padding: const EdgeInsets.only(top:30.0, left:2.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: <Widget>[
              //     RaisedButton(

              //       child: Text("Today"),
              //     RaisedButton(
              //       child: Text("Week"),
              //      onPressed: () => button = "Week",
              //     ),
              //     RaisedButton(

              //       child: Text("Month"),
              //       onPressed: () => button = "Month",
              //     ),
              //   ],),
              // ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('Reports')
                        .document(id)
                        .collection('userReports')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Center(child: CircularProgressIndicator());

                      return Padding(
                        padding: const EdgeInsets.only(top: 28.0, left: 14.0),
                        child: SingleChildScrollView(
                          child: Container(
                            child: DataTable(
                              rows: _createRows(snapshot.data),
                              columns: [
                                DataColumn(
                                  label: Text("Date"),
                                ),
                                DataColumn(
                                    label:
                                        Flexible(child: Text("Working Hours"))),
                                DataColumn(
                                  label: Text("Street"),
                                ),
                                DataColumn(
                                  label: Text("Area"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ));
  }

  _createCellsForElement(DocumentSnapshot documentsnapshot) {
    final start =
        DateTime.parse(documentsnapshot["signIn"].toDate().toString());
    final stop =
        DateTime.parse(documentsnapshot["signOut"].toDate().toString());
    final date = DateFormat("dd-MMM-yyyy").format(start);
    final difference = stop.difference(start).inMinutes;
    var s1, a1;

    if (documentsnapshot["currentLat"] != null &&
        documentsnapshot["currentLong"] != null) {
      final coordinates = new Coordinates(
          documentsnapshot["currentLat"], documentsnapshot["currentLong"]);
      print('co-ordiates');
      print(coordinates);
      findAdress(coordinates);
      // setState(() {
      // s1 = null ? '' : street;
      // a1 = area;
      // });
      // s1=coordinates.latitude.toString();
      // a1=coordinates.longitude.toString();
    }

    return [
      DataCell(Text(date.toString())),
      DataCell(Text(difference.toString() + " mins")),
      DataCell(Text(street != null ? street : "not available")),
      DataCell(Text(area != null ? area : "not available")),
    ].toList();
  }

  List<DataRow> _createRows(QuerySnapshot snapshot) {
    List<DataRow> newList =
        snapshot.documents.map((DocumentSnapshot documentSnapshot) {
      return new DataRow(cells: _createCellsForElement(documentSnapshot));
    }).toList();

    return newList;
  }

  findAdress(Coordinates coordinates) async {
    try {
      var results =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = results.first;
      var street = first.featureName;
      var area = first.subLocality;
      setState(() {
        results = results;
        street = street;
        area = area;
      });
      // print(area);
    } catch (e) {
      print("Error occured: $e");
    }
  }
}
