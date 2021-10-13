import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:fading_images_slider/fading_images_slider_fahd.dart';
import 'fis.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/Login/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';

class Profil extends StatefulWidget {
  static const kTextStyle = TextStyle(
    color: Colors.white,
    backgroundColor: Colors.black,
    fontSize: 30,
  );

  @override
  _ProfilState createState() => _ProfilState();
}

class BuildingNumbers {
  static List<int> numbers = [];
  static List<String> months = [
    'JAN',
    'FEV',
    'MAR',
    'AVR',
    'MAI',
    'JUN',
    'JUL',
    'AUT',
    'SEP',
    'OCT',
    'NOV',
    'DEC'
  ];
  static List<String> months_arab = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر'
  ];
}

class _ProfilState extends State<Profil> {
  PickedFile _imageFile;
  Image _imageProfile;
  ImageProvider _imageProvider;
  File imageFile;
  final ImagePicker _imagePicker = ImagePicker();

  bool _autoFade = true;
  final int _gFlex = 15;
  int _height1 = 170, _height2 = 0, _weight1 = 65, _weight2 = 0;
  String _day = "01", _month = "01", _year = "1990";
  int _i_day = 0, _i_month = 0, _i_year = 290;
  Gender _gender = Home.currentUser.gender;
  double _bmi;
  bool isArab = false;
  SharedPreferences sharedPreferences;

  Future<void> getShared() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  int _getYears() {
    int years = DateTime.now().year;
    years += 1;
    return years;
  }

