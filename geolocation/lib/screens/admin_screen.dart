import 'package:flutter/material.dart';
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
    var usersList = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      drawer: AppBarMenu(),
      appBar: AppBar(
        title: Text('Users'),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context,'/');
            },
            child:Row(
              children: [
                Icon(Icons.refresh,color: Colors.white,),
                SizedBox(
                  width: 5,
                ),
                Text('Refresh',style: TextStyle(
                  color: Colors.white,
                  fontSize: 15
                ),),
              ],
            ) 
            // Icon(Icons.refresh,color: Colors.wh,),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  return UserListItem(
                    userId: usersList.users[index].id,
                    userName: usersList.users[index].name,
                    latitude: usersList.users[index].latitude,
                    longitude: usersList.users[index].longitude,
                    designation: usersList.users[index].designation,
                  );
                },
                itemCount: usersList.users.length,
              ),
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
