import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:workspace/DrawerPages/profil.dart';
import 'package:workspace/DrawerPages/settings.dart';
import 'package:workspace/Login/sign_in.dart';
import 'package:workspace/AnalyseModule/assets/my_flutter_app_icons.dart';
import 'package:workspace/AnalyseModule/widgets/statistics.dart';
import 'package:workspace/deviceModule/Activites/ListDevices.dart';
import 'package:workspace/deviceModule/Activites/deviceHomeActivity.dart';

class Home extends StatefulWidget {
  static BluetoothDevice device;
  static BluetoothState bluetoothState = BluetoothState.UNKNOWN;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();

    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        Home.bluetoothState = state;
      });
    });

    // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        Home.bluetoothState = state;
      });
    });
  }

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
                accountName: Text("Flen Ben Foulen"),
                accountEmail: Text("flen.foulen@example.com"),
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
                title: Text("Analyse"),
                leading: Icon(MyFlutterApp.search_outline),
                onTap: () {
                  if (Home.device != null &&
                      Home.bluetoothState == BluetoothState.STATE_ON) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeviceHomeActivity(),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                              'Veuiller vous connecter à un appareil'),
                          content: Text(
                              "Vous devez vous connecter sur un appareil pour faire l'analyse "),
                          actions: <Widget>[
                            new FlatButton(
                              child: new Text("D'accord"),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.of(context)
                                    .pushReplacement(new MaterialPageRoute(
                                  builder: (context) => ListDevices(),
                                ));
                              },
                            ),
                            new FlatButton(
                              child: new Text("Close"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
              Divider(),
              ListTile(
                title: Text("Suivi et Statistiques"),
                leading: Icon(Icons.bar_chart_sharp),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Statistics(),
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
              Divider(),
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
