import 'package:flutter/material.dart';
import 'package:geolocation/screens/adminmapscreen.dart';
import 'package:geolocation/widgets/appbarmenu.dart';
import 'package:provider/provider.dart';
import '../providers/userProvider.dart';
import '../widgets/admin_listTileItem.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  var _isinit = true;
  var _isLoading = false;
  var userName;
  void didChangeDependencies() {
    if (_isinit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<UserProvider>(context, listen: false).fetchItem().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    var usersList = Provider.of<UserProvider>(context,listen: false).users;
    return _isLoading
        ? Scaffold(
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            drawer: AppBarMenu(),
            appBar: AppBar(
              title: Text('Users'),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/'); 
                      
                      // setState(() {
                      //     Provider.of<UserProvider>(context, listen: false).fetchItem();
                      // });
                  
                     
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Refresh',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    )
                    // Icon(Icons.refresh,color: Colors.wh,),
                    ),
              ],
            ),
            body: Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: ListView.builder(
                      itemBuilder: (ctx, index) {
                        // print(usersList[index].isAdmin);
                        if(true){
                          return UserListItem(
                          userId: usersList[index].id,
                          userName: usersList[index].name,
                          latitude: usersList[index].latitude,
                          longitude: usersList[index].longitude,
                          designation: usersList[index].designation,
                        );
                        }
                      },
                      itemCount: usersList.length,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    textColor: Colors.black,
                    color: Colors.amber,
                    child: Text(
                      " View users on map",
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AdminMapScreen.routeName,
                      );
                    },
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ],
            ),

            // floatingActionButton:
            //     FloatingActionButton.extended(
            //       onPressed: () {},
            //       icon: Icon(Icons.person_pin_circle,color: Colors.white,),
            //       label: Text('Locate'),
            //     ),

            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
  }
}
