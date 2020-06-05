import "package:flutter/material.dart";
import 'package:geolocation/providers/auth.dart';
import 'package:geolocation/providers/latlong.dart';
import 'package:geolocation/screens/adminmapscreen.dart';
import 'package:geolocation/screens/change_password_screen.dart';
import 'package:geolocation/screens/home_screen.dart';
import 'package:geolocation/screens/images_screen.dart';
import 'package:geolocation/screens/report_screen.dart';
import 'package:geolocation/screens/user_detail_admin_screen.dart';
import 'package:geolocation/screens/usereditscreen.dart';
import 'package:provider/provider.dart';
import 'screens/admin_screen.dart';
import './providers/userProvider.dart';
import './screens/userDetailsScreen.dart';
import './screens/AuthScreen.dart';
import './providers/image_provider.dart';
import 'screens/report_screen.dart';
import './screens/report_map_screen.dart';
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
            create: (ctx) => UserProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => ImageProviders(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => LatLongProvider(),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.indigo,
                accentColor: Colors.blueGrey,
                fontFamily: 'Raleway',
                textTheme: ThemeData.light().textTheme.copyWith(
                      body1: TextStyle(
                        color: Color.fromRGBO(20, 51, 51, 1),
                      ),
                      body2: TextStyle(
                        color: Color.fromRGBO(20, 51, 51, 1),
                      ),
                      title: TextStyle(
                        fontSize: 24,
                        fontFamily: 'RobotoCondensed',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              ),
              home: auth.isAuth
                  ? (auth.isAdminCh ? AdminScreen() : HomeScreen())
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, status) =>
                          status.connectionState == ConnectionState.waiting
                              ? Loading()
                              : AuthScreen()),
              // AdminScreen(),
              routes: {
                HomeScreen.routeName: (ctx) => HomeScreen(),
                UserDetails.routeName: (ctx) => UserDetails(),
                ImageScreen.routeName: (ctx) => ImageScreen(),
                UserDetailsAdmin.routeName: (ctx) => UserDetailsAdmin(),
                UserProdEditScreen.routeName: (ctx) => UserProdEditScreen(),
                ChangePasswordScreen.routeName: (ctx) => ChangePasswordScreen(),
                ReportScreen.routeName: (ctx) => ReportScreen(),
                ReportMapScreen.routeName:(ctx)=>ReportMapScreen(),
                AdminMapScreen.routeName:(ctx)=>AdminMapScreen(),
              }),
        ));
  }
}

class Loading extends StatelessWidget {
  const Loading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator(),),
    );
  }
}
