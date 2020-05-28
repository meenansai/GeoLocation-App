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
      var street ;
      var area ;
       var button = "today";
        
        @override
        Widget build(BuildContext context) {
           
         
          final id = ModalRoute.of(context).settings.arguments;
    final user = Provider.of<UserProvider>(context);
    final User userSelected = user.getUser(id);
          return Scaffold(
            appBar: AppBar(
              title:Text("User Report") ,
            ),
            body: Column(
              children: <Widget>[
                
                // Padding(
                //   padding: const EdgeInsets.only(top:30.0, left:2.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: <Widget>[
                //     RaisedButton(
                     
                      
                //       child: Text("Today"),
                //       onPressed: () => {button = "Today"},
                //     ),
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
                        stream:  Firestore.instance
                        .collection('Reports')
                        .document(userSelected.id)
                        .collection('userReports')
                        
                       
                        .snapshots(),
                        builder: ( context,  snapshot) {
                          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                          
                          return 
                          Padding(
                            padding: const EdgeInsets.only(top:28.0,left: 14.0),
                            child: SingleChildScrollView(
                             child: Container(
                                
                                child: DataTable(
                            rows:
                              _createRows(snapshot.data),
                      
                       columns: [
                                DataColumn(
                                  label: Text("Date"),
                                ),
                                DataColumn(
                                  label: Flexible(child: Text("Working Hours"))
                                ),
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
            ));
                  }
                
                  _createCellsForElement(DocumentSnapshot documentsnapshot) {

                   
                      final start = DateTime.parse(documentsnapshot["signOut"].toDate().toString());
                      final stop =  DateTime.parse(documentsnapshot["signOut"].toDate().toString());
                      final date = DateFormat("dd-MMM-yyyy").format(start);
                      final difference = stop.difference(start).inHours;
                      var s1,a1;
                        
                       if(documentsnapshot["currentLat"] != null && documentsnapshot["currentLong"] != null){
                        final coordinates = new Coordinates(documentsnapshot["currentLat"],documentsnapshot["currentLong"] );
                        findAdress(coordinates);
                        s1 = this.street;
                        a1 = this.area;
                     }

                    
                            return [
                              DataCell(Text(date.toString())),
                              DataCell( Text(difference.toString() + " hours")),
                              DataCell( Text(s1 != null? s1: "not available")),
                              
                              DataCell( Text(a1 != null?a1 : "not available")),
                            ].toList();
                  

                          }
                                
                                 List<DataRow> _createRows(QuerySnapshot snapshot) {
                      
                          List<DataRow> newList = snapshot.documents.map((DocumentSnapshot documentSnapshot) {
                            return new DataRow(cells: _createCellsForElement(documentSnapshot));
                                }).toList();
                            
                                return newList;
                              }
                      
                         findAdress(Coordinates coordinates) async {
                              try{
                            var results = await Geocoder.local.findAddressesFromCoordinates(coordinates);
                            var first = results.first;
                          var street = first.featureName;
                          var area= first.subLocality;
                                            this.setState(() {
                                              this.results = results;
                                              this.street =street;
                                              this.area = area;
                                            });
                                            // print(area);
                                          }
                                          catch(e) {
                                            print("Error occured: $e");
    }
                                                                          }
                          
                            
}