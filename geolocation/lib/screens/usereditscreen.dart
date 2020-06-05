import 'package:flutter/material.dart';
import 'package:geolocation/models/change_password_model.dart';
import 'package:geolocation/providers/auth.dart';
import 'package:geolocation/providers/userProvider.dart';
import 'package:provider/provider.dart';

class UserProdEditScreen extends StatefulWidget {
  static const routeName = '/useredits';

  @override
  _UserProdEditScreenState createState() => _UserProdEditScreenState();
}

class _UserProdEditScreenState extends State<UserProdEditScreen> {
  final _namefocusnode = FocusNode();
  final _designationfocusnode = FocusNode();
  final _emailfocusnode = FocusNode();
  final _passwordfocusnode = FocusNode();
  final _confirmpasswordfocusnode = FocusNode();
  final _addressfocusnode = FocusNode();
  final _phonenumberfocusnode = FocusNode();
  final _form = GlobalKey<FormState>();
  var isLoading = false;
  List<String> _roles = ['Admin', 'User'];
  String _selectedRole;
  // String newPassword;
  // String confirmPassword;
  String emailTemp;
  var initval = {
    'id': '',
    'address': '',
    'designation': '',
    'email': '',
    'isAdmin': '',
    'name': '',
    'phno': '',
  };
  ChangePassword newPasswords = ChangePassword(newPassword: '', confirmPassword: '');
  User newUser = User(
    id: "",
    address: "",
    designation: "",
    email: "",
    isAdmin: false,
    name: "",
    phno: "",
    latitude: null,
    longitude: null,
  );
  @override
  void dispose() {
    _namefocusnode.dispose();
    _designationfocusnode.dispose();
    _emailfocusnode.dispose();
    _passwordfocusnode.dispose();
    _confirmpasswordfocusnode.dispose();
    _addressfocusnode.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  _showSnackBar(String msg,bool status) {
    final snackBar = new SnackBar(
      content: Text(
        msg,
        textAlign: TextAlign.center,
      ),
      duration: new Duration(seconds: 1),
      backgroundColor:status?Colors.green: Colors.red,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _saveForm() async {
    bool isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if(newPasswords.newPassword!=newPasswords.confirmPassword){
          _showSnackBar("Passwords didn't match, Recheck Passwords",false);
          return;
    }
    setState(() {
      isLoading = true;
    });
    if (newUser.id == null) {
      try {
        // if (newPass.confirmPassword == newPass.newPassword) {
          await Provider.of<Auth>(context, listen: false)
              .signup(emailTemp, newPasswords.confirmPassword);
        // } else {
        //   showDialog(
        //       context: context,
        //       child: AlertDialog(
        //         title: Text("Ohhh Nooo!!!!!"),
        //         content: Text('Passwords Doesn\'t Match'),
        //       ));
        // }
        var userId = Provider.of<Auth>(context, listen: false).extraUserId;
        newUser.isAdmin = _selectedRole == "Admin";
        if(newPasswords.newPassword==newPasswords.confirmPassword){
        await Provider.of<UserProvider>(context, listen: false)
            .additem(newUser, userId).then((value){
               _showSnackBar("User added successfully",true);
            });
        }

      } catch (error) {
        await showDialog<Null>(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Some error Occured'),
                content: Text(error.toString()),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text('Okay')),
                ],
              );
            });
      }
      print("successful!!");
    }
    setState(() {
      isLoading = false;
    });
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New User'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _saveForm();
              }),
        ],
      ),
      key: _scaffoldKey,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        initialValue: initval['name'],
                        decoration: InputDecoration(labelText: 'Name'),
                        textInputAction: TextInputAction.next,
                        autofocus: true,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_emailfocusnode);
                        },
                        onSaved: (value) {
                          newUser = User(
                            name: value,
                            email: newUser.email,
                            address: newUser.address,
                            designation: newUser.designation,
                            phno: newUser.phno,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter name.';
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        initialValue: initval['email'],
                        decoration: InputDecoration(labelText: 'Email'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        focusNode: _emailfocusnode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_passwordfocusnode);
                        },
                        onSaved: (value) {
                          newUser = User(
                            name: newUser.name,
                            email: value,
                            address: newUser.address,
                            designation: newUser.designation,
                            phno: newUser.phno,
                          );
                          emailTemp = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter Email';
                          }
                          //email validation....................................
                          // if (value.contains("@")) {
                          //   return 'Please Enter a valid Email';
                          // }
                          return null;
                        },
                      ),
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
                          obscureText: true,
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
                          textInputAction: TextInputAction.next,
                          obscureText: true,
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
                            // if (newPasswords.newPassword !=
                            //     newPasswords.confirmPassword) {
                            //   return 'Passwords doesn\'t match';
                            // } 
                            else {
                              return null;
                            }
                          },
                        ), //--------
                      //------------------------
                      TextFormField(
                        initialValue: '',
                        decoration: InputDecoration(labelText: 'Designation'),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        focusNode: _designationfocusnode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_phonenumberfocusnode);
                        },
                        onSaved: (value) {
                          newUser = User(
                            name: newUser.name,
                            email: newUser.email,
                            address: newUser.address,
                            designation: value,
                            phno: newUser.phno,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter Designation.';
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: '',
                        decoration: InputDecoration(labelText: 'Phone Number'),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        focusNode: _phonenumberfocusnode,
                        onSaved: (value) {
                          newUser = User(
                            name: newUser.name,
                            email: newUser.email,
                            address: newUser.address,
                            designation: newUser.designation,
                            phno: value,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter Phone Number';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please Enter a valid Phone Number.';
                          }
                          if (value.length < 10) {
                            return 'Phone Number should contain 10 digits';
                          }
                          return null;
                        },
                      ),
                      Center(
                        child: DropdownButton(
                          hint: Text('Please choose a Role'),
                          value: _selectedRole,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedRole = newValue;
                            });
                          },
                          items: _roles.map((role) {
                            return DropdownMenuItem(
                              child: new Text(role),
                              value: role,
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  )),
            ),
    );
  }
}
