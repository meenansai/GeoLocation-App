import 'package:flutter/material.dart';
import 'package:geolocation/models/image.dart';
import 'package:geolocation/widgets/image_item.dart';

class ImageScreen extends StatefulWidget {
  static const routeName = '/image_screen';
  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  List<ImageM> loadedImages = [
    ImageM(
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/geolocation-89f89.appspot.com/o/location_images%2Fscaled_ae611b5d-4754-4018-b098-3b8f0d1f68e61003224249665274807.jpg?alt=media&token=7ee84853-0652-4614-8d72-43822c2723f9',
        date: '2020-05-25 17:34:46.438593',
        id: '-M8Ai8hkCKxEDVPg3WrP'),
    ImageM(
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/geolocation-89f89.appspot.com/o/location_images%2Fscaled_54a09fdf-8448-4721-a021-87c7444a132c1960422610992329563.jpg?alt=media&token=9dffb490-705a-4d3f-a89f-23a6bfa91363',
        date: '2020-05-25 17:34:46.438593',
        id: '-M8Ai8hkCKxEDVPg3WrP'),
    ImageM(
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/geolocation-89f89.appspot.com/o/location_images%2Fscaled_83a78dc4-ae4d-4a0e-9079-d7d75fcb70615080970696811668009.jpg?alt=media&token=055f75bd-c666-4faf-9737-8010d3c33e25',
        date: '2020-05-25 17:34:46.438593',
        id: '-M8Ai8hkCKxEDVPg3WrP'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Images"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: loadedImages.length,
        itemBuilder: (ctx, i) => ImageItem(
          loadedImages[i].id,
          loadedImages[i].imageUrl,
          loadedImages[i].date,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }
}
