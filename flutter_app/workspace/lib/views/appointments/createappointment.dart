import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/Login/utils/constants.dart';
import 'package:workspace/constants/default_button.dart';
import 'package:workspace/Models/activitylist.dart';
import 'package:workspace/Models/appointment.dart';
import 'package:workspace/Models/contactlist.dart';
import 'package:workspace/services/appointmentservice.dart';
import 'mydoctors.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';

AppointmentService its = new AppointmentService();
String name;
String type;
String phone;
String specialty;

class addAppointmentPage extends StatefulWidget {
  @override
  addAppointmentPageState createState() {
    return new addAppointmentPageState();
  }
}

class addAppointmentPageState extends State<addAppointmentPage> {
  List<ActivityList> list = [];
  DateTime _dateTime = DateTime.now();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  ContactList doc = new ContactList();
  TextEditingController _timeController = TextEditingController();
  String _setTime, _setDate;

  String _hour, _minute, _time;
  @override
  void initState() {
    super.initState();
    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();

    docName().then((value) {
      setState(() {
        name = value;
      });
    });

    docPhone().then((value) {
      setState(() {
        phone = value;
      });
    });

    docSpecialty().then((value) {
      setState(() {
        specialty = value;
      });
    });
  }

  Future<String> docPhone() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    phone = sharedPreferences.getString("doctorphone");
    return phone;
  }

  Future<String> docName() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    name = sharedPreferences.getString("doctorname");
    return name;
  }

  Future<String> docSpecialty() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    specialty = sharedPreferences.getString("specialty");
    return specialty;
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
            title: Text(getTranslated(context, "Ajouter un rendez-vous")),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add_call),
                tooltip: 'choisir un médcin enregistré',
                onPressed: () {
                  //_awaitReturnValueFromSecondScreen(context);
                  /*Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => DoctorPage()),
              );*/
                },
              ),
            ]),
        body: Column(
          children: <Widget>[
            Divider(),
            SizedBox(
              height: MediaQuery.of(context).size.height / 8,
              width: MediaQuery.of(context).size.width - 30,
              child: Icon(Icons.meeting_room,
                  size: MediaQuery.of(context).size.width / 3,
                  color: Colors.teal),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 14,
              width: MediaQuery.of(context).size.width - 30,
              child: TextFormField(
                controller: TextEditingController()..text = '$name',
                decoration: InputDecoration(
                    labelText: getTranslated(context, "Nom du medicin")),
                keyboardType: TextInputType.text,
                onChanged: (value) => name = value,
              ),
            ),
            Divider(),
            SizedBox(
              height: MediaQuery.of(context).size.height / 14,
              width: MediaQuery.of(context).size.width - 30,
              child: TextFormField(
                controller: TextEditingController()..text = '$phone',
                decoration: InputDecoration(
                    labelText: getTranslated(context, "Numéro de téléphone")),
                keyboardType: TextInputType.phone,
                onChanged: (value) => type = value,
              ),
            ),
            Divider(),
            SizedBox(
              height: MediaQuery.of(context).size.height / 14,
              width: MediaQuery.of(context).size.width - 30,
              child: TextFormField(
                controller: TextEditingController()..text = '$specialty',
                decoration: InputDecoration(
                    labelText: getTranslated(context, 'Spécialité')),
                keyboardType: TextInputType.text,
                onChanged: (value) => name = value,
              ),
            ),
            Divider(),
            Row(
              children: [
                Spacer(),
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
                        if (date.year != null) {
                          _dateTime = date;
                        }
                        //updateMyFuture(date);
                      });
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    width: MediaQuery.of(context).size.width / 2.3,
                    height: MediaQuery.of(context).size.height / 12,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    child: TextFormField(
                      style: TextStyle(fontSize: 28),
                      textAlign: TextAlign.center,
                      onSaved: (String val) {
                        _setTime = val; //
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
                    width: MediaQuery.of(context).size.width / 2.3,
                    height: MediaQuery.of(context).size.height / 12,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    child: TextFormField(
                      style: TextStyle(fontSize: 28),
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
                Spacer(),
              ],
            ),
            Divider(),
            DefaultButton2(
              text: (getTranslated(context, "Ajouter")),
              press: () {
                if (name != null) {
                  Appointment appointment = new Appointment(
                      name, "a", phone, false, false, Home.currentUser.id);
                  DateTime sTime = new DateTime(_dateTime.year, _dateTime.month,
                      _dateTime.day, selectedTime.hour, selectedTime.minute);
                  its.addNewAppointment(
                      appointment, sTime.toString(), Home.currentUser.id);
                  int count = 0;
                  Navigator.popUntil(context, (route) {
                    return count++ == 3;
                  });
                  Fluttertoast.showToast(
                      msg: "Rendez-vous ajouté ",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black45,
                      textColor: Colors.white,
                      fontSize: 14.0);
                } else {}
              },
            ),
            Divider(),
          ],
        ));
  }
}
