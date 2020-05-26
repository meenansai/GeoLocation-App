import 'package:http/http.dart' as http;
import 'dart:convert';

class FirebaseData {
  static Future<void> updateLatLng(uid, latitude, longitude) async {
    var url =
        "https://geolocation-89f89.firebaseio.com/user_details/${uid}.json";
    await http.patch(url,
        body: json.encode({
          'latitude': latitude,
          'longitude': longitude,
        }));
    print("In FirebaseData: latitude: " + latitude.toString());
    print("In FirebaseData: longitude: " + longitude.toString());
  }

  static Future<void> uploadImage(imageUrl, capturedDate) async {
    var url = "https://geolocation-89f89.firebaseio.com/captured_images.json";
    await http.post(url,
        body: json.encode({
          'imageUrl': imageUrl,
          'capturedDate': capturedDate,
        }));
  }
}
