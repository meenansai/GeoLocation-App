import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/userProvider.dart';

class ImageItem extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String date;
  final String uid;
  ImageItem(
    this.id,
    this.imageUrl,
    this.date,
    this.uid,
  );
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context,listen: false).getUser(uid);
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: GridTile(
        // header: Card(
        //   color: Theme.of(context).accentColor.withAlpha(250),
        //   elevation: 5,
        //   shape:
        //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        //   child: Text(
        //     DateFormat.yMEd().format(DateTime.parse(date)),
        //     textAlign: TextAlign.center,
        //   ),
        // ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: Card(
          color: Theme.of(context).accentColor,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 8,bottom: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      user.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  user.designation,
                  textAlign: TextAlign.center,
                ),
              ],
                ),
              ),
              Container(
                child: Text(DateFormat.yMEd().format(DateTime.parse(date)),
            textAlign: TextAlign.center,),
              )
            ],
          ),
        ),
      ),
    );
  }
}
