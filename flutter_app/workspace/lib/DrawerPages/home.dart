import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workspace/DrawerPages/profil.dart';
import 'package:workspace/DrawerPages/settings.dart';
import 'package:workspace/Login/sign_in.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          elevation:
              defaultTargetPlatform == TargetPlatform.android ? 3.0 : 0.0,
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("Fahd Larayedh"),
                accountEmail: Text("fahd.larayedh@gmail.com"),
                currentAccountPicture: CircleAvatar(
                  child: Container(
                    //margin: EdgeInsets.all(20),
                    //width: 200,
                    //height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('assets/default_user.jpg'),
                          //NetworkImage('https://googleflutter.com/sample_image.jpg'),
                          fit: BoxFit.fill),
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text("Profil"),
                leading: Icon(Icons.supervised_user_circle),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profil(),
                    ),
                  );
                },
              ),
              Divider(),
              ListTile(
                title: Text("Réglages"),
                leading: Icon(Icons.settings),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Settings(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text("Se déconnecter"),
                leading: Icon(Icons.logout),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignIn(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: Text("home screen"),
        ));
  }
}
