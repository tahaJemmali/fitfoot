import 'package:flutter/material.dart';
import 'dart:async';
//import 'package:pedometer/pedometer.dart';
import 'package:workspace/Login/utils/constants.dart';

import 'a.dart';

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
  Stream<StepCount> _stepCountStream;
  Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?', _distance = '?', _calories = "?";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps.toString();
      double dis = event.steps / 1322;
      double calories = dis * 70;
      _distance = dis.toStringAsFixed(3) + " KM";
      _calories = /*_distance +*/ calories.toStringAsFixed(3) + " Kcal";
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = getTranslated(context, 'Pedestrian Status not available');
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = getTranslated(context, 'Step Count not available');
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
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
            Column(
              children: [
                Text(
                  _steps,
                  style: TextStyle(fontSize: 60),
                ),SizedBox(height: 10,width: 10,),
                Text(
                  _distance,
                  style: TextStyle(fontSize: 25),
                ),
                Text(
                  _calories,
                  style: TextStyle(fontSize: 25),
                ),
              ],
            ),
            Divider(
              height: 100,
              thickness: 0,
              color: Colors.white,
            ),
            Text(
              getTranslated(context, 'Pedestrian status:'),
              style: TextStyle(fontSize: 30),
            ),
            Icon(
              _status == getTranslated(context, 'walking')
                  ? Icons.directions_walk
                  : _status == getTranslated(context, 'stopped')
                      ? Icons.accessibility_new
                      : Icons.error,
              size: 100,
              color: Colors.teal,
            ),
            Center(
              child: Text(
                _status,
                style: _status == 'walking' || _status == 'stopped'
                    ? TextStyle(fontSize: 30)
                    : TextStyle(fontSize: 20, color: Colors.red),
              ),
            )
          ],
        ),
      ),
    );
  }
}
