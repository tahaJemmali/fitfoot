/// Package imports
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Chart import
import 'package:workspace/Login/utils/constants.dart';

import 'bar_with_track.dart';

///Renders default column chart sample
class Frequence extends StatefulWidget {
  ///Renders default column chart sample
  Frequence({Key key}) : super(key: key);

  @override
  _FrequenceState createState() => _FrequenceState();
}

class _FrequenceState extends State<Frequence> {
  // ScaffoldState _scaffoldState;
  void initState() {
    super.initState();
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        body: Column(children: [
          Expanded(
            child: BarTracker(),
          ),
        ]));
  }
}
