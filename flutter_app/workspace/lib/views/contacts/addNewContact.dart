import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/Login/utils/constants.dart';
import 'package:workspace/constants/default_button.dart';

import 'package:workspace/Models/activitylist.dart';
import 'package:workspace/Models/contact.dart';
import 'package:workspace/services/contactservice.dart';
import 'package:workspace/views/contacts/myContacts.dart';

ContactService its = new ContactService();

class addContactPage extends StatefulWidget {
  @override
  addContactPageState createState() {
    return new addContactPageState();
  }
}

class addContactPageState extends State<addContactPage> {
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
          title: Text(getTranslated(context, 'Ajouter un contact')),
        ),
        body: Column(
          children: <Widget>[
            Divider(),
            Text(getTranslated(context, 'Contact :'),
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
                    labelText: getTranslated(context, 'Numéro de téléphone')),
                keyboardType: TextInputType.phone,
                onChanged: (value) => phone = value,
              ),
            ),
            Divider(),
            DefaultButton2(
              text: (getTranslated(context, 'Ajouter')),
              press: () {
                if (name != null && phone != null) {
                  Contact c = new Contact(
                      name, phone, Home.currentUser.id, "friend"); //change me
                  its.addNewContact(c);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyContactsPage(),
                    ),
                  );
                  Fluttertoast.showToast(
                      msg: "Contact ajouté",
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
