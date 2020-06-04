import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
class ReportLatLong{
  String id;
  String date;
  double latitude;
  double longitude;
  ReportLatLong({this.id,this.date,this.latitude,this.longitude});
}

class LatLongProvider extends ChangeNotifier{
  List<ReportLatLong> _items=[
    // ReportLatLong(
    //   date: DateTime.now().toString(),
    //   latitude: 17.4401,
    //   longitude:  78.3489,
    // ),
    // ReportLatLong(
    //   date: DateTime.now().toString(),
    //   latitude: 17.4353381,
    //   longitude: 78.382804,
    // ),
    // ReportLatLong(
    //   date: DateTime.now().toString(),
    //   latitude: 17.3920,
    //   longitude: 78.3194,
    // ),
  ];
  List<ReportLatLong> get items{
    return [..._items];
  }
// List<LatLng> getLatlong(){
//     List<LatLng> temp=[];
//     _items.forEach((element) {
//       temp.add(LatLng(element.latitude, element.longitude));
//      });
//      return temp;
//   }
  List<LatLng> latlong=[];

  Future<void> fetchReports(uid,now) async {
    // var now = new DateTime.now();
  var formatter = new DateFormat('dd-MM-yyyy');
  String formatted = formatter.format(now);
    var url = "https://geolocation-1b35f.firebaseio.com/latlong/$uid/$formatted.json";
    List<ReportLatLong> tempReportList = [];
    List<LatLng> latlnglist=[];
    print("before");
    try {
      var response = await http.get(url);
      var retData = json.decode(response.body) as Map<String, dynamic>;
      if (retData == null) {
        return;
      }
      print("fetched data");
      print(retData);
      retData.forEach((prodId, prodData) {
        tempReportList.add(
          ReportLatLong(
            id: prodId,
            date: prodData['time'],
            latitude: prodData['latitude'],
            longitude: prodData['longitude']
          )
        );
        latlnglist.add(LatLng( prodData['latitude'], prodData['longitude']));
      });
      _items=tempReportList;
      latlong=latlnglist;
      print("items");
      print(_items);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}