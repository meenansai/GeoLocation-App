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
  build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    final user = Provider.of<UserProvider>(context);
    final User userSelected = user.getUser(id);
    return Scaffold(
        // appBar: AppBar(
        //   title: Text("User Report"),
        // ),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.indigo, width: 10)),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 10)),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey, width: 10)),
              child: SingleChildScrollView(
                              child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 25),
                        child: Text('User Report',style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          fontFamily: 'Raleway'
                        ),)
                        ),
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
                                padding:
                                    const EdgeInsets.only(top: 28.0, left: 14.0),
                                child: SingleChildScrollView(
                                  child: Container(
                                    child: DataTable(
                                      rows: _createRows(snapshot.data),
                                      columns: [
                                        DataColumn(
                                          label: Text("Date"),
                                        ),
                                        DataColumn(
                                            label: Flexible(
                                                child: Text("Working Hours"))),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
      return [
        DataCell(Text(date.toString())),
        DataCell(Text(difference.toString() + " mins")),
      ].toList();
      // print(area);
    }
  }

  List<DataRow> _createRows(QuerySnapshot snapshot) {
    List<DataRow> newList =
        snapshot.documents.map((DocumentSnapshot documentSnapshot) {
      return new DataRow(cells: _createCellsForElement(documentSnapshot));
    }).toList();

    return newList;
  }
}
