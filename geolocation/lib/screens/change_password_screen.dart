import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geolocation/providers/userProvider.dart';
import 'package:geolocation/utils/change_password.dart';
import '../models/change_password_model.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../utils/change_password.dart';

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
  User user;
  void _saveForm(email) async {
    bool isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    print('Form Valid');
    _form.currentState.save();
    // setState(() {
    //   isLoading = true;
    // });
    //..........
    try {
      setState(() {
        isLoading=true;
      });
      await Provider.of<Auth>(context, listen: false).changePassword(newPasswords.confirmPassword);
      setState(() {
        isLoading=false;
      });
      // Scaffold.of(context).showSnackBar(SnackBar(content:Text("Changed Password",textAlign: TextAlign.center,)));
      
      Navigator.of(context).pop();
    } catch (error) {
     showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Error Occured'),
              content: Text('Unable to Change Password,try again later'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('OKAY'),
                )
              ],
            ));
    }
    //......
    // setState(() {
    //   isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<Auth>(context, listen: false).fetchedUser;
    // final String idToken = Provider.of<Auth>(context,listen: false).token;
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        // actions: <Widget>[
        //   IconButton(
        //       icon: Icon(Icons.save),
        //       onPressed: () {
        //         _saveForm();
        //       }),
        // ],
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
                          decoration:
                              InputDecoration(labelText: 'New Password'),
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
                          decoration:
                              InputDecoration(labelText: 'Confirm Password'),
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
                            if (newPasswords.newPassword !=
                                newPasswords.confirmPassword) {
                              //  setState(() {
                              //  newPasswords.confirmPassword=null;

                              //  });
                              return 'Passwords doesn\'t match';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RaisedButton(
                          onPressed: () {
                            _saveForm(user.email);
                          },
                          child: Text('Change Password'),
                        ) //------------------------
                      ],
                    )),
              ),
            ),
    );
  }
}
