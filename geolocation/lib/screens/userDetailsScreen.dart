import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocation/providers/auth.dart';
import 'package:geolocation/utils/firebase_data.dart';
import 'package:geolocation/widgets/map.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/userProvider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../utils/image_util.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class UserDetails extends StatefulWidget {
  static const routeName = '/userdetails';

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  ProgressDialog pr;
  bool isImageSelected = false;
  Image imageFromPreferences;
  File _imageFile;

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

  //Camera Module picking from gallery
  StorageReference storageReference = FirebaseStorage.instance.ref();

  Future<void> _pickPicture(String userId) async {
    var _imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );

    String fileName = path.basename(_imageFile.path);

    StorageReference ref = storageReference.child("/profile_photos");
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
        }
        print("THe percentage " + percentage.toString());
      });

      StorageTaskSnapshot storageTaskSnapshot =
          await storageUploadTask.onComplete;
      final downloadUrl1 = await storageTaskSnapshot.ref.getDownloadURL();
      FirebaseData.uploadProfilePic(userId, downloadUrl1);
      //Here you can get the download URL when the task has been completed.
      print("Download URL " + downloadUrl1.toString());
    } else {
      //Catch any cases here that might come up like canceled, interrupted
    }
  }

  Widget buildTile(Icon icon, String title, String value) {
    return Container(
      child: ListTile(
        leading: icon,
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    final id = ModalRoute.of(context).settings.arguments;
    print("user id in admin screen");
    print(id);
    // final user = Provider.of<UserProvider>(context, listen: false);
    // var isAdmin = Provider.of<Auth>(context, listen: false).isAdminCh;
    var userDetails = Provider.of<Auth>(context).fetchedUser;
    final User userSelected = userDetails;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    var padding = MediaQuery.of(context).padding;
    double height1 = height - padding.top - padding.bottom;
    double heightMap = height1 / 3.25;

    if (userDetails.profilePicture != null) {
      setState(() {
        isImageSelected = true;
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Details'),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        top: heightMap / 20,
                        right: width / 50,
                      ),
                      height: 200,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 180,
                          width: 180,
                          child: Stack(
                            children: [
                              Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: isImageSelected
                                        ? DecorationImage(
                                            image: NetworkImage(
                                              userDetails.profilePicture,
                                            ),
                                            fit: BoxFit.fill,
                                          )
                                        : DecorationImage(
                                            image: NetworkImage(
                                                'https://image.freepik.com/free-vector/profile-icon-male-avatar-hipster-man-wear-headphones_48369-8728.jpg'),
                                            fit: BoxFit.fill,
                                          ),
                                  )),
                              Align(
                                alignment:Alignment.bottomRight,
                                child: FloatingActionButton(
                                  // backgroundColor:Colors.teal,
                                    child: Icon(Icons.add_a_photo),
                                    onPressed: () {
                                      _pickPicture(id);
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    buildTile(
                        Icon(
                          Icons.person,
                          size: 30,
                          color: Theme.of(context).accentColor,
                        ),
                        'Name',
                        userSelected.name),
                    Divider(),
                    buildTile(
                        Icon(
                          Icons.work,
                          size: 30,
                          color: Theme.of(context).accentColor,
                        ),
                        'Designation',
                        userSelected.designation),
                    Divider(),
                    // buildTile(Icon(Icons.home, size: 30), 'Address',
                    //     userSelected.address),
                    buildTile(
                        Icon(
                          Icons.mail,
                          size: 30,
                          color: Theme.of(context).accentColor,
                        ),
                        'Email',
                        userSelected.email),
                    Divider(),
                    buildTile(
                        Icon(
                          Icons.phone,
                          size: 30,
                          color: Theme.of(context).accentColor,
                        ),
                        'Phone Number',
                        userSelected.phno),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ));
  }
}

class MyClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    // TODO: implement getClip
    return Rect.fromLTWH(0, 0, 200, 0);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
