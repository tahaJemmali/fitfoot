import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/Login/utils/constants.dart';
import 'package:workspace/constants/default_button.dart';
import 'package:workspace/Models/Med.dart';
import 'package:workspace/Models/activitylist.dart';
import 'package:workspace/services/medservice.dart';

MedService its = new MedService();

class addmedPage extends StatefulWidget {
  @override
  addmedPageState createState() {
    return new addmedPageState();
  }
}

class addmedPageState extends State<addmedPage> {
  List<ActivityList> list = [];
  String name;
  String type;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(getTranslated(context, "Ajouter un médicament")),
        ),
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: ListView(
            children: <Widget>[
              Divider(),
              SizedBox(
                height: 150,
                width: MediaQuery.of(context).size.width - 30,
                child: Icon(Icons.local_pharmacy,
                    size: MediaQuery.of(context).size.width / 3,
                    color: Colors.teal),
              ),
              Text(getTranslated(context, "Médicament :"),
                  style: TextStyle(fontSize: 25)),
              SizedBox(
                height: 56,
                width: MediaQuery.of(context).size.width - 30,
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: getTranslated(context, "Nom du médicament")),
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
                      labelText: getTranslated(context, "Type")),
                  keyboardType: TextInputType.text,
                  onChanged: (value) => type = value,
                ),
              ),
              Divider(),
              DefaultButton2(
                text: (getTranslated(context, "Ajouter")),
                press: () {
                  if (name != null && type != null) {
                    Med med = new Med(name, type, 1);
                    its.customMed(med, Home.currentUser.id); // User ID Tempo
                    Fluttertoast.showToast(
                        msg: "Médicament ajouté",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black45,
                        textColor: Colors.white,
                        fontSize: 14.0);
                    Navigator.pop(context);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Remplissez les champs ",
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
          ),
        ));
  }
}
