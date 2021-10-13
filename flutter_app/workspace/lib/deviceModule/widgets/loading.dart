import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workspace/AnalyseModule/classes/Static.dart';
import 'package:workspace/AnalyseModule/classes/mesure.dart';
import 'package:workspace/AnalyseModule/widgets/circular_progress_button.dart';
import 'package:workspace/AnalyseModule/widgets/delayed_animation.dart';
import 'package:workspace/AnalyseModule/widgets/resultat/resultat.dart';
import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/Login/utils/constants.dart';
import 'package:workspace/deviceModule/classes/pied.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

const TWO_PI = 3.14 * 2;

class Loading extends StatefulWidget {
  Loading(this.pied1, this.pied2);
  final Pied pied1;
  final Pied pied2;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Loading> {
  Future<Null> _onAnimationComplete() async {
    await Future.delayed(Duration(seconds: 2));
    double dimInitial1 = 0, dimInitial2 = 0;
    double dim1, temp1, roug1;
    double dim2, temp2, roug2;
    Statis.amel1 = 500;
    Statis.amel2 = 500;

    // Future<Mesure> m = _getDimension();
    // Future<Mesure> x = _getAmelioration();
    _getDimension().then((value) => {
          if (value != null)
            {
              if (widget.pied1.temperature < 0)
                {
                  widget.pied1.temperature = 27,
                },
              if (widget.pied2.temperature < 0)
                {
                  widget.pied2.temperature = 27,
                },
              if (widget.pied1.dimention == 0)
                {
                  widget.pied1.dimention = 1,
                },
              if (widget.pied2.dimention == 0)
                {
                  widget.pied2.dimention = 1,
                },
              dimInitial1 = value.pied1.dimention.toDouble(),
              dimInitial2 = value.pied2.dimention.toDouble(),
              dim1 = (widget.pied1.dimention.toDouble() * 100) / dimInitial1,
              temp1 = (widget.pied1.temperature * 100) / 27,
              roug1 = widget.pied1.rougeur,
              widget.pied1.etat =
                  (dim1 * 0.5 + roug1 * 0.3 + temp1 * 0.2) / 100,
              dim2 = (widget.pied2.dimention.toDouble() * 100) / dimInitial2,
              temp2 = (widget.pied2.temperature * 100) / 27,
              roug2 = widget.pied2.rougeur,
              widget.pied2.etat =
                  (dim2 * 0.5 + roug2 * 0.3 + temp2 * 0.2) / 100,
              _getAmelioration().then((s) => {
                    /////PIED 1

                    if (s.pied1.etat != -500 && s.pied2.etat != -500)
                      {
                        Statis.amel1 = widget.pied1.etat - s.pied1.etat,
                        widget.pied1.amelioration = Statis.amel1,
                        Statis.amel2 = widget.pied2.etat - s.pied2.etat,
                      }
                    else
                      {
                        Statis.amel1 = 500,
                        Statis.amel2 = 500,
                      },
                    widget.pied1.amelioration = Statis.amel1,
                    widget.pied2.amelioration = Statis.amel2,
                    //print("2:"+Statis.amel1.toString()),
                    _newMesure(widget.pied1, widget.pied2),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Resultat(widget.pied1, widget.pied2))),
                  }),
            }
          else
            {
              widget.pied1.etat = -500,
              widget.pied2.etat = -500,
              widget.pied1.amelioration = -500,
              widget.pied2.amelioration = -500,
              _newMesure(widget.pied1, widget.pied2),
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Home())),
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0))),
                    content: Container(
                      height: 230,
                      width: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  getTranslated(context, "anatermine"),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                            height: 2,
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Expanded(
                            child: Center(
                              child: Container(
                                height: 130,
                                width: 299,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(0.0),
                                  border: Border.all(
                                      color: kPrimaryColor,
                                      style: BorderStyle.solid,
                                      width: 2.0),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 2.0),
                                    child: Text(
                                      getTranslated(context, "aprenext"),
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          new GestureDetector(
                            onTap: () => {
                              Navigator.of(context).pop(),
                            },
                            child: InkWell(
                              child: Container(
                                width: 200,
                                height: 50,
                                padding: EdgeInsets.only(top: 5, bottom: 10),
                                decoration: BoxDecoration(
                                  color: new Color(0xFF00A19A),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(32.0),
                                      bottomRight: Radius.circular(32.0)),
                                ),
                                child: Expanded(
                                  flex: 2,
                                  child: Text(
                                    getTranslated(context, "daccord"),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            }
        });

    return null;
  }

//add pied
  Future<String> _newPied(Pied p) async {
    try {
      final response =
          await http.post(Uri.http(Url, "/pied/addPied"), body: p.toJson());
      if (response.statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        return jsonResponse['message'];
      }
    } on HttpException catch (err) {
      //print("Network exception error: $err");
      return null;
    }
  }

  // ignore: missing_return
  Future<String> _newMesure(Pied p1, Pied p2) async {
    await _newPied(p1).then((value) => p1.id = value);
    await _newPied(p2).then((value) => {p2.id = value, _addMesure(p1, p2)});
  }

  Future<String> _addMesure(Pied p1, Pied p2) async {
    final DateTime now = DateTime.now();

    Mesure mesure = new Mesure(
        emailUser: Home.currentUser.email, date: now, pied1: p1, pied2: p2);

    try {
      final response = await http.post(Uri.http(Url, "/mesure/addMesure"),
          body: mesure.toJson());
      if (response.statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        return jsonResponse['message'];
      }
    } on HttpException catch (err) {
      //print("Network exception error: $err");
      return null;
    } finally {}
  }

  // ignore: missing_return
  Future<Mesure> _getDimension() async {
    String objText = '{"email": "' + Home.currentUser.email + '" }';
    try {
      final response = await http.post(Uri.http(Url, "/mesure/getDimension"),
          body: convert.jsonDecode(objText));
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);

        if (jsonResponse['message'] == 'donem') {
          Mesure m = Mesure.fromJson(jsonResponse['firstMesure']);

          return m;
        } else
          return null;
      }
    } on HttpException catch (err) {
      //print("Network exception error: $err");
      return null;
    } finally {}
  }

  // ignore: missing_return
  Future<Mesure> _getAmelioration() async {
    String objText = '{"email": "' + Home.currentUser.email + '" }';
    try {
      final response = await http.post(Uri.http(Url, "/mesure/getAmelioration"),
          body: convert.jsonDecode(objText));
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        if (jsonResponse['message'] == 'donem') {
          Mesure s = Mesure.fromJson(jsonResponse['lastMesure']);

          return s;
        } else
          return null;
      }
    } on HttpException catch (err) {
      //print("Network exception error: $err");
      return null;
    } finally {}
  }

  bool isArab = false;
  SharedPreferences sharedPreferences;

  Future<void> getShared() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
    final size = 200.0;
    int percentage;

    //// affectation amelioration to do
    return WillPopScope(
      onWillPop: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(getTranslated(context, "vulez")),
              content: Text(getTranslated(context, "toutledon")),
              actions: <Widget>[
                new FlatButton(
                  child: new Text(getTranslated(context, "wi")),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => Home()));
                  },
                ),
                new FlatButton(
                  child: new Text(getTranslated(context, "nn")),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(title: Text(getTranslated(context, "ancomplete"))),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 7)),
              Center(
                child: TweenAnimationBuilder(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(seconds: 6),
                  // ignore: missing_return
                  builder: (context, value, child) {
                    percentage = (value * 100).ceil();
                    return Container(
                      width: 250,
                      height: 250,
                      child: Stack(
                        children: [
                          ShaderMask(
                            shaderCallback: (rect) {
                              return SweepGradient(
                                  startAngle: 0.0,
                                  endAngle: TWO_PI,
                                  stops: [value, value],
                                  // 0.0 , 0.5 , 0.5 , 1.0
                                  center: Alignment.center,
                                  colors: [
                                    new Color(0xFF00A19A),
                                    Colors.grey.withAlpha(55)
                                  ]).createShader(rect);
                            },
                            child: Container(
                              width: 250,
                              height: 250,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: Image.asset(
                                              "lib/AnalyseModule/assets/radial_scale.png")
                                          .image)),
                            ),
                          ),
                          Center(
                            child: Container(
                              width: size - 40,
                              height: size - 40,
                              decoration: BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              child: Center(
                                  child: Text(
                                "$percentage",
                                style: TextStyle(
                                    fontSize: 40, color: Colors.cyan.shade800),
                              )),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                  ),
                  Expanded(
                    child: DelayedAnimation(
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/temperature.png',
                              height: 50,
                              width: 50,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              getTranslated(context, "ttemp"),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.width < 380
                                          ? 12
                                          : 18),
                            ),
                          ],
                        ),
                      ),
                      delay: 1500,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                  ),
                  Expanded(
                    child: DelayedAnimation(
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/gonflement.png',
                              height: 50,
                              width: 50,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              getTranslated(context, "gonfo"),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.width < 380
                                          ? 12
                                          : 18),
                            ),
                          ],
                        ),
                      ),
                      delay: 3000,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                  ),
                  Expanded(
                    child: DelayedAnimation(
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/rougeur.png',
                              height: 50,
                              width: 50,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              getTranslated(context, "rou"),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.width < 380
                                          ? 12
                                          : 18),
                            ),
                          ],
                        ),
                      ),
                      delay: 4500,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
              ),
              SizedBox(
                height: 80,
              ),
              DelayedAnimation(
                child: CircularProgressButton(
                    text: getTranslated(context, "conti"),
                    textStyle: TextStyle(color: Colors.white, fontSize: 35),
                    width: 300,
                    onAnimationComplete: _onAnimationComplete),
                delay: 6000,
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