  @override
  void initState() {
    getShared().then((value) {
      if (sharedPreferences != null) {
        if (sharedPreferences.containsKey(LANGUAGE_CODE)) {
          if (sharedPreferences.getString(LANGUAGE_CODE) == ARABE) {
            setState(() {
              isArab = true;
            });
          } else {
            setState(() {
              isArab = false;
            });
          }
        }
      }
    });

    setState(() {
      if (Home.currentUser.photo != null) {
        _imageProvider = imageFromBase64String(Home.currentUser.photo).image;
      }

      if (Home.currentUser.weight != -1) {
        setState(() {
          _weight1 = Home.currentUser.weight.truncate();
          _weight2 =
              int.parse(Home.currentUser.weight.toString().split('.')[1]);
        });
      }

      if (Home.currentUser.height != -1) {
        setState(() {
          _height1 = Home.currentUser.height.truncate();
          _height2 =
              int.parse(Home.currentUser.height.toString().split('.')[1]);
        });
      }
      _updateBMI();

      if (Home.currentUser.birthDate != null) {
        _i_year = Home.currentUser.birthDate.year;
        _i_month = Home.currentUser.birthDate.month;
        _i_day = Home.currentUser.birthDate.day;

        //_day = _i_day.toString();
        //_month = _i_month.toString();
        _year = _i_year.toString();

        if (_i_month > 9) {
          _month = (_i_month).toString();
        } else {
          _month = "0" + (_i_month).toString();
        }
        if (_i_day > 9) {
          _day = (_i_day).toString();
        } else {
          _day = "0" + (_i_day).toString();
        }
        _i_year = _i_year - 1700;
        _i_month -= 1;
        _i_day -= 1;
      }
      for (int j = 0; j < _getYears(); j++) {
        BuildingNumbers.numbers.add(j);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "profile_title_page")),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(alignment: Alignment.bottomLeft, children: [
                Container(
                  padding: EdgeInsets.only(bottom: 30),
                  child: FadingImagesSlider(
                    textAlignment: Alignment.center,
                    animationDuration: Duration(milliseconds: 600),
                    activeIconColor: Colors.transparent,
                    passiveIconColor: Colors.transparent,
                    autoFade: _autoFade,
                    fadeInterval: Duration(milliseconds: 3000),
                    texts: [
                      Text(
                        '',
                        style: Profil.kTextStyle,
                      ),
                      Text(
                        '',
                        style: Profil.kTextStyle,
                      ),
                      Text(
                        '',
                        style: Profil.kTextStyle,
                      )
                    ],
                    images: [
                      Image.asset(
                        'assets/profil/1.jpg',
                        fit: BoxFit.fill,
                      ),
                      Image.asset(
                        'assets/profil/22.jpg',
                        fit: BoxFit.fill,
                      ),
                      Image.asset(
                        'assets/profil/44.jpg',
                        fit: BoxFit.fill,
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 50,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff7c94b6),
                      borderRadius: BorderRadius.all(Radius.circular(400)),
                      border: Border.all(
                        color: kGrey,
                        width: 1.0,
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(400)),
                      onTap: () {
                        showModalBottomSheet<dynamic>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: ((builder) => bottomSheet(context)));
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: Home.currentUser.photo == "null"
                            ? AssetImage('assets/default_user.jpg')
                            : _imageProvider,
                        radius: 38,
                      ),
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 15),
              !isArab
                  ? Row(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 30),
                          child: Text(
                            Home.currentUser.firstName +
                                " " +
                                Home.currentUser.lastName,
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(top: 2, right: 30),
                            child: Text(
                                Home.currentUser.birthDate == null
                                    ? ''
                                    : _getAge(),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14)),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(top: 2, right: 30),
                            child: Text(
                                Home.currentUser.birthDate == null
                                    ? ''
                                    : _getAge(),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14)),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 30),
                          child: Text(
                            Home.currentUser.firstName +
                                " " +
                                Home.currentUser.lastName,
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
              SizedBox(height: 15),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 30, right: 30),
                child: Container(
                    padding:
                        EdgeInsets.only(top: 3, bottom: 3, left: 10, right: 10),
                    decoration: new BoxDecoration(
                      color: kGrey2,
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(20.0),
                        topRight: const Radius.circular(20.0),
                        bottomLeft: const Radius.circular(20.0),
                        bottomRight: const Radius.circular(20.0),
                      ),
                    ),
                    child: (Text(
                      Home.currentUser.email,
                      style: TextStyle(color: Colors.black),
                    ))),
              ),
              SizedBox(height: 15),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 30, right: 30),
                child: Text(getTranslated(context, "profil_p"),
                    style: TextStyle(color: kGrey3)),
              ),
              SizedBox(height: 15),
              Container(
                margin: EdgeInsets.only(left: 25, right: 25),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Expanded(
                      flex: 80,
                      child: Text(
                        getTranslated(context, "Informations utilisateur"),
                        style: TextStyle(color: kGrey3),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 80,
                      child: Text(
                          '-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -    ',
                          maxLines: 1,
                          style: TextStyle(fontSize: 8, color: kGrey3)),
                    ),
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.info_outline,
                        size: 20,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 20, right: !isArab ? 5 : 15),
                      child: OutlinedButton(
                        child: Text(getTranslated(context, "Gender")),
                        onPressed: () {
                          showModalBottomSheet<dynamic>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: ((builder) =>
                                  bottomSheetGender(context)));
                        },
                        style: OutlinedButton.styleFrom(
                          primary: Colors.black,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: !isArab ? 5 : 15, right: 20),
                      child: OutlinedButton(
                        child: Text(
                          getTranslated(context, "Date de naissance"),
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width < 300
                                  ? 10
                                  : 14),
                        ),
                        onPressed: () {
                          showModalBottomSheet<dynamic>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: ((builder) =>
                                  bottomSheetDateOfBirth(context)));
                        },
                        style: OutlinedButton.styleFrom(
                          primary: Colors.black,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 20, right: !isArab ? 5 : 15),
                      child: OutlinedButton(
                        child: Text(getTranslated(context, "Taille")),
                        onPressed: () {
                          showModalBottomSheet<dynamic>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: ((builder) =>
                                  bottomSheetHeight(context)));
                        },
                        style: OutlinedButton.styleFrom(
                          primary: Colors.black,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: !isArab ? 5 : 15, right: 20),
                      child: OutlinedButton(
                        child: Text(getTranslated(context, "Poids")),
                        onPressed: () {
                          showModalBottomSheet<dynamic>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: ((builder) =>
                                  bottomSheetWeight(context)));
                        },
                        style: OutlinedButton.styleFrom(
                          primary: Colors.black,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Home.currentUser.weight != -1 && Home.currentUser.height != -1
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width / 4,
                                right: MediaQuery.of(context).size.width / 4),
                            child: OutlinedButton(
                              child: Text(
                                getTranslated(context, 'bmi') +
                                    ": " +
                                    _bmi.toString(),
                                style: TextStyle(color: getColorSBMI()),
                              ),
                              onPressed: () {
                                showModalBottomSheet<dynamic>(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: ((builder) =>
                                        bottomSheetBMI(context)));
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: getColorSBMI()),
                                primary: getColorSBMI(),
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Color getColorSBMI() {
    if (_bmi >= 30) {
      return Colors.red;
    } else if (_bmi <= 18.5 || (_bmi >= 25 && _bmi <= 29.9)) {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }

  Widget bottomSheetHeight(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        /*height: defaultTargetPlatform == TargetPlatform.android
            ? MediaQuery.of(context).size.height * 0.36
            : MediaQuery.of(context).size.height * 0.31,
        width: MediaQuery.of(context).size.width,*/
        margin: EdgeInsets.only(bottom: 30),
        //margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(20.0),
            topRight: const Radius.circular(20.0),
            bottomLeft: const Radius.circular(20.0),
            bottomRight: const Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                child: Text(
                  getTranslated(context, "Choisir la taille"),
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.left,
                ),
                alignment:
                    !isArab ? Alignment.centerLeft : Alignment.centerRight,
                margin: EdgeInsets.only(left: 15, right: 15),
              ),
              SizedBox(height: 20),
              !isArab ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: _gFlex,
                      child: Container(
                        height: 140,
                        child: CupertinoPicker(
                          diameterRatio: 10,
                          magnification: 1,
                          squeeze: 1,
                          itemExtent: 60,
                          scrollController: FixedExtentScrollController(
                              initialItem: _height1),
                          children: <Widget>[
                            for (var i = 0; i < 240; i++)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 0),
                                    child: Text(
                                      BuildingNumbers.numbers[i].toString(),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                    ),
                                  )
                                ],
                              ),
                          ],
                          onSelectedItemChanged: (int index) {
                            setState(() {
                              _height1 = index;
                            });
                            //print("height 1:    " + _height1.toString());
                          },
                          looping: true,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(","),
                    ),
                    Expanded(
                      flex: _gFlex,
                      child: Container(
                        height: 140,
                        child: CupertinoPicker(
                          diameterRatio: 10,
                          magnification: 1,
                          squeeze: 1,
                          itemExtent: 60,
                          scrollController: FixedExtentScrollController(
                              initialItem: _height2),
                          children: <Widget>[
                            for (var i = 0; i < 10; i++)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 0),
                                    child: Text(
                                      BuildingNumbers.numbers[i].toString(),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                    ),
                                  )
                                ],
                              ),
                          ],
                          onSelectedItemChanged: (int index) {
                            setState(() {
                              _height2 = index;
                            });
                            //print("height 2:    " + _height2.toString());
                          },
                          looping: true,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: _gFlex,
                      child: Container(
                        height: 140,
                        child: CupertinoPicker(
                          diameterRatio: 10,
                          magnification: 1,
                          squeeze: 1,
                          itemExtent: 60,
                          scrollController:
                              FixedExtentScrollController(initialItem: 0),
                          children: <Widget>[
                            for (var i = 0; i < 1; i++)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 0),
                                    child: Text(
                                      getTranslated(context, "cm"),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                    ),
                                  )
                                ],
                              ),
                          ],
                          looping: false,
                          backgroundColor: Colors.white,
                          onSelectedItemChanged: (int value) {},
                        ),
                      ),
                    ),
                  ]) : 
                  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: _gFlex,
                      child: Container(
                        height: 140,
                        child: CupertinoPicker(
                          diameterRatio: 10,
                          magnification: 1,
                          squeeze: 1,
                          itemExtent: 60,
                          scrollController: FixedExtentScrollController(
                              initialItem: _height2),
                          children: <Widget>[
                            for (var i = 0; i < 10; i++)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 0),
                                    child: Text(
                                      BuildingNumbers.numbers[i].toString(),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                    ),
                                  )
                                ],
                              ),
                          ],
                          onSelectedItemChanged: (int index) {
                            setState(() {
                              _height2 = index;
                            });
                            //print("height 2:    " + _height2.toString());
                          },
                          looping: true,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(","),
                    ),
                    Expanded(
                      flex: _gFlex,
                      child: Container(
                        height: 140,
                        child: CupertinoPicker(
                          diameterRatio: 10,
                          magnification: 1,
                          squeeze: 1,
                          itemExtent: 60,
                          scrollController: FixedExtentScrollController(
                              initialItem: _height1),
                          children: <Widget>[
                            for (var i = 0; i < 240; i++)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 0),
                                    child: Text(
                                      BuildingNumbers.numbers[i].toString(),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                    ),
                                  )
                                ],
                              ),
                          ],
                          onSelectedItemChanged: (int index) {
                            setState(() {
                              _height1 = index;
                            });
                            //print("height 1:    " + _height1.toString());
                          },
                          looping: true,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                    
                    
                    Expanded(
                      flex: _gFlex,
                      child: Container(
                        height: 140,
                        child: CupertinoPicker(
                          diameterRatio: 10,
                          magnification: 1,
                          squeeze: 1,
                          itemExtent: 60,
                          scrollController:
                              FixedExtentScrollController(initialItem: 0),
                          children: <Widget>[
                            for (var i = 0; i < 1; i++)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 0),
                                    child: Text(
                                      getTranslated(context, "cm"),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                    ),
                                  )
                                ],
                              ),
                          ],
                          looping: false,
                          backgroundColor: Colors.white,
                          onSelectedItemChanged: (int value) {},
                        ),
                      ),
                    ),
                  ]),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: Colors.transparent)))),
                      child: Text(
                        getTranslated(context, "cancel"),
                        style: TextStyle(fontSize: 15, color: kPrimaryColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 10,
                    color: Colors.black26,
                  ),
                  Expanded(
                    child: TextButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: Colors.transparent)))),
                      child: Text(
                        getTranslated(context, "save"),
                        style: TextStyle(fontSize: 15, color: kPrimaryColor),
                      ),
                      onPressed: () async {
                        String height =
                            _height1.toString() + "." + _height2.toString();
                        double d_height =
                            double.parse(height.replaceAll(',', ''));

                        print(height);
                        print(d_height);

                        setState(() {
                          Home.currentUser.height = d_height;
                        });
                        final SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.setDouble('height', d_height);
                        updateUser();
                        _updateBMI();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheetBMI(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(bottom: 30),
        //margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(20.0),
            topRight: const Radius.circular(20.0),
            bottomLeft: const Radius.circular(20.0),
            bottomRight: const Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              Text(
                getTranslated(context, "bmi") + ": " + _bmi.toString(),
                style: TextStyle(
                    fontSize: 20,
                    color: getColorSBMI(),
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 30),
              Container(
                  alignment: Home.drawerDirection
                      ? Alignment.topLeft
                      : Alignment.topRight,
                  child: Text(
                    "• " + getTranslated(context, 'txt1_bmi') + ".",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        wordSpacing: 2),
                  )),
              SizedBox(height: 20),
              Container(
                  alignment: Home.drawerDirection
                      ? Alignment.topLeft
                      : Alignment.topRight,
                  child: Text(
                    "• " + getTranslated(context, 'txt2_bmi') + ".",
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        wordSpacing: 2),
                  )),
              SizedBox(height: 20),
              Container(
                  alignment: Home.drawerDirection
                      ? Alignment.topLeft
                      : Alignment.topRight,
                  child: Text(
                    "• " + getTranslated(context, 'txt3_bmi') + ".",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        wordSpacing: 2),
                  )),
              SizedBox(height: 20),
              Container(
                  alignment: Home.drawerDirection
                      ? Alignment.topLeft
                      : Alignment.topRight,
                  child: Text(
                    "• " + getTranslated(context, 'txt4_bmi') + ".",
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        wordSpacing: 2),
                  )),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  double calculateBMI() {
    double height = Home.currentUser.height / 100;
    double weight = Home.currentUser.weight;
    // We dived height by 100 because we are taking the height in centimeter
    // and formula takes height in meter.

    double heightSquare = height * height;
    double result = weight / heightSquare;
    int decimals = 2;
    int fac = pow(10, decimals);
    double d = result;
    d = (d * fac).round() / fac;

    return d;
  }

  Widget bottomSheetWeight(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        /*height: defaultTargetPlatform == TargetPlatform.android
            ? MediaQuery.of(context).size.height * 0.36
            : MediaQuery.of(context).size.height * 0.31,
        width: MediaQuery.of(context).size.width,*/
        margin: EdgeInsets.only(bottom: 30),
        //margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(20.0),
            topRight: const Radius.circular(20.0),
            bottomLeft: const Radius.circular(20.0),
            bottomRight: const Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                child: Text(
                  getTranslated(context, "Choisir le poids"),
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.left,
                ),
                alignment:
                    !isArab ? Alignment.centerLeft : Alignment.centerRight,
                margin: EdgeInsets.only(left: 15, right: 15),
              ),
              SizedBox(height: 20),
              !isArab ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: _gFlex,
                      child: Container(
                        height: 140,
                        child: CupertinoPicker(
                          diameterRatio: 10,
                          magnification: 1,
                          squeeze: 1,
                          itemExtent: 60,
                          scrollController: FixedExtentScrollController(
                              initialItem: _weight1),
                          children: <Widget>[
                            for (var i = 0; i < 160; i++)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 0),
                                    child: Text(
                                      BuildingNumbers.numbers[i].toString(),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                    ),
                                  )
                                ],
                              ),
                          ],
                          onSelectedItemChanged: (int index) {
                            setState(() {
                              _weight1 = index;
                            });
                            //print("weight 1:    " + _weight1.toString());
                          },
                          looping: true,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(","),
                    ),
                    Expanded(
                      flex: _gFlex,
                      child: Container(
                        height: 140,
                        child: CupertinoPicker(
                          diameterRatio: 10,
                          magnification: 1,
                          squeeze: 1,
                          itemExtent: 60,
                          scrollController: FixedExtentScrollController(
                              initialItem: _weight2),
                          children: <Widget>[
                            for (var i = 0; i < 10; i++)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 0),
                                    child: Text(
                                      BuildingNumbers.numbers[i].toString(),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                    ),
                                  )
                                ],
                              ),
                          ],
                          onSelectedItemChanged: (int index) {
                            setState(() {
                              _weight2 = index;
                            });
                            //print("weight 2:    " + _weight2.toString());
                          },
                          looping: true,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: _gFlex,
                      child: Container(
                        height: 140,
                        child: CupertinoPicker(
                          diameterRatio: 10,
                          magnification: 1,
                          squeeze: 1,
                          itemExtent: 60,
                          scrollController:
                              FixedExtentScrollController(initialItem: 0),
                          children: <Widget>[
                            for (var i = 0; i < 1; i++)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 0),
                                    child: Text(
                                      getTranslated(context, "kg"),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                    ),
                                  )
                                ],
                              ),
                          ],
                          looping: false,
                          backgroundColor: Colors.white,
                          onSelectedItemChanged: (int value) {},
                        ),
                      ),
                    ),
                  ]) : 
                  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    
                    Expanded(
                      flex: _gFlex,
                      child: Container(
                        height: 140,
                        child: CupertinoPicker(
                          diameterRatio: 10,
                          magnification: 1,
                          squeeze: 1,
                          itemExtent: 60,
                          scrollController: FixedExtentScrollController(
                              initialItem: _weight2),
                          children: <Widget>[
                            for (var i = 0; i < 10; i++)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 0),
                                    child: Text(
                                      BuildingNumbers.numbers[i].toString(),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                    ),
                                  )
                                ],
                              ),
                          ],
                          onSelectedItemChanged: (int index) {
                            setState(() {
                              _weight2 = index;
                            });
                            //print("weight 2:    " + _weight2.toString());
                          },
                          looping: true,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(","),
                    ),
                    Expanded(
                      flex: _gFlex,
                      child: Container(
                        height: 140,
                        child: CupertinoPicker(
                          diameterRatio: 10,
                          magnification: 1,
                          squeeze: 1,
                          itemExtent: 60,
                          scrollController: FixedExtentScrollController(
                              initialItem: _weight1),
                          children: <Widget>[
                            for (var i = 0; i < 160; i++)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 0),
                                    child: Text(
                                      BuildingNumbers.numbers[i].toString(),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                    ),
                                  )
                                ],
                              ),
                          ],
                          onSelectedItemChanged: (int index) {
                            setState(() {
                              _weight1 = index;
                            });
                            //print("weight 1:    " + _weight1.toString());
                          },
                          looping: true,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                    
                    Expanded(
                      flex: _gFlex,
                      child: Container(
                        height: 140,
                        child: CupertinoPicker(
                          diameterRatio: 10,
                          magnification: 1,
                          squeeze: 1,
                          itemExtent: 60,
                          scrollController:
                              FixedExtentScrollController(initialItem: 0),
                          children: <Widget>[
                            for (var i = 0; i < 1; i++)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 0),
                                    child: Text(
                                      getTranslated(context, "kg"),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                    ),
                                  )
                                ],
                              ),
                          ],
                          looping: false,
                          backgroundColor: Colors.white,
                          onSelectedItemChanged: (int value) {},
                        ),
                      ),
                    ),
                  ]),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: Colors.transparent)))),
                      child: Text(
                        getTranslated(context, "cancel"),
                        style: TextStyle(fontSize: 15, color: kPrimaryColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 10,
                    color: Colors.black26,
                  ),
                  Expanded(
                    child: TextButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: Colors.transparent)))),
                      child: Text(
                        getTranslated(context, "save"),
                        style: TextStyle(fontSize: 15, color: kPrimaryColor),
                      ),
                      onPressed: () async {
                        String weight =
                            _weight1.toString() + "." + _weight2.toString();
                        double d_weight =
                            double.parse(weight.replaceAll(',', ''));

                        //print(weight);
                        //print(d_weight);

                        setState(() {
                          Home.currentUser.weight = d_weight;
                        });
                        final SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.setDouble('weight', d_weight);
                        updateUser();
                        _updateBMI();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheetDateOfBirth(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        /*height: defaultTargetPlatform == TargetPlatform.android
            ? MediaQuery.of(context).size.height * 0.38
            : MediaQuery.of(context).size.height * 0.31,
        width: MediaQuery.of(context).size.width,*/
        margin: EdgeInsets.only(bottom: 30),
        //margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(20.0),
            topRight: const Radius.circular(20.0),
            bottomLeft: const Radius.circular(20.0),
            bottomRight: const Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                child: Text(
                  getTranslated(context, "Choisir la date de naissance"),
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.left,
                ),
                alignment:
                    !isArab ? Alignment.centerLeft : Alignment.centerRight,
                margin: EdgeInsets.only(left: 15, right: 15),
              ),
              SizedBox(height: 25),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                  Widget>[
                Expanded(
                  flex: _gFlex,
                  child: Container(
                    height: 140,
                    child: CupertinoPicker(
                      diameterRatio: 10,
                      magnification: 1,
                      squeeze: 1,
                      itemExtent: 60,
                      scrollController:
                          FixedExtentScrollController(initialItem: _i_day),
                      children: <Widget>[
                        for (var i = 1; i < 32; i++)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 0),
                                child: BuildingNumbers.numbers[i] > 9
                                    ? Text(
                                        BuildingNumbers.numbers[i].toString(),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 25),
                                      )
                                    : Text(
                                        '0' +
                                            BuildingNumbers.numbers[i]
                                                .toString(),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 25),
                                      ),
                              )
                            ],
                          ),
                      ],
                      onSelectedItemChanged: (int index) {
                        setState(() {
                          _i_day = index;
                          index += 1;
                          if (index > 9) {
                            _day = (index).toString();
                          } else {
                            _day = "0" + (index).toString();
                          }
                        });
                        //print("day: " + _day);
                      },
                      looping: true,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  flex: _gFlex,
                  child: Container(
                    height: 140,
                    child: CupertinoPicker(
                      diameterRatio: 10,
                      magnification: 1,
                      squeeze: 1,
                      itemExtent: 60,
                      scrollController:
                          FixedExtentScrollController(initialItem: _i_month),
                      children: <Widget>[
                        for (var i = 0; i < BuildingNumbers.months.length; i++)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 0),
                                child: Text(
                                  !isArab
                                      ? BuildingNumbers.months[i]
                                      : BuildingNumbers.months_arab[i],
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 25),
                                ),
                              )
                            ],
                          ),
                      ],
                      onSelectedItemChanged: (int index) {
                        setState(() {
                          _i_month = index;
                          index += 1;
                          if (index > 9) {
                            _month = (index).toString();
                          } else {
                            _month = "0" + (index).toString();
                          }
                        });
                        //print("month: " + _month);
                      },
                      looping: true,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  flex: _gFlex,
                  child: Container(
                    height: 140,
                    child: CupertinoPicker(
                      diameterRatio: 10,
                      magnification: 1,
                      squeeze: 1,
                      itemExtent: 60,
                      scrollController:
                          FixedExtentScrollController(initialItem: _i_year),
                      children: <Widget>[
                        for (var i = 1700;
                            i < BuildingNumbers.numbers.length;
                            i++)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 0),
                                child: Text(
                                  BuildingNumbers.numbers[i].toString(),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 25),
                                ),
                              )
                            ],
                          ),
                      ],
                      looping: false,
                      backgroundColor: Colors.white,
                      onSelectedItemChanged: (int index) {
                        setState(() {
                          _i_year = index;
                          index += 1700;
                          _year = (index).toString();
                        });
                        //print("year: " + _year);
                      },
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: Colors.transparent)))),
                      child: Text(
                        getTranslated(context, "cancel"),
                        style: TextStyle(fontSize: 15, color: kPrimaryColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 10,
                    color: Colors.black26,
                  ),
                  Expanded(
                    child: TextButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: Colors.transparent)))),
                      child: Text(
                        getTranslated(context, "save"),
                        style: TextStyle(fontSize: 15, color: kPrimaryColor),
                      ),
                      onPressed: () async {
                        String bd =
                            _year + "-" + _month + "-" + _day + " 18:00:00";
                        if (Home.currentUser.birthDate != null) {
                          String ck1 = _year + "-" + _month + "-" + _day;
                          String ck2 = DateFormat("yyyy-MM-dd")
                              .format(Home.currentUser.birthDate);
                          if (ck1 != ck2) {
                            //print(Home.currentUser.birthDate);
                            setState(() {
                              Home.currentUser.birthDate =
                                  DateFormat(kkdateFormat).parse(bd);
                              //print(Home.currentUser.birthDate.toIso8601String()+" ");
                            });
                            final SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                            sharedPreferences.setString('birthDate', bd);
                            updateUser();
                          }
                        } else {
                          setState(() {
                            Home.currentUser.birthDate =
                                DateFormat(kkdateFormat).parse(bd);
                            //print(Home.currentUser.birthDate.toIso8601String()+" ");
                          });
                          final SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          sharedPreferences.setString('birthDate', bd);
                          updateUser();
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheetGender(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return SingleChildScrollView(
        child: Container(
          /*height: defaultTargetPlatform == TargetPlatform.android
              ? MediaQuery.of(context).size.height * 0.32
              : MediaQuery.of(context).size.height * 0.28,
          width: MediaQuery.of(context).size.width,*/
          margin: EdgeInsets.only(bottom: 30),
          //margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(20.0),
              topRight: const Radius.circular(20.0),
              bottomLeft: const Radius.circular(20.0),
              bottomRight: const Radius.circular(20.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  child: Text(
                    getTranslated(context, "Pick gender"),
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.left,
                  ),
                  alignment:
                      !isArab ? Alignment.centerLeft : Alignment.centerRight,
                  margin: EdgeInsets.only(left: 15, right: 15),
                ),
                SizedBox(height: 20),
                Column(
                  children: <Widget>[
                    RadioListTile<Gender>(
                      title: Text(getTranslated(context, "Homme")),
                      value: Gender.Homme,
                      groupValue: _gender,
                      onChanged: (Gender value) {
                        setState(() {
                          _gender = value;
                          //print(_gender.toString() + " chosen");
                        });
                      },
                    ),
                    RadioListTile<Gender>(
                      title: Text(getTranslated(context, "Femme")),
                      value: Gender.Femme,
                      groupValue: _gender,
                      onChanged: (Gender value) {
                        setState(() {
                          _gender = value;
                          //print(_gender.toString() + " chosen");
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: Colors.transparent)))),
                        child: Text(
                          getTranslated(context, "cancel"),
                          style: TextStyle(fontSize: 15, color: kPrimaryColor),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 10,
                      color: Colors.black26,
                    ),
                    Expanded(
                      child: TextButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: Colors.transparent)))),
                        child: Text(
                          getTranslated(context, "save"),
                          style: TextStyle(fontSize: 15, color: kPrimaryColor),
                        ),
                        onPressed: () async {
                          if (Home.currentUser.gender != _gender) {
                            Home.currentUser.gender = _gender;
                            final SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                            sharedPreferences.setString(
                                'gender', _gender.toString());
                            updateUser();
                          }

                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _updateBMI() {
    if (Home.currentUser.height != -1 && Home.currentUser.weight != -1) {
      setState(() {
        _bmi = calculateBMI();
      });
    }
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

  void pickImageFrom(ImageSource source) async {
    final pickedFile = await _imagePicker.getImage(source: source);
    if (pickedFile != null) {
      String img64 = base64Encode(File(pickedFile.path).readAsBytesSync());
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('photo', img64);
      setState(() {
        Home.currentUser.photo = img64;
        _imageProvider = imageFromBase64String(Home.currentUser.photo).image;
      });
      uploadProfileImage();
    }
    Navigator.of(context).pop();
  }

  SnackBar mySnackBar(String text) {
    return SnackBar(
      content: Text(text),
      action: SnackBarAction(
        label: '',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
  }

  String _getAge() {
    if (Home.currentUser.birthDate != null) {
      final now = DateTime.now();
      var difference = (now.difference(Home.currentUser.birthDate).inDays / 365)
          .floor()
          .toString();
      return getTranslated(context, "age") +
          ": " +
          difference +
          " " +
          getTranslated(context, "ans");
    }
    return "";
  }

  Future<String> uploadProfileImage() async {
    String objText = '{"email": "' +
        Home.currentUser.email +
        '", "photo": "' +
        Home.currentUser.photo +
        '" }';
    try {
      final response = await http.put(Uri.http(Url, "/user/updateProfilePic"),
          body: convert.jsonDecode(objText));
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        //print(jsonResponse['message']);
        if (jsonResponse['message'] == 'profile pic updated' && mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(mySnackBar("Photo de profil mise à jour"));
        } else {
          return null;
        }
      }
    } on HttpException catch (err) {
      print("Network exception error: $err");
      return null;
    } finally {
      //
    }
  }

  Future<String> updateUser() async {
    //print(json.encode(Home.currentUser.toJson()));
    try {
      final response = await http.put(Uri.http(Url, "/user/updateUser"),
          body: convert
              .jsonDecode(json.encode(Home.currentUser.toJson()).toString()));
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        print(jsonResponse['message']);
        if (jsonResponse['message'] == 'user updated' && mounted) {
          /*ScaffoldMessenger.of(context)
              .showSnackBar(mySnackBar("user updated"));*/
        } else {
          return null;
        }
      }
    } on HttpException catch (err) {
      print("Network exception error: $err");
      return null;
    } finally {
      //
    }
  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }
}
