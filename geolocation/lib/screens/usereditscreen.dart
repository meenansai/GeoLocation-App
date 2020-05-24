import 'package:flutter/material.dart';
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
  String newPassword;
  String confirmPassword;
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
  User newUser = User(
    id: "",
    address: "",
    designation: "",
    email: "",
    isAdmin: false,
    name: "",
    phno: "",
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

  void _saveForm() async {
    bool isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });
    if (newUser.id == null) {
      try {
        // if paswd is == cnfrm pswd
        //signup(email,pswd)
        // await Provider.of<UserProvider>(context).additem(newUser);
        await Provider.of<Auth>(context,listen: false).signup(emailTemp, confirmPassword);
        var userId=Provider.of<Auth>(context,listen: false).extraUserId;
        newUser.isAdmin=_selectedRole=="Admin";
        await Provider.of<UserProvider>(context,listen: false).additem(newUser,userId);
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
      //  finally{
      //     setState(() {
      //       isLoading=false;
      //     });
      //     Navigator.of(context).pop();
      //  }
    }
    // else {
    //   print(newProduct.id.toString() + ' so updating item');
    //   await Provider.of<ProductProvider>(context).updateItem(newProduct.id, newProduct);
    // }
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
                          emailTemp=value;
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
                        decoration: InputDecoration(labelText: 'Password'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        focusNode: _passwordfocusnode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_confirmpasswordfocusnode);
                        },
                        obscureText: true,
                        onSaved: (value) {
                          
                          newUser = User(
                            name: newUser.name,
                            email: newUser.email,
                            address: newUser.address,
                            designation: newUser.designation,
                            phno: newUser.phno,
                          );
                          newPassword = value;
                          
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter a Password';
                          }
                          if (value.length < 6) {
                            return 'Please Enter Password of atleast 6 characters';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: '',
                        decoration:
                            InputDecoration(labelText: 'Confirm Password'),
                        keyboardType: TextInputType.text,
                        focusNode: _confirmpasswordfocusnode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_designationfocusnode);
                        },
                        obscureText: true,
                        onSaved: (value) {
                          newUser = User(
                            name: newUser.name,
                            email: newUser.email,
                            address: newUser.address,
                            designation: newUser.designation,
                            phno: newUser.phno,
                          );
                          confirmPassword = value;
                          
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter Password.';
                          }
                          if (value.length < 6) {
                            return 'Please Enter Password of atleast 6 characters';
                          }
                          if (newPassword==value) {
                            return 'password does\'nt match';
                          }
                          // if (newPassword.compareTo(value) != 0) {
                          //   return 'password does\'nt match';
                          // }
                          return null;
                        },
                      ),
                      //------------------------
                      TextFormField(
                        initialValue: '',
                        decoration: InputDecoration(labelText: 'Designation'),
                        keyboardType: TextInputType.text,
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
