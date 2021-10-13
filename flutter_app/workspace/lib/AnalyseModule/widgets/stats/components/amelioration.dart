/// Package imports
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:workspace/AnalyseModule/classes/Static.dart';
import 'package:workspace/Login/utils/constants.dart';

import 'default_data_labels.dart';

///Renders default column chart sample
class Amelioration extends StatefulWidget {
  ///Renders default column chart sample
  Amelioration({Key key}) : super(key: key);
  @override
  _AmeliorationState createState() => _AmeliorationState();
}

class _AmeliorationState extends State<Amelioration> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
    return RepaintBoundary(
      child: Scaffold(
          body: Column(children: [
        chart(isArab),
        chartki(),
      ])),
    );
  }

  Expanded chart(bool a) {
    if (a) {
      return Expanded(
        child: Container(
          transform: Matrix4.translationValues(
              -MediaQuery.of(context).size.width * 0.97, 0.0, 0.0),
          child: DataLabelDefault(),
        ),
      );
    } else
      return Expanded(child: DataLabelDefault());
  }

  Expanded chartki() {
    if (Statis.m.isNotEmpty && Statis.m.elementAt(0).dataSource.isNotEmpty) {
      return Expanded(flex: 0, child: padi());
    } else {
      return Expanded(
        flex: 0,
        child: Text(""),
      );
    }
  }

  Padding padi() {
    if (MediaQuery.of(context).size.width < 310 &&
        MediaQuery.of(context).size.width > 280) {
      return Padding(
        padding: const EdgeInsets.only(left: 60, right: 20, bottom: 20),
        child: Expanded(
          child: Row(
            children: [
              Container(
                width: 15,
                height: 15,
                color: const Color.fromRGBO(203, 164, 199, 1),
              ),
              SizedBox(
                width: 2,
              ),
              Text(getTranslated(context, "piedg")),
              SizedBox(
                width: 20,
              ),
              Container(
                width: 15,
                height: 15,
                color: const Color.fromRGBO(140, 198, 64, 1),
              ),
              SizedBox(
                width: 2,
              ),
              Text(getTranslated(context, "piedd")),
            ],
          ),
        ),
      );
    } else if (MediaQuery.of(context).size.width < 280 &&
        MediaQuery.of(context).size.width > 265) {
      return Padding(
        padding: const EdgeInsets.only(left: 60, right: 2, bottom: 20),
        child: Expanded(
          child: Row(
            children: [
              Container(
                width: 15,
                height: 15,
                color: const Color.fromRGBO(203, 164, 199, 1),
              ),
              SizedBox(
                width: 2,
              ),
              Text(getTranslated(context, "piedg")),
              SizedBox(
                width: 20,
              ),
              Container(
                width: 15,
                height: 15,
                color: const Color.fromRGBO(140, 198, 64, 1),
              ),
              SizedBox(
                width: 2,
              ),
              Text(getTranslated(context, "piedd")),
            ],
          ),
        ),
      );
    } else if (MediaQuery.of(context).size.width < 265) {
      return Padding(
        padding: const EdgeInsets.only(left: 0, right: 0, bottom: 20),
        child: Expanded(
          child: Row(
            children: [
              Container(
                width: 15,
                height: 15,
                color: const Color.fromRGBO(203, 164, 199, 1),
              ),
              SizedBox(
                width: 2,
              ),
              Text(getTranslated(context, "piedg")),
              SizedBox(
                width: 20,
              ),
              Container(
                width: 15,
                height: 15,
                color: const Color.fromRGBO(140, 198, 64, 1),
              ),
              SizedBox(
                width: 2,
              ),
              Text(getTranslated(context, "piedd")),
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 60, right: 50, bottom: 20),
        child: Expanded(
          child: Row(
            children: [
              Container(
                width: 15,
                height: 15,
                color: const Color.fromRGBO(203, 164, 199, 1),
              ),
              SizedBox(
                width: 2,
              ),
              Text(getTranslated(context, "piedg")),
              SizedBox(
                width: 20,
              ),
              Container(
                width: 15,
                height: 15,
                color: const Color.fromRGBO(140, 198, 64, 1),
              ),
              SizedBox(
                width: 2,
              ),
              Text(getTranslated(context, "piedd")),
            ],
          ),
        ),
      );
    }
  }
}
