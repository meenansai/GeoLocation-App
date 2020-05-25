// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';

// Future<Null> changePassword(String newPassword) async {
//   const String API_KEY = 'AIzaSyC52wCS2ORAXuqU4g4mxqfmG22XGKWB0IQ';
//   final String changePasswordUrl =
//       'https://www.googleapis.com/identitytoolkit/v3/relyingparty/setAccountInfo?key=$API_KEY';

//       final String idToken = await user.getIdToken();

//     final Map<String, dynamic> payload = {
//       'email': idToken,
//       'password': newPassword,
//       'returnSecureToken': true
//     };

//   await http.post(changePasswordUrl, 
//     body: json.encode(payload), 
//     headers: {'Content-Type': 'application/json'},  
//   );
// }