import 'dart:convert';
import 'dart:io';

import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workspace/AnalyseModule/widgets/stats/statistics.dart';
import 'package:workspace/DrawerPages/profil.dart';
import 'package:workspace/DrawerPages/settings.dart';
import 'package:workspace/Login/sign_in.dart';
import 'package:workspace/Login/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:im_animations/im_animations.dart';
import 'package:intl/intl.dart';

import 'package:workspace/Models/user.dart';
import 'package:workspace/deviceModule/Activites/ListDevices.dart';
import 'package:workspace/deviceModule/Activites/deviceHomeActivity.dart';

import 'package:number_animation/number_animation.dart';
import 'package:liquid_progress_indicator_ns/liquid_progress_indicator.dart';
import 'package:workspace/deviceModule/classes/cote.dart';
import 'package:workspace/deviceModule/classes/pied.dart';
import 'package:workspace/deviceModule/widgets/loading.dart';
import 'package:workspace/main.dart';
import 'package:workspace/views/activities/dailyexpenditures.dart';
import 'package:workspace/views/activities/pedometer.dart';
import 'package:workspace/views/activities/steps.dart';
import 'package:workspace/views/appointments/myappointments.dart';
import 'package:workspace/views/contacts/myContacts.dart';
import 'package:workspace/views/meds/addroutine.dart';
import 'package:workspace/views/meds/dailyIntake.dart';
import 'package:workspace/views/suggestions/suggestions.dart';

class Home extends StatefulWidget {
  static User currentUser;
  static BluetoothDevice device;
  static BluetoothState bluetoothState;
  static bool drawerDirection = true;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PickedFile _imageFile;
  Image _image1;
  File imageFile;
  String networkUrl;
  String _redness = "";
  final ImagePicker _imagePicker = ImagePicker();
  var p;
  int sec = 0;

  SharedPreferences sharedPreferences;

  Future<void> getShared() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();

    getShared().whenComplete(() {
      setState(() {
        Home.currentUser = User(
          id: sharedPreferences.get('id'),
          email: sharedPreferences.get('email'),
          emailVerification: sharedPreferences.get('emailVerification'),
          firstName: sharedPreferences.get('firstName'),
          lastName: sharedPreferences.get('lastName'),
          emailDoctor: sharedPreferences.get('emailM'),
          signUpDate: DateFormat(kkdateFormat)
              .parse(sharedPreferences.get('signUpDate')),
          lastLoginDate: DateFormat(kkdateFormat)
              .parse(sharedPreferences.get('lastLoginDate')),
          phone: sharedPreferences.get('phone'),
          phoneDoctor: sharedPreferences.get('phoneDoctor'),
          height: sharedPreferences.get('height'),
          weight: sharedPreferences.get('weight'),
          gender: Gender.values.firstWhere(
              (f) => f.toString() == sharedPreferences.get('gender'),
              orElse: () => Gender.Homme),
          photo: sharedPreferences.get('photo'),
          address: sharedPreferences.get('address'),
        );
        if (sharedPreferences.containsKey('birthDate')) {
          Home.currentUser.birthDate = DateFormat(kkdateFormat)
              .parse(sharedPreferences.get('birthDate'));
        }
        if (sharedPreferences.containsKey(LANGUAGE_CODE)) {
          if (sharedPreferences.getString(LANGUAGE_CODE) == ARABE) {
            setState(() {
              Home.drawerDirection = false;
            });
          }
        }
      });
    });

    getLocale().then((locale) async {
      Locale _temp = await setLocale(locale.languageCode);
      MyApp.setLocale(context, _temp);
    });

     FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        Home.bluetoothState = state;
      });
    });
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        Home.bluetoothState = state;
      });
    });

    Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    var path = Path();

    var size = Size(380, 770);
    var roundnessFactor = 50.0;

    path.moveTo(size.width * 0.8, size.height * 0.2);

    path.cubicTo(size.width - 30, size.height * 0.1, size.width - 160,
        size.height * 0.11, size.width - 300, size.height * 0.2);

    //  path.moveTo(size.width - 300, size.height * 0.3);

    path.cubicTo(30, size.height * 0.25, 70, size.height * 0.4,
        size.width - /**/ 310, size.height * 0.4);

    path.cubicTo(size.width - 280, size.height * 0.5, size.width - 280,
        size.height * 0.5, size.width - 285, size.height * 0.7);

    path.cubicTo(size.width - 300, size.height * 0.9, size.width - 150,
        size.height * 0.9, size.width - 90, size.height * 0.85);

    path.cubicTo(size.width - 80, size.height * 0.83, size.width - 30,
        size.height * 0.8, size.width - 100, size.height * 0.65);

    path.cubicTo(size.width - 150, size.height * 0.55, size.width - 150,
        size.height * 0.45, size.width - 76, size.height * 0.2);

    path.close();

//path.moveTo(10, 10);
    path.addOval(Rect.fromLTWH(
        size.width / 7.6, size.height / 8.6, size.width / 8, size.height / 13));
    path.addOval(Rect.fromLTWH(size.width / 3.9, size.height / 10.75,
        size.width / 8, size.height / 13));
    path.addOval(Rect.fromLTWH(size.width / 2.58, size.height / 13.9,
        size.width / 8, size.height / 13));
    path.addOval(Rect.fromLTWH(size.width / 1.9, size.height / 18.6,
        size.width / 8, size.height / 13));
    path.addOval(Rect.fromLTWH(size.width / 1.5, size.height / 23.1,
        size.width / 7, size.height / 12));

    p = path;
  }

  @override
  Widget build(BuildContext context) {
    // Listen for further state changes
    //print("id:" + Home.currentUser.id);
    return Scaffold(
        backgroundColor: kLightGrey,
        appBar: AppBar(
          title: Text(getTranslated(context, 'home_title_page')),
          elevation:
              defaultTargetPlatform == TargetPlatform.android ? 3.0 : 0.0,
        ),
        drawer: SafeArea(
          child: ClipRRect(
            borderRadius: () {
              if (!Home.drawerDirection) {
                return BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    bottomLeft: Radius.circular(15.0));
              } else {
                return BorderRadius.only(
                    topRight: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0));
              }
            }(),
            child: Drawer(
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    decoration: defaultTargetPlatform == TargetPlatform.android
                        ? BoxDecoration(color: kPrimaryColor)
                        : BoxDecoration(
                            color:
                                kPrimaryColor), //BoxDecoration(color: Colors.transparent),
                    accountName: Home.currentUser == null
                        ? Text(
                            "Loading...",
                            style: defaultTargetPlatform ==
                                    TargetPlatform.android
                                ? TextStyle(color: Colors.white)
                                : TextStyle(
                                    color: Colors
                                        .white), //TextStyle(color: Colors.black),
                          )
                        : Text(
                            Home.currentUser.firstName == null &&
                                    Home.currentUser.lastName == null
                                ? 'Loading...'
                                : Home.currentUser.firstName +
                                    " " +
                                    Home.currentUser.lastName,
                            style: defaultTargetPlatform ==
                                    TargetPlatform.android
                                ? TextStyle(color: Colors.white)
                                : TextStyle(
                                    color: Colors
                                        .white), //TextStyle(color: Colors.black),
                          ),
                    accountEmail: Home.currentUser == null
                        ? Text(
                            "Loading...",
                            style: defaultTargetPlatform ==
                                    TargetPlatform.android
                                ? TextStyle(color: Colors.white)
                                : TextStyle(
                                    color: Colors
                                        .white), //TextStyle(color: Colors.black),
                          )
                        : Text(
                            Home.currentUser.email,
                            style: defaultTargetPlatform ==
                                    TargetPlatform.android
                                ? TextStyle(color: Colors.white)
                                : TextStyle(
                                    color: Colors
                                        .white), //TextStyle(color: Colors.black),
                          ),
                    currentAccountPicture: Fade(
                      //beatsPerMinute: 60,
                      duration: Duration(milliseconds: 0),
                      fadeEffect: FadeEffect.fadeIn,
                      /*radius: 1,
                      waveColor: Colors.white,
                      waveThickness: 0.4,*/
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Profil(),
                            ),
                          ).then((value) {
                            setState(() {
                              Home.currentUser.photo =
                                  sharedPreferences.get('photo');
                            });
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: () {
                            if (Home.currentUser != null) {
                              if (Home.currentUser.photo != "null") {
                                return imageFromBase64String(
                                        Home.currentUser.photo)
                                    .image;
                              } else {
                                return AssetImage('assets/default_user.jpg');
                              }
                            } else {
                              return AssetImage('assets/default_user.jpg');
                            }
                          }(),
                          radius: 38,
                        ),
                      ),
                    ),
                  ),
                  //Divider(color: Colors.red),
                  ListTile(
                    title: Text(getTranslated(context, 'profile_title_page')),
                    leading: Icon(Icons.supervised_user_circle),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profil(),
                        ),
                      ).then((value) {
                        setState(() {
                          Home.currentUser.photo =
                              sharedPreferences.get('photo');
                        });
                      });
                    },
                  ),
                  Divider(
                    color: Colors.black26,
                    thickness: 0.0,
                  ),

                  ListTile(
                    title:
                        Text(getTranslated(context, 'statistics_title_page')),
                    leading: Icon(Icons.stacked_bar_chart),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Statistics(),
                        ),
                      );
                    },
                  ),
                  /*    ListTile(
                    title: Text('Loading'),
                    leading: Icon(Icons.contact_page),
                    onTap: () {
                      Pied pied1 = Pied(
                          id: "1",
                          cote: Cote.droit,
                          image: "none",
                          dimention: 11,
                          rougeur: 0,
                          temperature: 24);
                      Pied pied2 = Pied(
                          id: "1",
                          cote: Cote.gauche,
                          image: "none",
                          dimention: 14,
                          rougeur: 0,
                          temperature: 24);
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Loading(pied1, pied2)));
                    },
                  ),*/
                  Divider(
                    color: Colors.black26,
                    thickness: 0.0,
                  ),
                  //moez
                  ListTile(
                    title: Text(getTranslated(context, 'Contacts')),
                    leading: Icon(Icons.contact_page),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyContactsPage()),
                      );
                    },
                  ),
                  Divider(
                    color: Colors.black26,
                    thickness: 0.0,
                  ),
                  ListTile(
                    title: Text(getTranslated(context, 'Mes rendez-vous')),
                    leading: Icon(Icons.meeting_room),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => appointmentPage()),
                      );
                    },
                  ),
                  Divider(
                    color: Colors.black26,
                    thickness: 0.0,
                  ),
                  ListTile(
                    title: Text(getTranslated(context, 'Routine')),
                    leading: Icon(Icons.local_pharmacy),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => addRoutinePage()),
                      );
                    },
                  ),
                  Divider(
                    color: Colors.black26,
                    thickness: 0.0,
                  ),
                  ListTile(
                    title: Text(getTranslated(context, 'Prise de médicaments')),
                    leading: Icon(Icons.shopping_basket),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => dailyIntakePage()),
                      );
                    },
                  ),
                  Divider(
                    color: Colors.black26,
                    thickness: 0.0,
                  ),
                  ListTile(
                    title: Text(getTranslated(context, 'Activités')),
                    leading: Icon(Icons.sports),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => dailyExpenditurePage()),
                      );
                    },
                  ),
                  Divider(
                    color: Colors.black26,
                    thickness: 0.0,
                  ),
                  ListTile(
                    title: Text(getTranslated(context, 'Suggestions')),
                    leading: Icon(Icons.book),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SuggestionPage()),
                      );
                    },
                  ),
                  Divider(
                    color: Colors.black26,
                    thickness: 0.0,
                  ),
                  ListTile(
                    title: Text(getTranslated(context, 'Pédomètre')),
                    leading: Icon(Icons.airline_seat_flat_angled_sharp),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => stepsPage()),
                      );
                    },
                  ),
                  Divider(
                    color: Colors.black26,
                    thickness: 0.0,
                  ),
                  //moez
                  ListTile(
                    title: Text(getTranslated(context, 'settings_title_page')),
                    leading: Icon(Icons.settings),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Settings(),
                        ),
                      ).then((value) {
                        setState(() {
                          Home.currentUser.firstName =
                              sharedPreferences.get('firstName');
                          Home.currentUser.lastName =
                              sharedPreferences.get('lastName');
                        });
                      });
                    },
                  ),
                  ListTile(
                    title: Text(getTranslated(context, 'logout')),
                    leading: Icon(Icons.logout),
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(getTranslated(context, 'logout')),
                              content: Text(
                                  getTranslated(context, 'logout_confirm')),
                              actions: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: kPrimaryColor, // background
                                  ),
                                  child: Text(
                                      getTranslated(context, 'confirm_logout')),
                                  onPressed: () async {
                                    String l =
                                        sharedPreferences.get(LANGUAGE_CODE);
                                    sharedPreferences.clear();
                                    sharedPreferences.setString(
                                        LANGUAGE_CODE, l);
                                    Navigator.of(context).pop();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignIn(),
                                      ),
                                    );
                                  },
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: kPrimaryColor, // background
                                  ),
                                  child: Text(getTranslated(context, 'cancel')),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Container(
                          margin: EdgeInsets.symmetric(vertical: 12),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  getTranslated(context, 'start_full_analysis'),
                                  //'Faites une analyse complète sur votre pieds',
                                  style: TextStyle(color: Colors.blue),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: SizedBox(
                                    width: 320,
                                    child: OutlinedButton(
                                      child: Text(getTranslated(
                                          context, 'start_analysis')),
                                      onPressed: () {
                                        if (Home.device != null &&
                                            Home.bluetoothState ==
                                                BluetoothState.STATE_ON) {
                                          if (Home.device.isBonded) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DeviceHomeActivity(),
                                              ),
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(getTranslated(
                                                      context, "veuillerApp")),
                                                  content: Text(getTranslated(
                                                      context, "vousDevez")),
                                                  actions: <Widget>[
                                                    new FlatButton(
                                                      child: new Text(
                                                          getTranslated(context,
                                                              "daccord")),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        Navigator.of(context).push(
                                                            new MaterialPageRoute(
                                                          builder: (context) =>
                                                              DiscoveryPage(),
                                                        ));
                                                      },
                                                    ),
                                                    new FlatButton(
                                                      child: new Text(
                                                          getTranslated(context,
                                                              "fermer")),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(getTranslated(
                                                    context, "veuillerApp")),
                                                content: Text(getTranslated(
                                                    context, "vousDevez")),
                                                actions: <Widget>[
                                                  new FlatButton(
                                                    child: new Text(
                                                        getTranslated(context,
                                                            "daccord")),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      Navigator.of(context).push(
                                                          new MaterialPageRoute(
                                                        builder: (context) =>
                                                            DiscoveryPage(),
                                                      ));
                                                    },
                                                  ),
                                                  new FlatButton(
                                                    child: new Text(
                                                        getTranslated(
                                                            context, "fermer")),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      style: OutlinedButton.styleFrom(
                                        primary: Colors.black,
                                        backgroundColor: kLightGrey,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))),
                  SizedBox(height: 20),
                  Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Container(
                          margin: EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.thermostat_rounded,
                                              color: Colors.red,
                                              size: 17,
                                            ),
                                            Expanded(
                                              child: Text(
                                                  getTranslated(context,
                                                      'measure_foot_temperature'),
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 20),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        '--',
                                                        style: TextStyle(
                                                            fontSize: 23),
                                                      ),
                                                      Text(
                                                        ' %',
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              child: OutlinedButton(
                                                child: Text(getTranslated(
                                                    context, 'measure')),
                                                onPressed: () {},
                                                style: OutlinedButton.styleFrom(
                                                  primary: Colors.black,
                                                  backgroundColor: Colors.white,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20))),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ))),
                  Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Container(
                          margin: EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.hearing_outlined,
                                              color: Colors.green,
                                              size: 17,
                                            ),
                                            Expanded(
                                              child: Text(
                                                  getTranslated(context,
                                                      'measure_foot_swelling'),
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.green)),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 20),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        '--',
                                                        style: TextStyle(
                                                            fontSize: 23),
                                                      ),
                                                      Text(
                                                        ' %',
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              child: OutlinedButton(
                                                child: Text(getTranslated(
                                                    context, 'measure')),
                                                onPressed: () {},
                                                style: OutlinedButton.styleFrom(
                                                  primary: Colors.black,
                                                  backgroundColor: Colors.white,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20))),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ))),
                  Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Container(
                          margin: EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.color_lens_rounded,
                                              color: Colors.red,
                                              size: 17,
                                            ),
                                            Expanded(
                                              child: Text(
                                                  getTranslated(context,
                                                      'measure_foot_redness'),
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 20),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        '--',
                                                        style: TextStyle(
                                                            fontSize: 23),
                                                      ),
                                                      Text(
                                                        ' %',
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              child: OutlinedButton(
                                                child: Text(getTranslated(
                                                    context, 'measure')),
                                                onPressed: () {
                                                  showModalBottomSheet<dynamic>(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      builder: ((builder) =>
                                                          bottomSheet(
                                                              context)));
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  primary: Colors.black,
                                                  backgroundColor: Colors.white,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20))),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ))),
                ],
              ),
            ),
          ),
        ));
  }

  Widget bottomSheet(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(15.0),
            topRight: const Radius.circular(15.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(
                child: Divider(
                  height: 1,
                  color: Colors.black87,
                  indent: 180.0,
                  endIndent: 180.0,
                  thickness: .6,
                ),
              ),
              SizedBox(height: 5),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  "Ouvrir avec",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(height: 15),
              Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      SizedBox.fromSize(
                        size: Size(56, 56), // button width and height
                        child: ClipOval(
                          child: Material(
                            color: kPrimaryColor, // button color
                            child: InkWell(
                              splashColor: Colors.white54, // splash color
                              onTap: () => pickImageFrom(
                                  ImageSource.camera), // button pressed
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.camera,
                                    size: 30,
                                    color: Colors.white,
                                  ), // icon
                                  //Text("Camera"), // text
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text("Camera"),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox.fromSize(
                        size: Size(56, 56), // button width and height
                        child: ClipOval(
                          child: Material(
                            color: kPrimaryColor, // button color
                            child: InkWell(
                              splashColor: Colors.white54, // splash color
                              onTap: () => pickImageFrom(
                                  ImageSource.gallery), // button pressed
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.image,
                                      size: 30,
                                      color: Colors.white), // icon // text
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text("Gallery"),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheetRes(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      width: MediaQuery.of(context).size.width,
      //margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(20.0),
          topRight: const Radius.circular(20.0),
        ),
      ),
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: DelayedDisplay(
                  delay: Duration(milliseconds: 400),
                  child: Text(
                    'La rougeur de mon pied',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 20),
                child: TweenAnimationBuilder<Duration>(
                    duration: Duration(
                        milliseconds: (double.parse(_redness)).toInt() * 35),
                    tween: Tween(
                        begin: Duration(seconds: 0),
                        end: Duration(
                            milliseconds:
                                (double.parse(_redness)).toInt() * 35)),
                    onEnd: () {},
                    builder:
                        (BuildContext context, Duration value, Widget child) {
                      //final minutes = value.inMinutes;
                      final double seconds =
                          (value.inMilliseconds.toDouble() % 100000000) / 3500;
                      /*setState(() {
                  sec = value.inSeconds % 60;
                });*/
                      return Column(children: [
                        /*Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text((seconds * 100).toStringAsFixed(2),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30))),*/
                        Center(
                          child: DelayedDisplay(
                            delay: Duration(milliseconds: 600),
                            child: LiquidCustomProgressIndicator(
                              value: seconds, // Defaults to 0.5.
                              center: NumberAnimation(
                                start: 0, // default is 0, can remove
                                end: double.parse(_redness),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30),
                                after: ' %',
                                loadingPlaceHolder: '',
                                duration: Duration(seconds: 2),
                              ),
                              valueColor: AlwaysStoppedAnimation(Colors
                                  .pinkAccent
                                  .shade400), // Defaults to the current Theme's accentColor.
                              backgroundColor:
                                  kGrey2, // Defaults to the current Theme's backgroundColor.
                              direction: Axis
                                  .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right).
                              shapePath:
                                  p, // A Path object used to draw the shape of the progress indicator. The size of the progress indicator is created from the bounds of this path.
                            ),
                          ),
                        ),
                      ]);
                    }),
              ),
            ),
            /*DelayedDisplay(
              delay: Duration(milliseconds: 1500),
                          child: OutlinedButton(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: Row(
                    children: [
                      Text("Visualiser l'image analysé"),
                      Container(child: Icon(Icons.remove_red_eye),width: 50,)
                    ],
                  ),
                ),
                onPressed: () {
                  _showDialogImage();
                },
                style: OutlinedButton.styleFrom(
                  primary: Colors.black,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
              ),
            ),*/
            /*OutlinedButton(
              child: Column(
                children: [Text("Refaire l'analyse"),
                SizedBox(height:5),
                 Icon(Icons.replay_rounded),
                 SizedBox(height:5),],
              ),
              onPressed: () {
                Navigator.of(context).pop();
                showModalBottomSheet<dynamic>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: ((builder) => bottomSheet(context)));
              },
              style: OutlinedButton.styleFrom(
                primary: Colors.black,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
            ),*/
            Align(
              alignment: Alignment.topLeft,
              child: DelayedDisplay(
                delay: Duration(milliseconds: 2980),
                child: Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.44,
                      left: MediaQuery.of(context).size.width * 0.1),
                  child: Column(
                    children: [
                      SizedBox.fromSize(
                        size: Size(56, 56), // button width and height
                        child: ClipOval(
                          child: Material(
                            color: Colors.grey.shade50, // button color
                            child: InkWell(
                              splashColor: Colors.grey.shade300, // splash color
                              onTap: () {
                                _showDialogImage();
                              }, // button pressed
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.remove_red_eye_sharp,
                                      size: 30,
                                      color: Colors.blue), // icon // text
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(""),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.44,
                    right: MediaQuery.of(context).size.width * 0.1),
                child: DelayedDisplay(
                  delay: Duration(milliseconds: 3800),
                  child: Column(
                    children: [
                      SizedBox.fromSize(
                        size: Size(56, 56), // button width and height
                        child: ClipOval(
                          child: Material(
                            color: Colors.grey.shade100, // button color
                            child: InkWell(
                              splashColor: Colors.white70, // splash color
                              onTap: () {
                                Navigator.of(context).pop();
                                showModalBottomSheet<dynamic>(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: ((builder) =>
                                        bottomSheet(context)));
                              }, // button pressed
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.replay_rounded,
                                      size: 30,
                                      color: Colors.blue), // icon // text
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(""),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ), /*CustomScrollView(
        slivers: [
          SliverAppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0),
              ),
            ),
            centerTitle: true,
            pinned: true,
            expandedHeight: 30.0,
            flexibleSpace: FlexibleSpaceBar(
              title: _image1 == null
                  ? Text(
                      'No feet detected',
                      style: TextStyle(color: Colors.black),
                    )
                  : Text(
                      'Result: ' + _redness + " %",
                      style: TextStyle(color: Colors.black),
                    ),
            ),
            leading: Text(""),
            elevation: 0,
            backgroundColor: Colors.white,
          ),
          SliverFixedExtentList(
            itemExtent: 275,
            delegate: SliverChildListDelegate([
              //equivalent to Listview
              Container(
                child: _image1 == null
                    ? Text("No")
                    : LiquidCustomProgressIndicator(
            //value: double.parse(_redness), // Defaults to 0.5.
            center: NumberAnimation(
              start: 0, // default is 0, can remove
              end: double.parse(_redness),
              style: TextStyle(color: Colors.white, fontSize: 30),
              after: ' %',
              loadingPlaceHolder: '',
              duration: Duration(seconds: 2),
            ),
            valueColor: AlwaysStoppedAnimation(Colors
                .pinkAccent), // Defaults to the current Theme's accentColor.
            backgroundColor:
                Colors.grey, // Defaults to the current Theme's backgroundColor.
            direction: Axis
                .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right).
            shapePath:
                p, // A Path object used to draw the shape of the progress indicator. The size of the progress indicator is created from the bounds of this path.
          ),
              ),
              
            ]),
          ),
        ],
      ),*/
    );
  }

  void pickImageFrom(ImageSource source) async {
    final pickedFile = await _imagePicker.getImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
      uploadFeetImage();
    }
    Navigator.of(context).pop();
    //print(pickedFile.path);
  }

  Future<String> uploadFeetImage() async {
    _image1 = null;
    var test;
    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black);
    SVProgressHUD.setRingNoTextRadius(20); // default is 24 pt
    SVProgressHUD.show(status: 'Traitement en cours...');

    /* encode image */
    final bytes = File(_imageFile.path).readAsBytesSync();
    String img64 = base64Encode(bytes);
    //print(img64);

    String currentUserEmail = sharedPreferences.getString('email');

    String objText =
        '{"email": "' + currentUserEmail + '", "image": "' + img64 + '" }';

    //print(convert.jsonDecode(objText));

    try {
      final response = await http.post(Uri.http(Url, "/user/feet"),
          body: convert.jsonDecode(objText));
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        test = jsonResponse['Detection'];
        //print(jsonResponse['message']);
        //print(jsonResponse['Detection']);
        if (jsonResponse['Detection'] == 'true') {
          //print(jsonResponse['RednessPerc']);
          //print(jsonResponse['Image1']);
          //imageFromBase64String(jsonResponse['Image1']);
          SVProgressHUD.dismiss();
          setState(() {
            _redness = jsonResponse['RednessPerc'].toString();
            _image1 = imageFromBase64String(jsonResponse['Image1']);
          });
          //return jsonResponse['message'];
        }
      }
    } on HttpException catch (err) {
      print("Network exception error: $err");
      return null;
    } finally {
      if (test == 'true') {
        showModalBottomSheet<dynamic>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: ((builder) => bottomSheetRes(context)));
      } else {
        SVProgressHUD.showInfo(
            status: 'Aucun ' + "pied n'a" + " été détecté lors de l'analyse");
        //SVProgressHUD.showInfo(status: 'Aucun pied n a été détecté lors de l analyse');
        SVProgressHUD.dismiss(delay: Duration(milliseconds: 3000));
      }
      /*print("All Done!");
 Navigator.pop(context);*/

      //_image1 = null;
    }
  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  _showDialogImage() async {
    await showDialog<String>(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: _image1 == null ? Text("") : _image1,
        ),
      ),
    );
  }
}
/*DefaultButton(
                    text: "Mesurez la rougeur de votre pied",
                    press: () {
                      
                    },
                  ),
                  Center(
                    child: _imageFile == null
                        ? Text("no image found")
                        : Image.file(File(_imageFile
                            .path)) ,//FileImage(File(_imageFile.path))
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: _image1 == null ? Text("") : _image1,
                  )*/
