import 'dart:convert';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class User {
  String id;
  final String name;
  final String address;
  final String designation;
  double latitude;
  double longitude;
  final String email;
  final String phno;
  final String profilePicture;
  bool isAdmin;

  User({
    this.profilePicture,
    this.isAdmin,
    this.id,
    this.name,
    this.address,
    this.designation,
    this.email,
    this.latitude,
    this.longitude,
    this.phno,
  });
}

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  Future<void> additem(User newuser, userId) async {
    var url = "https://geolocation-1b35f.firebaseio.com/users/$userId.json";
    // ?auth=$authToken
    try {
      final response = await http.put(url,
          body: json.encode({
            'name': newuser.name,
            'designation': newuser.designation,
            'email': newuser.email,
            'phone': newuser.phno,
            'isAdmin': newuser.isAdmin,
          }));

      _users.add(User(
        id: userId,
        designation: newuser.designation,
        email: newuser.email,
        isAdmin: newuser.isAdmin,
        name: newuser.name,
        phno: newuser.phno,
      ));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchItem() async {
    var url = "https://geolocation-1b35f.firebaseio.com/users.json";
    List<User> tempUserList = [];
    try {
      var response = await http.get(url);
      var retData = json.decode(response.body) as Map<String, dynamic>;
      if (retData == null) {
        return;
      }
      print("fetched data");
      print(retData);
      retData.forEach((prodId, prodData) {
        tempUserList.add(User(
          id: prodId,
          name: prodData['name'],
          email: prodData['email'],
          address: prodData['address'],
          designation: prodData['designation'],
          latitude: prodData['latitude'],
          longitude: prodData['longitude'],
          phno: prodData['phone'],
          isAdmin: prodData['isAdmin'],
          profilePicture: prodData['profile_photo']==null?null:prodData['profile_photo'],
        ));
      });
      _users = tempUserList;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<User> get users {
    return [..._users];
  }

  User getUser(id) {
    return _users.firstWhere((element) => element.id == id);
  }

  bool isAdmin(id) {
    var ind = _users.indexWhere((element) => element.id == id);

    return users[ind].isAdmin;
  }

  String getAdminName(id) {
    var index = _users.indexWhere((element) => element.id == id);
    return _users[index].name;
  }
}
