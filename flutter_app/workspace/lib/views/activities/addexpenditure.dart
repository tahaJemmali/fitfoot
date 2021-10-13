import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workspace/Login/utils/constants.dart';
import 'package:workspace/constants/default_button.dart';
import 'package:workspace/Models/expenditure.dart';
import 'package:workspace/Models/activitylist.dart';
import 'package:workspace/services/expenditureservice.dart';
import 'package:workspace/services/activityservice.dart';

import 'activityduration.dart';
import 'dailyexpenditures.dart';

ActivityService ms = new ActivityService();
ExpenditureService its = new ExpenditureService();

class addExpenditurePage extends StatefulWidget {
  @override
  addExpenditurePageState createState() {
    return new addExpenditurePageState();
  }
}

class addExpenditurePageState extends State<addExpenditurePage> {
  List<ActivityList> list = [];
  @override
  void initState() {
    runMyFuture();
    super.initState();
  }

  void runMyFuture() {
    ms.getAllActivities().then((value) {
      setState(() {
        list.addAll(value);
      });
      print(list.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(getTranslated(context, 'Liste des activités')),
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: _buildListView()),
            Divider(),
            DefaultButton2(
              text: getTranslated(context, "Dépense d'énérgie"),
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => dailyExpenditurePage()),
                );
              },
            ),
            Divider(),
          ],
        ));
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        ActivityList xs = list[index];
        return ListTile(
          title: Text(xs.name.toString()),
          //subtitle: Text(xs..toString()),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.keyboard_arrow_right),
                onPressed: () async {
                  final SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences.setString(
                      'activityname', xs.name.toString());
                  sharedPreferences.setString('activityid', xs.id.toString());
                  sharedPreferences.setDouble('met', xs.met);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => activityDurationPage()),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}
