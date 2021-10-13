/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workspace/constants/default_button.dart';
import 'package:workspace/views/activities/steps.dart';
import 'package:workspace/views/contacts/myContacts.dart';
import 'package:workspace/views/suggestions/suggestions.dart';
//;
import 'contacts/ContactPage.dart';
import 'activities/addexpenditure.dart';
import 'meds/addroutine.dart';
import 'appointments/createappointment.dart';
import 'appointments/myappointments.dart';
import 'appointments/mydoctors.dart';
import 'meds/dailyIntake.dart';
import 'activities/dailyexpenditures.dart';

class TempoPage extends StatefulWidget {
  @override
  TempoPageState createState() {
    return new TempoPageState();
  }
}

class TempoPageState extends State<TempoPage> {
  /*const ContactPage({
    Key key,
  }) : super(key: key);
*/
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Menu")),
      body: Center(child: Text('')),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
            ),
            ListTile(
              title: Text('Contacts'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyContactsPage()),
                );
              },
            ),
            ListTile(
              title: Text('Mes Rendez-vous'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => appointmentPage()),
                );
              },
            ),
            ListTile(
              title: Text('Routine'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => addRoutinePage()),
                );
              },
            ),
            ListTile(
              title: Text('Prise des médicaments '),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => dailyIntakePage()),
                );
              },
            ),
            ListTile(
              title: Text('Mes activités'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => dailyExpenditurePage()),
                );
              },
            ),
            ListTile(
              title: Text('Suggestions'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SuggestionPage()),
                );
              },
            ),
            ListTile(
              title: Text('Pédomètre'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => stepsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Menu'),
        ),
        body: Column(
          children: <Widget>[
            
            Expanded(child: _buildListView()),
          ],
        ));
  }*/

  Widget _buildListView() {
    return new Scaffold(
        body: new Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
              child: Text('Contacts'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactPage()),
                );
              }),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
              child: Text('Routine'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => addRoutinePage()),
                );
              }),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
              child: Text('Prise des Médicaments '),
              onPressed: () {
                //
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => dailyIntakePage()),
                );
                //
              }),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          new Expanded(
            child: DefaultButton2(
                text: 'Activité',
                press: () {
                  //
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => addExpenditurePage()),
                  );
                  //
                }),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          new Expanded(
            child: DefaultButton2(
                text: 'Mes activités',
                press: () {
                  //
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => dailyExpenditurePage()),
                  );
                  //
                }),
          ),
        ],
      ),
    ]));
  }
}*/
