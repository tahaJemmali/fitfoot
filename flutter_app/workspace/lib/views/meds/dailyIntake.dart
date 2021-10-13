import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/Login/utils/constants.dart';
import 'package:workspace/constants/default_button.dart';
import 'package:workspace/Models/Intake.dart';
import 'package:workspace/Models/Intakelist.dart';
import 'package:workspace/Models/Intakelist.dart';
import 'package:intl/intl.dart';
import 'package:workspace/Models/routinelist.dart';
import 'package:workspace/services/intakeservice.dart';
import 'package:workspace/services/routineservice.dart';
import 'package:fluttertoast/fluttertoast.dart';

RoutineService rs = new RoutineService();
IntakeService its = new IntakeService();

class dailyIntakePage extends StatefulWidget {
  @override
  dailyIntakePageState createState() {
    return new dailyIntakePageState();
  }
}

class dailyIntakePageState extends State<dailyIntakePage> {
  List<RoutineList> rlist = [];
  List<IntakeList> intakelists = [];
  DateTime _dateTime = DateTime.now();
  DateTime now = DateTime.now();

  @override
  void initState() {
    runMyFuture();
    //intialFuture();
    super.initState();
  }

  void intialFuture() {
    its.todayIntakes(Home.currentUser.id).then((value) {
      //change me
      setState(() {
        intakelists.addAll(value);
      });
    });
  }

  void runMyFuture() {
    its.todayIntakes(Home.currentUser.id).then((value) {
      //change me
      setState(() {
        intakelists.addAll(value);
        if (intakelists.length == 0) {
          rs.getAllRoutines().then((value2) {
            //change me
            setState(() {
              rlist.addAll(value2);

              for (var i = 0; i < rlist.length; i++) {
                Intake intake = new Intake.f2(rlist[i].medid, rlist[i].medname,
                    Home.currentUser.id); //change me
                its.addNewIntake(intake);
              }
              its.todayIntakes(Home.currentUser.id).then((value) {
                //change me
                setState(() {
                  intakelists.clear();
                  intakelists.addAll(value);
                  Fluttertoast.showToast(
                      msg: "Generated Today's Routine",
                      backgroundColor: Colors.teal,
                      fontSize: 30
                      // gravity: ToastGravity.TOP,
                      // textColor: Colors.pink
                      );
                });
              });
            });
          });
        }
      });
    });
    //intialFuture();
  }

  void updateMyFuture(DateTime date) {
    its.dayIntakes(date, Home.currentUser.id).then((value) {
      //change me
      setState(() {
        intakelists.clear();
        intakelists.addAll(value);
        print(intakelists.length);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(getTranslated(context, 'Mes médicaments')),
        ),
        body: Column(
          children: <Widget>[
            Divider(),

            Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      DateFormat('yyyy-MM-dd')
                                          .format(_dateTime),
                                      style: TextStyle(fontSize: 35)),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                            margin: EdgeInsets.only(left: 20),
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: [],
                                            )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ))),

            //
            Divider(),
            SizedBox(
              height: 20,
              width: 20,
            ),
            ...intakelists.map(buildSingleCheckbox).toList(),
            //Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: []),

            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: MaterialButton(
                  onPressed: () => {},
                  child: DefaultButton2(
                    text: getTranslated(context, 'Changer la date'),
                    press: () {
                      showDatePicker(
                              context: context,
                              initialDate: _dateTime == null
                                  ? DateTime.now()
                                  : _dateTime,
                              firstDate: DateTime(2001),
                              lastDate: DateTime(2100))
                          .then((date) {
                        setState(() {
                          if (date.year != null) {
                            _dateTime = date;
                            updateMyFuture(date);
                          }
                        });
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
              width: 20,
            ),
          ],
        ));
  }

  /*Widget _buildListView() {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        MedList xs = list[index];
        return ListTile(
          title: Text(xs.name.toString()),
          subtitle: Text(xs.type.toString()),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.keyboard_arrow_right),
                onPressed: () {
                  Intake x = new Intake.f(list[index].id);
                  //its.addNewIntake(x);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => myIntakePage()),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }*/

  Widget buildToggleCheckbox(IntakeList intakelist) => buildCheckbox(
      intakelist: intakelist,
      onClicked: () {
        final newValue = !intakelist.checked;

        setState(() {
          intakelists.forEach((intakelist) {
            intakelist.checked = newValue;
          });
        });
      });

//done
  Widget buildSingleCheckbox(IntakeList intakelist) => buildCheckbox(
        intakelist: intakelist,
        onClicked: () {
          setState(() {
            final newValue = !intakelist.checked;
            intakelist.checked = newValue;
            its.checkIntake(intakelist.id);
            if (newValue == true) {
              Fluttertoast.showToast(
                  msg: "Checked", backgroundColor: Colors.teal, fontSize: 30
                  // gravity: ToastGravity.TOP,
                  // textColor: Colors.pink
                  );
            } else {
              Fluttertoast.showToast(
                  msg: "Unchecked", backgroundColor: Colors.teal, fontSize: 30
                  // gravity: ToastGravity.TOP,
                  // textColor: Colors.pink
                  );
            }
          });
        },
      );

  Widget buildCheckbox({
    @required IntakeList intakelist,
    @required VoidCallback onClicked,
  }) =>
      ListTile(
        onTap: onClicked,
        leading: Checkbox(
          value: intakelist.checked,
          onChanged: (value) => onClicked(),
        ),
        title: Text(
          intakelist.medname,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
}
