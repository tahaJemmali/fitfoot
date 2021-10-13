import 'package:flutter/material.dart';
import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/Login/utils/constants.dart';
import 'package:workspace/constants/default_button.dart';
import 'package:workspace/Models/expenditurelist.dart';
import 'package:intl/intl.dart';
import 'package:workspace/services/expenditureservice.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workspace/views/activities/addexpenditure.dart';

ExpenditureService its = new ExpenditureService();

class dailyExpenditurePage extends StatefulWidget {
  @override
  dailyExpenditurePageState createState() {
    return new dailyExpenditurePageState();
  }
}

class dailyExpenditurePageState extends State<dailyExpenditurePage> {
  //List<RoutineList> rlist = [];
  List<ExpenditureList> expenditurelist = [];
  DateTime _dateTime = DateTime.now();

  DateTime now = DateTime.now();

  double somme = 0;

  @override
  void initState() {
    DateTime date;
    intitMyFuture(date);
    super.initState();
  }

  void intialFuture() {
    its.todayExpenditures(Home.currentUser.id).then((value) {
      //change me
      setState(() {
        expenditurelist.addAll(value);
        for (int i = 0; i < expenditurelist.length; i++) {
          somme = somme + expenditurelist[i].caloriesburned;
        }
      });
    });
  }

  void updateMyFuture(DateTime date) {
    its.dayExpenditures(date, Home.currentUser.id).then((value) {
      //change me
      setState(() {
        expenditurelist.clear();
        expenditurelist.addAll(value);
        print(expenditurelist.length);
        somme = 0;
        for (int i = 0; i < expenditurelist.length; i++) {
          somme = somme + expenditurelist[i].caloriesburned;
        }
      });
    });
  }

  void intitMyFuture(DateTime date) {
    its.todayExpenditures(Home.currentUser.id).then((value) {
      //change me
      setState(() {
        print(value);
        expenditurelist.clear();
        expenditurelist.addAll(value);
        print(expenditurelist.length);
        for (int i = 0; i < expenditurelist.length; i++) {
          somme = somme + expenditurelist[i].caloriesburned;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(getTranslated(context, 'Activités')),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'ajouter une activité',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => addExpenditurePage()),
                  );
                },
              ),
            ]),
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
            Divider(),
            SizedBox(
              height: 20,
              width: 20,
            ),
            Expanded(child: _buildListView()),
            //Divider(),
            Text("totale : " + somme.toString() + " kcal"),
            Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              new Flexible(
                child: DefaultButton2(
                  text: getTranslated(context, 'Changer la date'),
                  press: () {
                    showDatePicker(
                            context: context,
                            initialDate:
                                _dateTime == null ? DateTime.now() : _dateTime,
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
            ]),
            Divider(),
          ],
        ));
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: expenditurelist.length,
      itemBuilder: (context, index) {
        ExpenditureList xs = expenditurelist[index];
        return ListTile(
          title: Text(xs.activityname.toString()),
          subtitle: Text(xs.caloriesburned.toString() +
              getTranslated(context, 'kcal') +
              " (" +
              xs.duration.toString() +
              getTranslated(context, 'mins') +
              ")"),
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.sports),
                onPressed: () {},
              )
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  its.deleteExpenditure(xs.id);
                  updateMyFuture(_dateTime);
                },
              )
            ],
          ),
        );
      },
    );
  }
}
