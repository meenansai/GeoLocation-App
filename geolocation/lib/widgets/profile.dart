import 'package:flutter/material.dart';
import '../providers/userProvider.dart';
import '../screens/adminmapscreen.dart';
import '../widgets/admin_listTileItem.dart';

class Profile extends StatelessWidget {
  const Profile({
    Key key,
    @required this.usersList,
  }) : super(key: key);

  final List<User> usersList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  // print(usersList[index].isAdmin);
                  if (true) {
                    return UserListItem(
                      userId: usersList[index].id,
                      userName: usersList[index].name,
                      latitude: usersList[index].latitude,
                      longitude: usersList[index].longitude,
                      designation:
                          usersList[index].designation,
                    );
                  }
                },
                itemCount:usersList.length,
              ),
            ),
          ),
         
        ],
      ),
      floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton.extended(
              // textColor: Colors.black,
              backgroundColor: Colors.amber,
              label: Text(
                " View users on map",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AdminMapScreen.routeName,
                );
              },
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0),
              ),
            ),
    );
  }
}
