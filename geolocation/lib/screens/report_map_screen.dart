import 'dart:async';

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
      await Provider.of<LatLongProvider>(context, listen: false)
          .fetchReports(uid, dateSelected)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isinit = false;
    _getPolyline();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    // // setSourceAndDestinationIcons();
    // _addMarker(LatLng(_originLatitude, _originLongitude), "origin",
    //     BitmapDescriptor.defaultMarker);

    // /// destination marker
    // _addMarker(LatLng(_destLatitude, _destLongitude), "destination",
    //     BitmapDescriptor.defaultMarkerWithHue(90));

   
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
      _originLatitude = latlonglist[0].latitude;
      _originLongitude = latlonglist[0].longitude;
      _destLatitude = latlonglist[latlonglist.length - 1].latitude;
      _destLongitude = latlonglist[latlonglist.length - 1].longitude;
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
                markers: Set<Marker>.of(polylineCoordinates
                    .map((e) => Marker(
                        markerId: MarkerId('123'),
                        visible: true,
                        position: LatLng(e.latitude, e.longitude),
                        infoWindow: InfoWindow(
                          title: 'Time',
                          snippet: e.date,
                        )))
                    .toList()),
                polylines: Set<Polyline>.of(polylines.values),
              )),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      icon: descriptor,
      position: position,
    );
    markers[markerId] = marker;
  }

  _addPolyLine() {
    print('adding polyline');
    print(latlonglist);
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
    print(latlonglist);
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(_originLatitude, _originLongitude),
      PointLatLng(_destLatitude, _destLongitude),
      // travelMode: TravelMode.driving,
      // wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")]
    );
    print('polyline result');
    print(result.points);
    if (result.points.isNotEmpty) {
      print('entered');
      result.points.forEach((PointLatLng point) {
        latlonglist.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }
}
