import 'package:http/http.dart' as http;
import 'dart:convert';

class MapUtil {
  static Future<void> updateLatLng(uid, latitude, longitude) async {
    var url =
        "https://geolocation-89f89.firebaseio.com/user_details/${uid}.json";
    await http.patch(url,
        body: json.encode({
          'latitude': latitude,
          'longitude': longitude,
        }));
        print("In MapUtil: latitude: " +latitude.toString());
        print("In MapUtil: longitude: " +longitude.toString());
  }
}
