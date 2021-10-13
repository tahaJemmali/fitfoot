import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workspace/Languages/my_localization.dart';
import 'package:workspace/Login/utils/constants.dart' as c;
import 'DrawerPages/home.dart';
import 'Login/sign_in.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

bool loggedIn = false;

class _MyAppState extends State<MyApp> {
  Locale _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  Future getUserData() async {
    String l;
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('rememberMe')) {
      if (sharedPreferences.getString('rememberMe') == 'true') {
        //print(sharedPreferences.getString('email'));
        setState(() {
          loggedIn = true;
        });
      }
    } else {
      if (sharedPreferences.containsKey(c.LANGUAGE_CODE)) {
        l = sharedPreferences.getString(c.LANGUAGE_CODE);
      }
      sharedPreferences.clear();
      if (l != null) sharedPreferences.setString(c.LANGUAGE_CODE, l);
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    /*.whenComplete(() async {
      Future.delayed(
        Duration(seconds: 1),
        () {
          if (!loggedIn) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => SignIn(),
              ),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => Home(),
              ),
            );
          }
        },
      );
    });*/
  }

  @override
  void didChangeDependencies() {
    c.getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform != TargetPlatform.iOS)
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark));
    /*if (_locale == null) {

      return MaterialApp(
          home: Container(
      ));
    } else {*/
    return /*FutureBuilder(
      future: Future.delayed(Duration(seconds: 0)),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(home: Splash(),debugShowCheckedModeBanner: false,);
        } else {
          return */

        MaterialApp(
      home: Scaffold(body: loggedIn == false ? SignIn() : Home()),
      locale: _locale,
      supportedLocales: [
        Locale('en', 'US'),
        Locale('fr', 'FR'),
        Locale('ar', 'TN')
      ],
      localizationsDelegates: [
        MyLocalisation.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        for (var locale in supportedLocales) {
          if (locale.languageCode == deviceLocale.languageCode &&
              locale.countryCode == deviceLocale.countryCode) {
            return deviceLocale;
          }
        }
        return supportedLocales.first;
      },
      debugShowCheckedModeBanner: false,
      title: 'FitFoot',
      theme: ThemeData(
        //scaffoldBackgroundColor:Colors.grey.shade300,
        primaryColor: c.kPrimaryColor,
        toggleableActiveColor: c.kPrimaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        accentColor: c.kPrimaryColor,
        /*appBarTheme: AppBarTheme(
        elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
        color: Color(0xFF00A19A),
      ),*/
      ),
    );
  }
  /* }
      },
    );*/
  //}
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/fflogo.png',
          width: 300,
        ),
      ),
    );
  }
}

/*

home: Scaffold(
          body: Center(
        child: Image.asset(
          'assets/fflogo.png',
          width: 300,
        ),
      ))


*/

/*

MaterialApp(
    home: MyApp(),
    supportedLocales: [
      Locale('en', 'US'),
      Locale('fr', 'FR'),
      Locale('ar', 'TN')
    ],
    localizationsDelegates: [
      MyLocalisation.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    localeResolutionCallback: (deviceLocale, supportedLocales){
      for (var locale in supportedLocales) {
        if (locale.languageCode == deviceLocale.languageCode && locale.countryCode == deviceLocale.countryCode){
          return deviceLocale;
        }
      }
      return supportedLocales.first;
    },
    debugShowCheckedModeBanner: false,
    title: 'FitFoot',
    theme: ThemeData(
      //scaffoldBackgroundColor:Colors.grey.shade300,
      primaryColor: kPrimaryColor,
      toggleableActiveColor: kPrimaryColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      accentColor: kPrimaryColor,
      /*appBarTheme: AppBarTheme(
        elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
        color: Color(0xFF00A19A),
      ),*/
    ),
  ))

*/
