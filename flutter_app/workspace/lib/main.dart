import 'package:flutter/material.dart';
import 'Login/sign_in.dart';
import 'dart:async';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitFoot',
      home: MyApp(),
      theme: ThemeData(
        fontFamily: "Muli",
        primaryColor: new Color(0xFF00A19A),
        /*appBarTheme: AppBarTheme(
          elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
          color: Color(0xFF00A19A),
        ),*/
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 1),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignIn(),
          ),
        );
      },
    );
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
