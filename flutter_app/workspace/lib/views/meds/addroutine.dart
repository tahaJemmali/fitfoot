import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/Login/utils/constants.dart';
import 'package:workspace/constants/default_button.dart';

import 'package:workspace/Models/medlist.dart';
import 'package:workspace/Models/routine.dart';

import 'package:workspace/services/medservice.dart';
import 'package:workspace/services/routineservice.dart';

import 'addmed.dart';
import 'myintakes.dart';

MedService ms = new MedService();
RoutineService its = new RoutineService();

class addRoutinePage extends StatefulWidget {
  @override
  addRoutinePageState createState() {
    return new addRoutinePageState();
  }
}

class addRoutinePageState extends State<addRoutinePage> {
  List<MedList> list = [];
  bool mine = false;
  @override
  void initState() {
    runMyFuture();
    super.initState();
  }

  void runMyFuture() {
    ms.getAllMeds().then((value) {
      setState(() {
        list.addAll(value);
      });
    });
  }

  void clearMyFuture() {
    list.clear();
    ms.getAllMeds().then((value) {
      setState(() {
        list.addAll(value);
        mine = !mine;
      });
    });
  }

  void MineFuture() {
    list.clear();
    // User Id Tempo
    ms.getCustomMeds(Home.currentUser.id).then((value) {
      setState(() {
        list.addAll(value);
        mine = !mine;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(getTranslated(context, "Médicaments")),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.list_alt),
                tooltip: 'ajouter un médicament',
                onPressed: () {
                  //ScaffoldMessenger.of(context).showSnackBar(
                  //const SnackBar(content: Text('Mes médicaments')));
                  if (mine == true) {
                    clearMyFuture();
                  } else {
                    MineFuture();
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'ajouter un médicament',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => addmedPage()),
                  );
                },
              ),
            ]),
        body: Column(
          children: <Widget>[
            Expanded(child: _buildListView()),
            Divider(),
            DefaultButton2(
              text: getTranslated(context, "Routine"),
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => myRoutinePage()),
                );
              },
            ),
            Divider(),
          ],
        ));
  }

  Icon hello(MedList xs) {
    var x;
    if (xs.creatorid == "admin") {
      x = Icon(Icons.list_alt, color: Colors.grey);
    } else {
      x = Icon(Icons.list_alt, color: Colors.teal);
    }
    return x;
  }

  IconButton deletemine(MedList xs) {
    Icon x = Icon(Icons.delete, color: Colors.grey);
    ;
    var y;

    if (xs.creatorid != "admin") {
      y = IconButton(
        icon: x,
        onPressed: () async {
          ms.deleteMed(xs.id);
          clearMyFuture();
        },
      );
    }
    return y;
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        MedList xs = list[index];
        return ListTile(
          title: Text(xs.name.toString()),
          subtitle: Text(xs.type.toString()),
          leading: hello(xs),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              deletemine(xs) == null ? Container() : deletemine(xs),
              IconButton(
                icon: Icon(Icons.keyboard_arrow_right),
                onPressed: () async {
                  final SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences.setString('med', xs.name.toString());
                  Routine x = new Routine.f(
                      list[index].id, list[index].name, Home.currentUser.id);
                  its.addNewRoutine(x);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => myRoutinePage()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
