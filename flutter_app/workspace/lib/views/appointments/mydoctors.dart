import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/Login/utils/constants.dart';
import 'package:workspace/Models/contactlist.dart';
import 'package:workspace/services/contactservice.dart';
import 'package:workspace/views/appointments/createappointment.dart';

ContactService its = new ContactService();

class DoctorPage extends StatefulWidget {
  @override
  DoctorPageState createState() {
    return new DoctorPageState();
  }
}

class DoctorPageState extends State<DoctorPage> {
  List<ContactList> Contactlist = [];

  @override
  void initState() {
    intitMyFuture();

    super.initState();
  }

  void intialFuture() {
    its.getAllDoctors(Home.currentUser.id).then((value) {
      //change me
      setState(() {
        Contactlist.addAll(value);
      });
    });
  }

  void updateMyFuture() {
    its.getAllDoctors(Home.currentUser.id).then((value) {
      //change me
      setState(() {
        Contactlist.clear();
        Contactlist.addAll(value);
      });
    });
  }

  void intitMyFuture() {
    its.getAllDoctors(Home.currentUser.id).then((value) {
      //change me
      setState(() {
        print(value);
        Contactlist.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(getTranslated(context, 'Mes docteurs')),
        ),
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

  Widget _buildListView() {
    return ListView.builder(
      itemCount: Contactlist.length,
      itemBuilder: (context, index) {
        ContactList xs = Contactlist[index];
        return ListTile(
          title: Text(getTranslated(context, "Dr.") + xs.firstName),
          subtitle: Text(xs.specialty.toString()),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.keyboard_arrow_right),
                onPressed: () async {
                  final SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences.setString('doctorname', xs.firstName);
                  sharedPreferences.setString('doctorphone', xs.phone);
                  sharedPreferences.setString('specialty', xs.specialty);
                  //Navigator.pop(context, xs);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => addAppointmentPage()),
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
