import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Auth with ChangeNotifier {
  String _token;
  DateTime _expirydate;
  String _userId;
  Timer authTimer;
  bool isadminCheck;
  String _extraToken;
  DateTime _extraExpiryDate;
  String _extraUserId;
  
 
  // Future<void> _authenticate(email, password, type) async {
  //   final url =
  //       'https://identitytoolkit.googleapis.com/v1/accounts:$type?key=AIzaSyC52wCS2ORAXuqU4g4mxqfmG22XGKWB0IQ';
  //   try {
  //     final response = await http.post(url,
  //         body: json.encode({
  //           'email': email,
  //           'password': password,
  //           'returnSecureToken': true,
  //         }));
  //     final respData = json.decode(response.body);
  //     if (respData['error'] != null) {
  //       throw HttpException(respData['error']['message']);
  //     }
  //     _token = respData['idToken'];
  //     _userId = respData['localId'];
  //      var urls="https://geolocation-89f89.firebaseio.com/users/$_userId/isAdmin.json";
  //     final resp=await http.get(urls);
  //     isadminCheck=json.decode(resp.body);
  //     _expirydate = DateTime.now().add(Duration(
  //       seconds: int.parse(respData['expiresIn']),
  //     ));
  //     autologout();
  //     notifyListeners();
  //   var prefs=await SharedPreferences.getInstance();
  //   final userData=json.encode({
  //     'token':_token,
  //     'userId':_userId,
  //     'expirydate':_expirydate.toIso8601String(),
  //   });
  //   prefs.setString('userData', userData);
  //   prefs.setBool('isAdmin', isadminCheck);
  //   } catch (error) {
  //     print("exception caused here: - "+error.toString());
  //     throw error;
  //   }
  // }
  String get token {
    if (_expirydate != null &&
        _token != null &&
        _expirydate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  bool get isAuth {
    return token != null;
  }
   String get userid{
    return _userId;
  }

  String get extraUserId{
    return _extraUserId;
  }

  bool get isAdminCh{
    print("checking admin");
    print(isadminCheck);
    return isadminCheck;
  }
  Future<String> fetchUid() async{
    var temp=await _userId;
    return temp;
  }

 
  // static Future<bool> isAdmin() async{
  //   var urls="https://geolocation-89f89.firebaseio.com/users/$_userId/isAdmin.json";
  //   final response=await http.get(urls);
  //   var isAdminVal=json.decode(response.body);
  //   print(isAdminVal);
  //   return Future<bool>.value(isAdminVal);
  // }
  Future<void> signup(String email, String password) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyC52wCS2ORAXuqU4g4mxqfmG22XGKWB0IQ';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final respData = json.decode(response.body);
      if (respData['error'] != null) {
        throw HttpException(respData['error']['message']);
      }
      _extraToken = respData['idToken'];
      _extraUserId = respData['localId'];
      print(_extraUserId+"   after resp userId");
      _extraExpiryDate = DateTime.now().add(Duration(
        seconds: int.parse(respData['expiresIn']),
      ));
      autologout();
      notifyListeners();

    } catch (error) {
      print("exception caused here: - "+error.toString());
      throw error;
    }
    // return _authenticate(email, password, 'signUp');
  }
  Future<void> login(email,password) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyC52wCS2ORAXuqU4g4mxqfmG22XGKWB0IQ';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final respData = json.decode(response.body);
      if (respData['error'] != null) {
        throw HttpException(respData['error']['message']);
      }
      _token = respData['idToken'];
      _userId = respData['localId'];
       var urls="https://geolocation-89f89.firebaseio.com/users/$_userId/isAdmin.json";
      final resp=await http.get(urls);
      isadminCheck=json.decode(resp.body);
      _expirydate = DateTime.now().add(Duration(
        seconds: int.parse(respData['expiresIn']),
      ));
      autologout();
      notifyListeners();
    var prefs=await SharedPreferences.getInstance();
    final userData=json.encode({
      'token':_token,
      'userId':_userId,
      'expirydate':_expirydate.toIso8601String(),
    });
    prefs.setString('userData', userData);
    prefs.setBool('isAdmin', isadminCheck);
    } catch (error) {
      print("exception caused here: - "+error.toString());
      throw error;
    }
    // return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async{
    print("trying auto login.............");
    final prefs=await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }
    final extractedData=json.decode( prefs.getString('userData')) as Map<String,Object>;
    final expiryDate=DateTime.parse(extractedData['expirydate']);
    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }
    _token=extractedData['token'];
    _userId=extractedData['userId'];
    _expirydate=expiryDate;
     var urls="https://geolocation-89f89.firebaseio.com/users/$_userId/isAdmin.json";
      final resp=await http.get(urls);
      isadminCheck=json.decode(resp.body);
    notifyListeners();
    autologout();
    return true;
  }
  Future<void> logout() async{
    print(_token+"before");
    _token=null;
    _userId=null;
    _expirydate=null;
    if(authTimer!=null){
      authTimer.cancel();
    }
    print(_token);
    notifyListeners();
    var prefs=await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autologout(){

    if(authTimer!=null){
      authTimer.cancel();
    }
    final timeToExpiry=_expirydate.difference(DateTime.now()).inSeconds;
    authTimer=Timer(Duration(seconds:timeToExpiry ),logout);

  }
}
