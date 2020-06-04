import 'package:flutter/material.dart';
import '../screens/user_detail_admin_screen.dart';
import 'package:provider/provider.dart';
import '../providers/userProvider.dart';
import 'package:geocoder/geocoder.dart';
class UserListItem extends StatefulWidget {
  final String userId;
  final String userName;
  final double latitude;
  final double longitude;
  final String designation;
  UserListItem(
      {this.designation,
      this.userId,
      this.userName,
      this.latitude,
      this.longitude});

  @override
  _UserListItemState createState() => _UserListItemState();
}

class _UserListItemState extends State<UserListItem> {
  List<Address> results = [];
  var street;
  var area;

  addressFromCoordinates(latitude, longitude) {
    final coordinates = new Coordinates(latitude, longitude);
    findAdress(coordinates);
    street = this.street;
    area = this.area;
  }

  Future<void> findAdress(Coordinates coordinates) async {
    try {
      var results =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = results.first;
      var street = first.featureName;
      var area = first.subLocality;
      this.setState(() {
        this.results = results;
        this.street = street;
        this.area = area;
      });
      // print(area);
    } catch (e) {
      print("Error occured: $e");
    }
  }

  @override
  void initState() {
    addressFromCoordinates(widget.latitude, widget.longitude);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    
    var isAdmin=Provider.of<UserProvider>(context,listen: false).isAdmin(widget.userId);
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            UserDetailsAdmin.routeName,
            arguments: widget.userId,
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
          child: ListTile(
            leading: CircleAvatar(
              maxRadius: 25,
              child: FittedBox(
                child:
                    Text(
                      widget.userName.substring(0, 1).toUpperCase(),
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                    ),
              ),
            ),
            title: Row(
              children: <Widget>[
                Text(
                  widget.userName,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                SizedBox(
                  width: 5,
                ),
                
                Provider.of<UserProvider>(context,listen: false).isAdmin(widget.userId)?
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(205, 247, 217, 1),
                      borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(5), right: Radius.circular(5)),
                    ),
                    child: Text(
                      'Admin',
                      style: TextStyle(
                          fontSize: 10, color: Color.fromRGBO(22, 133, 16, 1)),
                    ),
                  )
                  :Container(),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.designation,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                // Row(
                //   children: <Widget>[
                //     Text(widget.latitude.toString()),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     Text(widget.longitude.toString()),
                //   ],
                // ),
                Row(
                  children: <Widget>[
                    Text(
                        ((street!=null || area!=null)) ? street + ", "+ area : ""),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    // Text(widget.longitude.toString()),
                  ],
                ),
              ],
            ),
            trailing:
                IconButton(icon: Icon(Icons.chevron_right), onPressed: null),
          ),
        ),
      ),
    );
  }
}
