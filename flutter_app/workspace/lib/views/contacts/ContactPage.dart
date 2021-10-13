//import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:flutter_phone_state/flutter_phone_state.dart';
import 'package:workspace/services/contactservice.dart';
import 'package:workspace/Models/contactlist.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workspace/views/contacts/createcontact.dart';
import 'NewContactForm.dart';

ContactService cs = new ContactService();
//Future<List<ContactList>> contactlist = cs.getAllContacts();

class ContactPage extends StatefulWidget {
  @override
  ContactPageState createState() {
    return new ContactPageState();
  }
}

class ContactPageState extends State<ContactPage> {
  /*const ContactPage({
    Key key,
  }) : super(key: key);
*/
  List<ContactList> list = [];
  @override
  void initState() {
    runMyFuture();
    super.initState();
  }

  void runMyFuture() {
    cs.getAllContacts("1").then((value) {
      //change me
      setState(() {
        list.addAll(value);
      });
      print(list.length);
    });
  }

  void clearMyFuture() {
    cs.getAllContacts("1").then((value) {
      //change me
      setState(() {
        list.clear();
        list.addAll(value);
      });
      print(list.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Mes contacts'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.local_pharmacy),
              tooltip: 'médcin',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => addDoctorPage()),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: _buildListView()),
            NewContactForm(),
          ],
        ));
  }

  Widget _buildListView() {
    //runMyFuture();
    //return WatchBoxBuilder(
    //box: Hive.box('contacts'),
    //builder: (context, contactsBox) {
    return ListView.builder(
      itemCount: list.length, //contactsBox.length,
      itemBuilder: (context, index) {
        ContactList xs = list[index];
        return ListTile(
          title: Text(xs.firstName.toString()),
          subtitle: Text(xs.phone.toString()),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  //contactsBox.deleteAt(index);
                  cs.deleteContact(xs.id);
                  clearMyFuture();
                  Fluttertoast.showToast(
                      msg: "Contact deleted !",
                      backgroundColor: Colors.teal,
                      fontSize: 30
                      // gravity: ToastGravity.TOP,
                      // textColor: Colors.pink
                      );
                },
              ),
              IconButton(
                icon: Icon(Icons.call),
                onPressed: () {
                  // FlutterPhoneState.startPhoneCall(xs.phone.toString());
                },
              )
            ],
          ),
        );
      },
    );
    //},
    //);
  }
}
