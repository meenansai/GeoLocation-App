import 'dart:async';

import 'package:geolocation/models/http_exception.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/latlong.dart';

class ReportMapScreen extends StatefulWidget {
  static const routeName = "/reportmapscreen";
  @override
  State<StatefulWidget> createState() => ReportMapScreenState();
}

class ReportMapScreenState extends State<ReportMapScreen> {
  bool _isViewingRoutes = false;
  GoogleMapController mapController;
  double _originLatitude = 17.4401, _originLongitude = 78.3489;
  double _destLatitude = 18.8762165, _destLongitude = 79.998875;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> latlonglist = [];
  List<ReportLatLong> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyB0rtz2Q8ejgA63Yv0McdkDZWZ-_xyI8xs";
  bool _isLoading = false;
  bool _isinit = true;
  var uid;
  var dateSelected;
  @override
  void didChangeDependencies() async {
    if (_isinit) {
       
      Map<String, Object> arg = ModalRoute.of(context).settings.arguments;
      uid = arg['id'];
      dateSelected = arg['date'];
      setState(() {
        _isLoading = true;
      });
      try{
         await Provider.of<LatLongProvider>(context, listen: false)
          .fetchReports(uid, dateSelected);
      } on HttpException catch(error){
        showDialog(context:context,
        builder: (ctx) =>AlertDialog(
          content: Text(error.toString()),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: (){
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            })
          ],
        ) ,
         );
       
      }
        setState(() {
          _isLoading = false;
        });

    }
    _isinit = false;
     // setSourceAndDestinationIcons();
    
    // _addMarker(LatLng(_originLatitude, _originLongitude), "origin",
    //     BitmapDescriptor.defaultMarker);

    // /// destination marker
    // _addMarker(LatLng(_destLatitude, _destLongitude), "destination",
    //     BitmapDescriptor.defaultMarkerWithHue(90));
    _getPolyline();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
   
   
    // _addPolyLine();
  }
  @override
  void dispose() {
    polylines.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    polylineCoordinates =
        Provider.of<LatLongProvider>(context, listen: false).items;
    latlonglist = Provider.of<LatLongProvider>(context, listen: false).latlong;
    if (latlonglist.length != 0) {
      setState(() {
         _originLatitude = num.parse( latlonglist[0].latitude.toStringAsFixed(5));
      _originLongitude = num.parse( latlonglist[0].longitude.toStringAsFixed(5));
      _destLatitude = num.parse(latlonglist[latlonglist.length - 1].latitude.toStringAsFixed(5));
      _destLongitude = num.parse( latlonglist[latlonglist.length - 1].longitude.toStringAsFixed(5));
      });
     print(latlonglist);
    }
    
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Scaffold(
            appBar: AppBar(
              title: Text('Report'),
            ),
              body: GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(_originLatitude, _originLongitude),
                    zoom: 15),
                myLocationEnabled: true,
                tiltGesturesEnabled: true,
                compassEnabled: true,
                scrollGesturesEnabled: true,
                zoomGesturesEnabled: true,
                onMapCreated: _onMapCreated,
                // markers: Set<Marker>.of(markers.values),
                markers: Set<Marker>.of(
                  polylineCoordinates.map((e){
                    var index=latlonglist.indexWhere((element){
                      return element.latitude==e.latitude && element.longitude==e.longitude;
                    });
                    print(index);
                    var len=latlonglist.length;
                    // print('----------');
                    // print("origin lat"+_originLatitude.toString());
                    // print("origin long"+_originLongitude.toString());
                    // print("dest lat"+_destLatitude.toString());
                    // print("dest long"+_destLongitude.toString());
                    
                    // var a=num.parse(e.latitude.toStringAsFixed(5));
                    // var b=num.parse(e.longitude.toStringAsFixed(5));
                    // print(a);
                    // print(b);
                    if(index==0){
                    //   print("adding origin marker");
                    // print('----------');
                      return Marker(
                        icon:BitmapDescriptor.defaultMarkerWithHue(0),
                        markerId: MarkerId(e.id),
                        visible: true,
                        position: LatLng(e.latitude, e.longitude),
                        infoWindow: InfoWindow(
                          title: 'Start',
                          snippet: e.date,
                        ));
                    }
                    else if(index==len-1){
                    //   print("adding dest marker");
                    // print('----------');
                      return Marker(
                        icon:BitmapDescriptor.defaultMarkerWithHue(90),
                        markerId: MarkerId(e.id),
                        visible: true,
                        position: LatLng(e.latitude, e.longitude),
                        infoWindow: InfoWindow(
                          title: 'Time',
                          snippet: e.date,
                        ));
                    }
                    else{
                      // print("adding regular marker");
                      // print('----------');
                      return Marker(
                        markerId: MarkerId(e.id),
                        visible: true,
                        position: LatLng(e.latitude, e.longitude),
                        infoWindow: InfoWindow(
                          title: 'End',
                          snippet: e.date,
                        ));
                    } 
                  }
                  
                 )
                    .toList()),
                polylines: Set<Polyline>.of(polylines.values),
              )),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  // _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
  //   MarkerId markerId = MarkerId(id);
  //   Marker marker = Marker(
  //     markerId: markerId,
  //     icon: descriptor,
  //     position: position,
  //   );
  //   markers[markerId] = marker;
  // }

  _addPolyLine() {
    
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      width: 5,
      polylineId: id,
      color: Colors.blue,
      points: latlonglist,
      visible: true,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(_originLatitude, _originLongitude),
      PointLatLng(_destLatitude, _destLongitude),
      // travelMode: TravelMode.driving,
      // wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")]
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        latlonglist.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }
}
