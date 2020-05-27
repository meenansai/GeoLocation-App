import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocation/providers/auth.dart';
import 'package:geolocation/widgets/map.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/userProvider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../utils/image_util.dart';

class UserDetails extends StatefulWidget {
  static const routeName = '/userdetails';

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  bool isImageSelected = false;
  Image imageFromPreferences;
  Future<File> imageFile;

  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
  }

  loadImageFromPreferences() {
    Utility.getImageFromPreferences().then((img) {
      if (null == img) {
        return;
      }
      setState(() {
        imageFromPreferences = Utility.imageFromBase64String(img);
      });
    });
  }

  Widget imageFromGallery() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          //print(snapshot.data.path);
          Utility.saveImageToPreferences(
              Utility.base64String(snapshot.data.readAsBytesSync()));
          return Image.file(
            snapshot.data,
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  Widget buildTile(Icon icon, String title, String value) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Container(
        child: ListTile(
          leading: icon,
          title: Text(title),
          subtitle: Text(value),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    print("user id in admin screen");
    print(id);
    final user = Provider.of<UserProvider>(context, listen: false);
    var isAdmin = Provider.of<Auth>(context, listen: false).isAdminCh;
    final User userSelected =
        isAdmin ? user.getUser(id) : Provider.of<Auth>(context).fetchedUser;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    var padding = MediaQuery.of(context).padding;
    double height1 = height - padding.top - padding.bottom;
    double heightMap = height1 / 3.25;
    return Scaffold(
        appBar: AppBar(
          title: Text('Details'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add_a_photo),
                onPressed: () {
                  print("three dots option pressed..");
                  pickImageFromGallery(ImageSource.gallery);
                  setState(() {
                    imageFromPreferences = null;
                  });
                  // fetching from preferences
                  loadImageFromPreferences();
                }),
          ],
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              isAdmin
                  ? Container(
                      height: heightMap,
                      width: width,
                      child: Card(
                        elevation: 5,
                        child: MapScreen(userSelected),
                      ),
                    )
                  : Container(
                      height: height1 / 3,
                      width: width,
                      decoration: BoxDecoration(color: Colors.blueGrey),
                    ),
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: heightMap - 80, right: 50),
                    height: 125,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 110,
                        width: 110,
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          child: ClipOval(
                            // child: isImageSelected
                            //     // ? Image.file('')
                            //     : Image.network(
                            //         'https://image.freepik.com/free-vector/profile-icon-male-avatar-hipster-man-wear-headphones_48369-8728.jpg'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  buildTile(
                      Icon(
                        Icons.person,
                        size: 30,
                      ),
                      'Name',
                      userSelected.name),
                  buildTile(Icon(Icons.work, size: 30), 'Designation',
                      userSelected.designation),
                  // buildTile(Icon(Icons.home, size: 30), 'Address',
                  //     userSelected.address),
                  buildTile(
                      Icon(Icons.mail, size: 30), 'Email', userSelected.email),
                  buildTile(Icon(Icons.phone, size: 30), 'Phone Number',
                      userSelected.phno),
                  SizedBox(
                    height: 20,
                  ),
                  // Container(
                  //   margin: EdgeInsets.all(20),
                  //   height: 400,
                  //   width: double.infinity,
                  //   child: Card(
                  //     elevation: 5,
                  //     child:
                  //     MapScreen(userSelected),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ));
  }
}
