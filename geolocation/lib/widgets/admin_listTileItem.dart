import 'package:flutter/material.dart';
import 'package:geolocation/providers/auth.dart';
import '../screens/user_detail_admin_screen.dart';
import 'package:provider/provider.dart';
import '../screens/userDetailsScreen.dart';
import '../providers/userProvider.dart';
class UserListItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            UserDetailsAdmin.routeName,
            arguments: userId,
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
                      userName.substring(0, 1).toUpperCase(),
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                    ),
              ),
            ),
            title: Row(
              children: <Widget>[
                Text(
                  userName,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                SizedBox(
                  width: 5,
                ),
                
                Provider.of<UserProvider>(context,listen: false).isAdmin(userId)?
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
                  designation,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(latitude.toString()),
                    SizedBox(
                      width: 10,
                    ),
                    Text(longitude.toString()),
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
