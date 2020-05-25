import 'package:flutter/material.dart';

class ImageItem extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String date;
  ImageItem(
    this.id,
    this.imageUrl,
    this.date,
  );
  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.network(imageUrl, fit: BoxFit.cover,),
    );
  }
}
