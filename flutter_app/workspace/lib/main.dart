import 'package:flutter/material.dart';
import 'Login/sign_in.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
    title: 'FitFoot',
    theme: ThemeData(
      fontFamily: "Muli",
      appBarTheme: AppBarTheme(
        color: Colors.lightBlue
      ),

    ),
  ));
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
        Navigator.push(
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
      child: FlutterLogo(
        size: 400,
      ),
    ));
  }
}
