import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/Login/utils/constants.dart';
import 'package:workspace/constants/default_button.dart';
import 'package:workspace/Models/activitylist.dart';
import 'package:workspace/services/contactservice.dart';
import 'package:workspace/views/contacts/myContacts.dart';

ContactService its = new ContactService();

class addDoctorPage extends StatefulWidget {
  @override
  addDoctorPageState createState() {
    return new addDoctorPageState();
  }
}

class addDoctorPageState extends State<addDoctorPage> {
  List<ActivityList> list = [];
  String name;
  String specialty;
  String phone;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(getTranslated(context, 'Ajouter un docteur')),
        ),
        body: Column(
          children: <Widget>[
            Divider(),
            /*SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width - 30,
              child: Icon(Icons.local_pharmacy,
                  size: MediaQuery.of(context).size.width / 3,
                  color: Colors.teal),
            ),*/
            Text(getTranslated(context, 'Docteur :'),
                style: TextStyle(fontSize: 25)),
            SizedBox(
              height: 56,
              width: MediaQuery.of(context).size.width - 30,
              child: TextFormField(
                decoration:
                    InputDecoration(labelText: getTranslated(context, 'Nom')),
                keyboardType: TextInputType.text,
                onChanged: (value) => name = value,
              ),
            ),
            Divider(),
            SizedBox(
              height: 56,
              width: MediaQuery.of(context).size.width - 30,
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: getTranslated(context, 'Spécialité')),
                keyboardType: TextInputType.text,
                onChanged: (value) => specialty = value,
              ),
            ),
            Divider(),
            Divider(),
            SizedBox(
              height: 56,
              width: MediaQuery.of(context).size.width - 30,
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: getTranslated(context, 'Numéro de téléphone')),
                keyboardType: TextInputType.phone,
                onChanged: (value) => phone = value,
              ),
            ),
            Divider(),
            DefaultButton2(
              text: (getTranslated(context, 'Ajouter')),
              press: () {
                if (name != null && phone != null && specialty != null) {
                  its.addNewDoctor(name, phone, specialty, Home.currentUser.id); // change me
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyContactsPage(),
                    ),
                  );
                  Fluttertoast.showToast(
                      msg: "Contact Ajouté ",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black45,
                      textColor: Colors.white,
                      fontSize: 14.0);
                } else {
                  Fluttertoast.showToast(
                      msg: "Remplissez les champs",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black45,
                      textColor: Colors.white,
                      fontSize: 14.0);
                }
              },
            ),
            Divider(),
          ],
        ));
  }
}
