import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/image.dart';
import 'package:http/http.dart' as http;

class ImageProvider with ChangeNotifier {
  List<ImageM> _images = [];

  Future<void> fetchImages() async {
    List<ImageM> tempImagesList = [];
    const url = "https://geolocation-89f89.firebaseio.com/captured_images.json";
    try {
      final res = await http.get(url);
      var retData = json.decode(res.body) as Map<String, dynamic>;
      if (retData == null) {
        return;
      }
      retData.forEach((imageId, imageData) {
        tempImagesList.add(
          ImageM(
            id: imageId,
            imageUrl: imageData['imageUrl'],
            date: imageData['capturedDate'],
          )
        );
      });
      _images = tempImagesList;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<ImageM> get images {
    return [..._images];
  }
}
