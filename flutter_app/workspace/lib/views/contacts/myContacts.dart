import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/Login/utils/constants.dart';
import 'package:workspace/Models/contactlist.dart';
import 'package:workspace/services/contactservice.dart';
import 'package:workspace/views/appointments/createappointment.dart';
import 'package:workspace/views/contacts/addNewContact.dart';
import 'package:workspace/views/contacts/createcontact.dart';

ContactService cs = new ContactService();

class MyContactsPage extends StatefulWidget {
  @override
  MyContactsPageState createState() {
    return new MyContactsPageState();
  }
}

class MyContactsPageState extends State<MyContactsPage> {
  List<ContactList> Contactlist = [];

  @override
  void initState() {
    intitMyFuture();

    super.initState();
  }

  void intialFuture() {
    cs.getAllContacts(Home.currentUser.id).then((value) {
      //change me
      setState(() {
        Contactlist.addAll(value);
      });
    });
  }

  void updateMyFuture() {
    cs.getAllContacts(Home.currentUser.id).then((value) {
      //change me
      setState(() {
        Contactlist.clear();
        Contactlist.addAll(value);
      });
    });
  }

  void intitMyFuture() {
    cs.getAllContacts(Home.currentUser.id).then((value) {
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
          title: Text(getTranslated(context, 'Mes contacts')),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.medical_services),
              tooltip: 'ajouter un médicin',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => addDoctorPage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person_add),
              tooltip: 'ajouter un contact',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => addContactPage()),
                );
              },
            ),
          ],
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

  Icon contactIcon(ContactList xs) {
    var x;
    if (xs.type == "doctor") {
      x = Icon(Icons.medical_services, color: Colors.teal);
    } else if (xs.type == "friend") {
      x = Icon(Icons.person, color: Colors.teal);
    }
    return x;
  }

  String Doctorsuffix(ContactList xs) {
    var x;
    if (xs.type == "doctor") {
      x = "Dr. " + xs.firstName;
    } else if (xs.type == "friend") {
      x = xs.firstName;
    }
    return x;
  }

  String Phoneandspecialty(ContactList xs) {
    var x;
    if (xs.specialty != null) {
      x = xs.phone + " (" + xs.specialty + ")";
    } else {
      x = xs.phone;
    }
    return x;
  }

  _callNumber(String phone) async {
    bool res = await FlutterPhoneDirectCaller.callNumber(phone);
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: Contactlist.length,
      itemBuilder: (context, index) {
        ContactList xs = Contactlist[index];
        return ListTile(
          title: Text(Doctorsuffix(xs)),
          subtitle: Text(Phoneandspecialty(xs)),
          leading: contactIcon(xs),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  cs.deleteContact(xs.id);
                  updateMyFuture();
                },
              ),
              IconButton(
                icon: Icon(Icons.call),
                onPressed: () async {
                  _callNumber(xs.phone);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
