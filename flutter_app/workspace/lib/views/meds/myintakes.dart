import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/Models/medlist.dart';
import 'package:workspace/Models/routinelist.dart';
import 'package:workspace/services/intakeservice.dart';
import 'package:workspace/services/medservice.dart';
import 'package:workspace/services/routineservice.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workspace/views/meds/notification.dart';

MedService ms = new MedService();
RoutineService its = new RoutineService();
IntakeService it = new IntakeService();

class myRoutinePage extends StatefulWidget {
  @override
  myRoutinePageState createState() {
    return new myRoutinePageState();
  }
}

class myRoutinePageState extends State<myRoutinePage> {
  List<RoutineList> list = [];
  List<MedList> medlist = [];
  int nbr;

  MedList get value => null;
  @override
  void initState() {
    runMyFuture();
    FutureM();
    super.initState();
  }

  void runMyFuture() {
    its.getAllRoutines().then((value) {
      setState(() {
        list.addAll(value);

        for (var i = 0; i < list.length; i++) {
          String y = list[i].medid;
          ms.toMed(y).then((val) {
            setState(() {
              medlist.addAll(val);
            });
          });
        }
      });
    });
  }

  void clearMyFuture() {
    its.getAllRoutines().then((value) {
      setState(() {
        print("up");
        list.clear();
        list.addAll(value);
      });
    });
  }

  void FutureM() {
    it.CountIntakes(Home.currentUser.id).then((value) {
      setState(() {
        nbr = value;
        print("$value ss");
      });
    });
  }

  MedList runOneFuture(String id) {
    ms.getMed(id).then((value) {
      setState(() {
        MedList m = value;
      });

      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Mes médicaments'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: _buildListView()),
          ],
        ));
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        RoutineList xs = list[index];
//medlist[index].name
        return ListTile(
          title: Text(xs.medname),
          //subtitle: Text(m.name.toString()),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  //delete func
                  its.deleteRoutine(list[index].id);
                  clearMyFuture();
                  Fluttertoast.showToast(
                      msg: "Médicament éffacé de votre routine !",
                      backgroundColor: Colors.teal,
                      fontSize: 30
                      // gravity: ToastGravity.TOP,
                      // textColor: Colors.pink
                      );
                },
              ),
              IconButton(
                icon: Icon(Icons.notification_important_rounded),
                onPressed: () async {
                  print("nbr " + nbr.toString());
                  final SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences.setString('med', xs.medname.toString());
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationPage()),
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
