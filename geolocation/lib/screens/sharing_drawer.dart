import 'package:flutter/material.dart';

class SharingDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Scaffold.of(context).showSnackBar(SnackBar(
    //   content: Text('Can\'t show drawer while sharing..'),
    // ));
    //Navigator.of(context).pop();
    return Scaffold(
      appBar: AppBar(
        title: Text('DashBoard'),
      ),
      body: Center(
        child: Text('Dashboad not available while sharing'),
      ),
    );
  }
}
