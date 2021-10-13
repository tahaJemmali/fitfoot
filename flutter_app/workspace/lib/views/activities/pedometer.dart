/* import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:workspace/Login/utils/constants.dart';

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

class stepsPage extends StatefulWidget {
  @override
  stepsState createState() {
    return new stepsState();
  }
}

class stepsState extends State<stepsPage> {
  String muestrePasos = "";
  String _km = "Unknown";
  String _calories = "Unknown";

  String _stepCountValue = 'Unknown';
  StreamSubscription<int> _subscription;

  double _numerox;
  double _convert;
  double _kmx;
  double burnedx;
  //double _porciento;

  @override
  void initState() {
    super.initState();
    setUpPedometer();
  }

  void setUpPedometer() {
    Pedometer pedometer = new Pedometer();
    _subscription = pedometer.stepCountStream.listen(_onData,
        onError: _onError, onDone: _onDone, cancelOnError: true);
    //print(_stepCountValue);
  }

  void _onData(int stepCountValue) async {
    print(stepCountValue);
    setState(() {
      _stepCountValue = "$stepCountValue";
      print(_stepCountValue);
    });

    var dist = stepCountValue;
    double y = (dist + .0);

    setState(() {
      _numerox = y;
    });

    var long3 = (_numerox);
    long3 = num.parse(y.toStringAsFixed(2));
    var long4 = (long3 / 10000);

    int decimals = 1;
    int fac = pow(10, decimals);
    double d = long4;
    d = (d * fac).round() / fac;
    print("d: $d");

    getDistanceRun(_numerox);

    setState(() {
      _convert = d;
      print(_convert);
    });
  }

  void reset() {
    setState(() {
      int stepCountValue = 0;
      stepCountValue = 0;
      _stepCountValue = "$stepCountValue";
    });
  }

  void _onDone() {}

  void _onError(error) {
    print("Flutter Pedometer Error: $error");
  }

  //function to determine the distance run in kilometers using number of steps
  void getDistanceRun(double _numerox) {
    var distance = ((_numerox * 78) / 100000);
    distance = num.parse(distance.toStringAsFixed(2));
    var distancekmx = distance * 34;
    distancekmx = num.parse(distancekmx.toStringAsFixed(2));
    //print(distance.runtimeType);
    setState(() {
      _km = "$distance";
      //print(_km);
    });
    setState(() {
      _kmx = num.parse(distancekmx.toStringAsFixed(2));
    });
  }

  //function to determine the calories burned in kilometers using number of steps
  void getBurnedRun() {
    setState(() {
      var calories = _kmx; //dos decimales
      _calories = "$calories";
      //print(_calories);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'My steps')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              getTranslated(context, 'Steps taken:'),
              style: TextStyle(fontSize: 30),
            ),
            Text(
              "$_stepCountValue",
              style: TextStyle(fontSize: 60),
            ),
            Divider(
              height: 100,
              thickness: 0,
              color: Colors.white,
            ),
            /*Text(
              getTranslated(context, 'Pedestrian status:'),
              style: TextStyle(fontSize: 30),
            ),*/
            /*Icon(
              _status == getTranslated(context, 'walking')
                  ? Icons.directions_walk
                  : _status == getTranslated(context, 'stopped')
                      ? Icons.accessibility_new
                      : Icons.error,
              size: 100,
              color: Colors.teal,
            ),*/
            /*Center(
              child: Text(
                _status,
                style: _status == 'walking' || _status == 'stopped'
                    ? TextStyle(fontSize: 30)
                    : TextStyle(fontSize: 20, color: Colors.red),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
 */
