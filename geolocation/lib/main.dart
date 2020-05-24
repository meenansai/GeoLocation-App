import "package:flutter/material.dart";
import 'package:geolocation/providers/auth.dart';
import 'package:geolocation/screens/home_screen.dart';
import 'package:geolocation/screens/usereditscreen.dart';
import 'package:provider/provider.dart';
import './screens/login_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/login_screen.dart';
import './providers/userProvider.dart';
import './widgets/map.dart';
import './screens/userDetailsScreen.dart';
import './widgets/map.dart';
import './screens/AuthScreen.dart';
void main() => runApp(
  MyApp(),
     
  );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
      create:(ctx)=>UserProvider(),
      ),
       ChangeNotifierProvider(
      create:(ctx)=>Auth(),
       ),
      ],
      child: Consumer<Auth>(builder: (ctx,auth,_)=> MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.blueAccent,
        ),
        home:auth.isAuth?(auth.isAdminCh? AdminScreen():HomeScreen()):FutureBuilder(builder: (ctx,status)=>status.connectionState==ConnectionState.waiting?Loading():AuthScreen()) , 
        // AdminScreen(),
        routes: {
        UserDetails.routeName:(ctx)=>UserDetails(),
        UserProdEditScreen.routeName:(ctx)=>UserProdEditScreen(),
        }
      ) ,)
      
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Loading...'),
    );
  }
}
