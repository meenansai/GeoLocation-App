import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geolocation/utils/change_password.dart';
import '../models/change_password_model.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = '/changePasswordScreen';
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldpasswordfocusnode = FocusNode();
  final _passwordfocusnode = FocusNode();
  final _confirmpasswordfocusnode = FocusNode();
  bool isLoading = false;
  final _form = GlobalKey<FormState>();
  ChangePassword newPasswords = ChangePassword(
    confirmPassword: '',
    newPassword: '',
  );
  void _saveForm() async {
    bool isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    print('Form Valid');
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });
    //..........

    //......
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _saveForm();
              }),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
            child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                child: Form(
                    key: _form,
                    child: ListView(
                      children: <Widget>[
                        TextFormField(
                          initialValue: '',
                          decoration: InputDecoration(labelText: 'New Password'),
                          textInputAction: TextInputAction.next,
                          autofocus: true,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_confirmpasswordfocusnode);
                          },
                          onSaved: (value) {
                            newPasswords = ChangePassword(
                              newPassword: value,
                              confirmPassword: newPasswords.confirmPassword,
                            );
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter new password';
                            } else {
                              return null;
                            }
                          },
                        ),
                         TextFormField(
                          initialValue: '',
                          decoration: InputDecoration(labelText: 'Confirm Password'),
                          textInputAction: TextInputAction.done,
                          onSaved: (value) {
                            newPasswords = ChangePassword(
                              newPassword: newPasswords.newPassword,
                              confirmPassword: value,
                            );
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter confirm password';
                            } 
                            if(newPasswords.newPassword!=newPasswords.confirmPassword){
                            //  setState(() {
                            //  newPasswords.confirmPassword=null;
                               
                            //  });
                              return 'Passwords doesn\'t match';
                            }
                            else {
                              return null;
                            }
                          },
                        ),                      //------------------------
                      ],
                    )),
              ),
          ),
    );
  }
}
