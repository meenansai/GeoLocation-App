import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../providers/userProvider.dart';

class MapScreen extends StatefulWidget {
  User user;
  MapScreen(this.user);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(17.3850, 78.4867);
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    User userSelected = widget.user;
    return Stack(
      children: <Widget>[
        GoogleMap(
          // mapType: MapType.satellite,
          initialCameraPosition: CameraPosition(
            target: LatLng(userSelected.latitude, userSelected.longitude),
            zoom: 19,

            // tilt: 60,
            // bearing: 90,
          ),
          onMapCreated: _onMapCreated,
          markers: Set.from([
            Marker(
              
              markerId: MarkerId(userSelected.id + 'marker'),
              draggable: false,
              position: LatLng(userSelected.latitude, userSelected.longitude),
            )
          ]),
        ),
        // Padding(
        //       padding: const EdgeInsets.all(16.0),
        //       child: Align(
        //         alignment: Alignment.bottomRight,
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.end,
        //           children: <Widget> [
        //             FloatingActionButton(
        //               onPressed: () {
                        
        //               },
        //               materialTapTargetSize: MaterialTapTargetSize.padded,
        //               backgroundColor: Colors.transparent,
        //               child: const Icon(Icons.location_searching, size: 30.0),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
      ],
    );
  }
}
