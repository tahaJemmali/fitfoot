import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DrawerPages/home.dart';
import 'Login/sign_in.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
    title: 'FitFoot',
    theme: ThemeData(
      fontFamily: "Muli",
      primaryColor: new Color(0xFF00A19A),
      /*appBarTheme: AppBarTheme(
        elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
        color: Color(0xFF00A19A),
      ),*/
    ),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

bool loggedIn = false;

class _MyAppState extends State<MyApp> {
  Future getUserData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    if (sharedPreferences.getString('email') != null) {
      print(sharedPreferences.getString('email'));
      setState(() {
        loggedIn = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData().whenComplete(() async {
      Future.delayed(
        Duration(seconds: 1),
        () {
          if (!loggedIn) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SignIn(),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ),
            );
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Image.asset(
        'assets/fflogo.png',
        width: 300,
      ),
    ));
  }
}
