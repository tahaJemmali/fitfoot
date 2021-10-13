import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/Login/utils/constants.dart';
import 'package:workspace/constants/default_button.dart';
import 'package:workspace/Models/activitylist.dart';
import 'package:workspace/services/expenditureservice.dart';

ExpenditureService its = new ExpenditureService();

class activityDurationPage extends StatefulWidget {
  @override
  activityDurationPageState createState() {
    return new activityDurationPageState();
  }
}

class activityDurationPageState extends State<activityDurationPage> {
  List<ActivityList> list = [];
  String number = '10';
  double met;
  String id;
  String activityname;
  @override
  void initState() {
    getactivityname().then((value) {
      setState(() {
        print(value);
        activityname = value;
      });
    });
    getactivityid().then((value) {
      setState(() {
        print(value);
        id = value;
      });
    });

    getactivitymet().then((value) {
      setState(() {
        print("met :" + value.toString());
        met = value;
        print(met);
      });
    });

    super.initState();
  }

  /*void runMyFuture() {
    ms.getAllActivities().then((value) {
      setState(() {
        list.addAll(value);
      });
      print(list.length);
    });
  }*/

  Future<String> getactivityname() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    activityname = sharedPreferences.getString("activityname");
    return activityname;
  }

  Future<String> getactivityid() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    id = sharedPreferences.getString("activityid");
    return id;
  }

  Future<double> getactivitymet() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    met = sharedPreferences.getDouble("met");
    return met;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Durée de l'Activité"),
        ),
        body: Column(
          children: <Widget>[
            //Expanded(child: _buildListView()),
            Divider(),
            SizedBox(
              height: 150,
              width: MediaQuery.of(context).size.width - 30,
              child: Icon(Icons.run_circle,
                  size: MediaQuery.of(context).size.width / 3,
                  color: Colors.teal),
            ),
            Text(getTranslated(context, 'Activité :') + activityname,
                style: TextStyle(fontSize: 25)),
            //Divider(),
            SizedBox(
              height: 56,
              width: MediaQuery.of(context).size.width - 30,
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: getTranslated(context, 'Durée en minutes')),
                keyboardType: TextInputType.phone,
                onChanged: (value) => number = value,
              ),
            ),
            /*Expanded(
              
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Durée en minutes'),
                keyboardType: TextInputType.phone,
                onChanged: (value) => number = value,
              ),
            ),*/
            Divider(),
            DefaultButton2(
              text: (getTranslated(context, 'Ajouter')),
              press: () {
                its.addNewExpenditureb(id, activityname, met, number, 60,
                    Home.currentUser.id); //Change me
                //Navigator.pop(context);
                int count = 0;
                Navigator.popUntil(context, (route) {
                  return count++ == 3;
                });
              },
            ),
            Divider(),
          ],
        ));
  }

  /*Widget _buildListView() {
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
                  sharedPreferences.setString('Activity', xs.name.toString());
                  //Expenditure x = new Expenditure.f(list[index].id, list[index].name, list[index].met);
                  its.addNewExpenditure(xs, 30, 60);
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => dailyExpenditurePage()),
                  );*/
                },
              )
            ],
          ),
        );
      },
    );
  }*/
}
