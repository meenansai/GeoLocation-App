import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class ImageM {
  String id;
  final String imageUrl;
  final String date;
  final String uid;

  ImageM({
    this.id,
    @required this.imageUrl,
    @required this.date,
    this.uid,
  });

}

class ImageProviders with ChangeNotifier {
  List<ImageM> _loadedImages = [
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
  List<ImageM> get images {
    return [..._loadedImages];
  }
  Future<void> fetchImages() async {
    List<ImageM> tempImagesList = [];
    const url = "https://geolocation-89f89.firebaseio.com/captured_images.json";
    try {
      final res = await http.get(url);
      var retData = json.decode(res.body) as Map<String, dynamic>;
      if (retData == null) {
        return;
      }
      print('retrived data of images');
      print(retData);
      retData.forEach((imageId, imageData) {
        tempImagesList.add(
          ImageM(
            id: imageId,
            imageUrl: imageData['imageUrl'],
            date: imageData['capturedDate'],
            uid: imageData['userId'],
          )
        );
      });
      _loadedImages = tempImagesList.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  
}
