import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class AdminMapScreen extends StatefulWidget {
   static const routeName = '/AdminMapScreen';
  @override
  _AdminMapScreenState createState() => _AdminMapScreenState();
}

class _AdminMapScreenState extends State<AdminMapScreen> {
  DatabaseReference _users =
      FirebaseDatabase.instance.reference().child('users');
      Set<Marker> markers = Set();
      Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(17.3850, 78.4867);
  BitmapDescriptor icon;
 Uint8List markerIcon;
  @override
  void initState() {
    getIcons();
    super.initState();
  }
getIcons() async {
    var icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 1.1,),
        "assets/images/markeruser.png");
   markerIcon = await getBytesFromAsset('assets/images/markeruser.png', 100);
    setState(() {
      this.icon = icon;
      this.markerIcon = markerIcon;
    });
  }
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec =
        await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
   }
  void _onMapCreated(GoogleMapController controller) {
     
    _controller.complete(controller);

    markers.forEach((element) {
      controller.showMarkerInfoWindow(element.markerId);
      print(element.markerId);
    });
   
    
    
    
  }
  @override
  Widget build(BuildContext context) {
    return Container(
//       child:GoogleMap(
//   onMapCreated: _onMapCreated,
//   myLocationEnabled: true,
//   initialCameraPosition:
//     CameraPosition(target: LatLng(0.0, 0.0)),
//   markers: markers,
// )
     child: StreamBuilder(
        stream: _users.onValue,
        builder: (context,snap){
          if (snap.hasData && !snap.hasError && snap.data.snapshot.value!=null) {
 
              
              DataSnapshot snapshot = snap.data.snapshot;
              print(snapshot.value);
              List item=[];
              
              var recdata =new Map<String, dynamic>.from(snapshot.value);
             
             
              recdata.forEach((index,f){
              if(f!=null){
              item.add(f);
              if( f['latitude']!= null){
              Marker resultMarker = Marker(
                    icon: BitmapDescriptor.fromBytes(markerIcon),
                    markerId: MarkerId(f['name']),
                    infoWindow: InfoWindow(
                    title: "${f['name']}",
                   ),
                    position: LatLng(f['latitude'],
                    f['longitude'])
                    ,
                  
                  );
                  
                
                  // print(resultMarker.markerId != null?resultMarker.markerId: 'no markerid' );
                  //  controller.showMarkerInfoWindow(MarkerId('hi'));
               
                  markers.add(resultMarker);
                  
                   }
                  }
                  }
                );
                return snap.data.snapshot.value == null
           
            ? SizedBox(): Container(child: GoogleMap(
                      
                      onMapCreated: _onMapCreated,
                      myLocationEnabled: true,
                      initialCameraPosition:
                        CameraPosition(target: LatLng(17.3850,78.4867),zoom: 7.0),
                      markers: markers,
                    ),);
                    
        }
        else {
          return   Center(child: CircularProgressIndicator());
          }

        },
      )
      
    );
  }
}