import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocation/providers/latlong.dart';
import 'package:geolocation/screens/sharing_drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../providers/auth.dart';
import '../utils/firebase_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import '../widgets/user_drawer.dart';
import 'package:provider/provider.dart';
import '../providers/userProvider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/homeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Location location = new Location();
  Map<String, double> currentLocation;
  // var latitude;
  // var longitude;
  // static var latTemp;
  // static var longTemp;
  static LatLng _initPosition;
  var _isinit = true;
  var _isSharing = false;
  var _isEnable = true;
  // var uid = "-M7cmD0uw4HoZ10pIrXX";

  ProgressDialog pr;

  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Location _cLocation = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;

  var _isLoading = false;
  var _isinits = true;
  User user;
  @override
  void didChangeDependencies() async {
    setState(() {
      _isLoading = true;
    });
    if (_isinits) {
      print("before calling fetch:");
      await Provider.of<Auth>(context, listen: false).fetchUser();
      setState(() {
        _isLoading = false;
      });
    }
    _isinits = false;
    super.didChangeDependencies();
  }

  var isLoading = false;
  //  void initState(){
  //    setState(() {
  //      isLoading=true;
  //    });
  //   Future.delayed(Duration.zero).then((value) async {
  //     await Provider.of<Auth>(context,listen: false).fetchUser();
  //     setState(() {
  //       isLoading=false;
  //     });
  //   });
  //   super.initState();
  // }

  @override
  void initState() {
    location.onLocationChanged().listen((value) {
      setState(() {
        _initPosition = LatLng(value.latitude, value.longitude);
        // print(currentLocation);
        // print(currentLocation);
      });
    });
    super.initState();
  }

  static final CameraPosition initialLocation = CameraPosition(
    // target: LatLng(37.42796133580664, -122.085749655962),
    target: _initPosition,
    zoom: 18.00,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context)
        .load("assets/images/navigation_marker.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      // circle = Circle(
      //     circleId: CircleId("car"),
      //     radius: newLocalData.accuracy,
      //     zIndex: 1,
      //     strokeColor: Colors.blue,
      //     center: latlng,
      //     fillColor: Colors.blue.withAlpha(70));
    });
  }

  void getCurrentLocation(String uid) async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged().listen((newLocalData) {
        if (_isSharing) {
          FirebaseData.updateLatLng(
              uid, newLocalData.latitude, newLocalData.longitude);
          Provider.of<Auth>(context, listen: false)
              .updateFetchedUser(newLocalData.latitude, newLocalData.longitude);
        }
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192.8334901395799,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                  zoom: 18.00)));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  //Camera Module
  StorageReference storageReference = FirebaseStorage.instance.ref();

  Future<void> _takePicture(String userId) async {
    var _imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    String fileName = path.basename(_imageFile.path);

    StorageReference ref = storageReference.child("/location_images");
    StorageUploadTask storageUploadTask =
        ref.child(fileName).putFile(_imageFile);
    if (storageUploadTask.isSuccessful || storageUploadTask.isComplete) {
      final String url = await ref.getDownloadURL();
      print("The download URL is " + url);
    } else if (storageUploadTask.isInProgress) {
      pr.show();
      storageUploadTask.events.listen((event) {
        double percentage = 100 *
            (event.snapshot.bytesTransferred.toDouble() /
                event.snapshot.totalByteCount.toDouble());
        if (percentage == 100.0) {
          pr.hide();
          _showSnackBar("Photo Uploaded Successfully");
        }
        print("THe percentage " + percentage.toString());
      });

      StorageTaskSnapshot storageTaskSnapshot =
          await storageUploadTask.onComplete;
      final downloadUrl1 = await storageTaskSnapshot.ref.getDownloadURL();
      FirebaseData.uploadImage(downloadUrl1, DateTime.now().toString(), userId);
      //Here you can get the download URL when the task has been completed.
      print("Download URL " + downloadUrl1.toString());
    } else {
      //Catch any cases here that might come up like canceled, interrupted
    }
  }

  //Display SnackBar
  _showSnackBar(String message) {
    final snackBar = new SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      duration: new Duration(seconds: 1),
      backgroundColor: Colors.green,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    var uid = Provider.of<Auth>(context, listen: false).userid;
    return _isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('Home'),
            ),
            key: _scaffoldKey,
            drawer: _isEnable ? UserDrawer(uid) : SharingDrawer(),
            body: _initPosition == null
                ? Center(child: CircularProgressIndicator())
                : Stack(
                    children: <Widget>[
                      GoogleMap(
                        // mapType: MapType.normal,
                        initialCameraPosition: initialLocation,
                        markers: Set.of((marker != null)
                            ? [marker]
                            : [
                                Marker(
                                  markerId: MarkerId("rakesh"),
                                  position: _initPosition,
                                )
                              ]),
                        // circles: Set.of((circle != null) ? [circle] : []),
                        onMapCreated: (GoogleMapController controller) {
                          _controller = controller;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        // padding: EdgeInsets.only(bottom: 5, left: 4),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              _isEnable
                                  ? FloatingActionButton(
                                      heroTag: "btn1",
                                      // label: Text("Share"),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.padded,
                                      backgroundColor:
                                          Theme.of(context).accentColor,
                                      child: const Icon(Icons.screen_share,
                                          size: 36.0),
                                      onPressed: () {
                                        _isEnable = false;
                                        getCurrentLocation(uid);
                                        _isSharing = true;
                                      },
                                    )
                                  : FloatingActionButton(
                                      heroTag: "btn2",
                                      //label: Text("Stop"),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.padded,
                                      backgroundColor: Colors.red,
                                      child: const Icon(Icons.stop_screen_share,
                                          size: 36.0),
                                      onPressed: () async {
                                        await Provider.of<Auth>(context,
                                                listen: false)
                                            .fetchUser();
                                        _isEnable = true;
                                        _isSharing = false;
                                      },
                                    ),
                              SizedBox(height: 16.0),
                              FloatingActionButton(
                                heroTag: "btn3",
                                //label: Text("Capture"),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.padded,
                                backgroundColor: Theme.of(context).accentColor,
                                child: const Icon(Icons.camera, size: 36.0),
                                onPressed: () => _takePicture(uid),
                              ),
                              SizedBox(height: 16.0),
                              FloatingActionButton(
                                heroTag: "btn4",
                                //label: Text("Capture"),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.padded,
                                backgroundColor: Theme.of(context).accentColor,
                                child: const Icon(Icons.share, size: 36.0),
                                onPressed: () async {
                                  // Scaffold.of(context).hideCurrentSnackBar();
                                  // Scaffold.of(context).showSnackBar(SnackBar(
                                  //   content: Text(
                                  //       "Reported successfully to the admin"),
                                  //   duration: Duration(seconds: 1),
                                  // ));
                                  var currentLocation =
                                      await _cLocation.getLocation();
                                  Provider.of<LatLongProvider>(context,
                                          listen: false)
                                      .addReport(uid, currentLocation.latitude,
                                          currentLocation.longitude)
                                      .then((value) {
                                    _showSnackBar("Report added successfully");
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          );
  }
}
