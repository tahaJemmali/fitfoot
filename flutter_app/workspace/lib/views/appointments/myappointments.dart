import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/Login/utils/constants.dart';
//import 'package:flutter_phone_state/flutter_phone_state.dart';
import 'package:workspace/Models/appointmentlist.dart';
import 'package:workspace/Models/contact.dart';
import 'package:workspace/services/appointmentservice.dart';
import 'package:workspace/views/appointments/appointmentnotification.dart';
import 'package:workspace/views/appointments/mydoctors.dart';

AppointmentService its = new AppointmentService();

class appointmentPage extends StatefulWidget {
  @override
  AppointmentPageState createState() {
    return new AppointmentPageState();
  }
}

class AppointmentPageState extends State<appointmentPage> {
  List<AppointmentList> Appointmentlist = [];
  DateTime _dateTime = DateTime.now();
  Contact xs;
  DateTime now = DateTime.now();
  FlutterLocalNotificationsPlugin fltrNotification;
  String task;
  double somme = 0;

  @override
  void initState() {
    DateTime date;
    intitMyFuture(date);

    super.initState();
  }

  void intialFuture() {
    its.todayAppointments(Home.currentUser.id).then((value) {
      //change me
      setState(() {
        Appointmentlist.addAll(value);
      });
    });
  }

  void updateMyFuture() {
    its.getAppointments(Home.currentUser.id).then((value) {
      //change me
      setState(() {
        Appointmentlist.clear();
        Appointmentlist.addAll(value);
      });
    });
  }

  void intitMyFuture(DateTime date) {
    its.todayAppointments(Home.currentUser.id).then((value) {
      //change me
      setState(() {
        print(value);
        Appointmentlist.addAll(value);
      });
    });
  }

  _callNumber(String phone) async {
    bool res = await FlutterPhoneDirectCaller.callNumber(phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(getTranslated(context, "Rendez-vous à venir")),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'ajouter une rendez-vous',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DoctorPage()),
                  );
                },
              ),
            ]),
        body: Column(
          children: <Widget>[
            Divider(),
            SizedBox(
              height: 20,
              width: 20,
            ),
            Expanded(child: _buildListView()),
            Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: []),
            Divider(),
          ],
        ));
  }

  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "Fit Foot", "Rappel",
        importance: Importance.Max);
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(androidDetails, iSODetails);

    var scheduledTime;

    scheduledTime = DateTime.now().add(Duration(seconds: 10));

    print(scheduledTime.toString() + "abc");
    fltrNotification.schedule(1, "Rappel Medicament", 'task', scheduledTime,
        generalNotificationDetails);
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: Appointmentlist.length,
      itemBuilder: (context, index) {
        AppointmentList xs = Appointmentlist[index];
        return ListTile(
          title: Text(getTranslated(context, "Dr.") + xs.doctorname.toString()),
          subtitle: Text(xs.date.toString()),
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.add_alert),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationAppointmentPage(
                            xs.doctorname, xs.date)),
                  );
                },
              )
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  its.deleteAppointment(xs.id);
                  updateMyFuture();
                },
              ),
              IconButton(
                icon: Icon(Icons.call),
                onPressed: () {
                  _callNumber(xs.doctorphone);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
