// import 'dart:convert';
// import 'dart:async';
// import 'package:geolocation/providers/userProvider.dart';
// import 'package:http/http.dart' as http;

// import '';

// import 'package:provider/provider.dart';
// import '../providers/auth.dart';

// class Settings {
//   Future<Null> changePassword(String newPassword,String email) async {
//     const String API_KEY = 'AIzaSyC52wCS2ORAXuqU4g4mxqfmG22XGKWB0IQ';
//     final String changePasswordUrl =
//         'https://identitytoolkit.googleapis.com/v1/accounts:update?key=$API_KEY';
//     print("ChangePassword:Password: "+newPassword);
//     print("ChangePassword:email: " +email);
//     final Map<String, dynamic> payload = {
//       'email': email,
//       'password': newPassword,
//       'returnSecureToken': true
//     };

//     var resp=await http.patch(
//       changePasswordUrl,
//       body: json.encode(payload),
//       headers: {'Content-Type': 'application/json'},
//     );
//     print("password json response");
//     print(json.encode(resp.body));
//   }
//   // void _changePassword(String password) async{
//   //  //Create an instance of the current user. 
//   //   FirebaseUser user = await FirebaseAuth.instance.currentUser();

//   //   //Pass in the password to updatePassword.
//   //   user.updatePassword(password).then((_){
//   //     print("Succesfull changed password");
//   //   }).catchError((error){
//   //     print("Password can't be changed" + error.toString());
//   //     //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
//   //   });
//   // }
// }
