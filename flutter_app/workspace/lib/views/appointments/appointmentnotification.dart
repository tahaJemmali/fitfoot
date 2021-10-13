import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:workspace/Login/utils/constants.dart';
import 'package:workspace/constants/default_button.dart';

class NotificationAppointmentPage extends StatefulWidget {
  final DateTime date;
  final String doctorName;
  NotificationAppointmentPage(this.doctorName, this.date);

  @override
  NotificationAppointmentPageState createState() {
    return new NotificationAppointmentPageState(date, doctorName);
  }
}

class NotificationAppointmentPageState
    extends State<NotificationAppointmentPage> {
  final String doctorName;
  final DateTime date;
  NotificationAppointmentPageState(this.date, this.doctorName);
  FlutterLocalNotificationsPlugin fltrNotification;
  String task;
  String med;
  int val;
  //
  DateTime _dateTime = DateTime.now();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  TextEditingController _timeController = TextEditingController();
  String _setTime, _setDate;
  String _hour, _minute, _time;

  Future<void> initState() {
    super.initState();
    var androidInitilize = new AndroidInitializationSettings('fitfoot');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings =
        new InitializationSettings(androidInitilize, iOSinitilize);
    fltrNotification = new FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);
    print(selectedTime.toString());
    medname().then((value) {
      setState(() {
        print(med);
        med = value;
      });
    });
  }

  Future<String> medname() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    med = sharedPreferences.getString("med");
    return med;
  }

  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "Fit Foot", "Rappel",
        importance: Importance.Max);
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(androidDetails, iSODetails);

    DateTime x = _dateTime
        .subtract(Duration(hours: _dateTime.hour))
        .subtract(Duration(minutes: _dateTime.minute))
        .subtract(Duration(seconds: _dateTime.second));
    var scheduledTime;
    scheduledTime = x
        .add(Duration(minutes: selectedTime.minute))
        .add(Duration(hours: selectedTime.hour));
    print(scheduledTime.toString());
    task = "Rendez-vous avec Dr." + doctorName + " : " + date.toString();
    fltrNotification.schedule(1, "Rappel Medicament", task, scheduledTime,
        generalNotificationDetails);
    Navigator.pop(context);
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(getTranslated(context, "Notifications rendez-vous")),
          actions: <Widget>[]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Divider(),
            Text(getTranslated(context, "Rendez-vous avec Dr.") +
                doctorName.toString()),
            Divider(),
            SizedBox(
              height: 20,
            ),
            Text(getTranslated(context,
                "Veuillez choisir la date et le temps de la notification")),
            SizedBox(
              height: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    showDatePicker(
                            context: context,
                            initialDate:
                                _dateTime == null ? DateTime.now() : _dateTime,
                            firstDate: DateTime(2001),
                            lastDate: DateTime(2100))
                        .then((date) {
                      setState(() {
                        _dateTime = date;
                        //updateMyFuture(date);
                      });
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    width: MediaQuery.of(context).size.width / 2.5,
                    height: MediaQuery.of(context).size.height / 12,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    child: TextFormField(
                      style: TextStyle(fontSize: 28, color: Colors.black),
                      textAlign: TextAlign.center,
                      onSaved: (String val) {
                        _setTime = val;
                      },
                      enabled: false,
                      keyboardType: TextInputType.text,
                      //controller: _timeController,
                      decoration: InputDecoration(
                          disabledBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          labelText: DateFormat('yyyy-MM-dd').format(_dateTime),
                          contentPadding: EdgeInsets.all(5)),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _selectTime(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    width: MediaQuery.of(context).size.width / 2.5,
                    height: MediaQuery.of(context).size.height / 12,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    child: TextFormField(
                      style: TextStyle(fontSize: 28, color: Colors.black),
                      textAlign: TextAlign.center,
                      onSaved: (String val) {
                        _setTime = val;
                      },
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: _timeController,
                      decoration: InputDecoration(
                          disabledBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          //labelText: 'Time',
                          contentPadding: EdgeInsets.all(5)),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: MaterialButton(
                  onPressed: () => {},
                  child: DefaultButton2(
                    text: getTranslated(context, 'Créer'),
                    press: () {
                      _showNotification();
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
        ),
      ),
    );
  }

  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("FitFoot : Rappel $payload"),
      ),
    );
  }
}
