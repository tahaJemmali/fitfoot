import 'package:flutter/material.dart';
import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/deviceModule/Activites/analyseDesPiedsActivity.dart';

class DeviceHomeActivity extends StatefulWidget {
  DeviceHomeActivity();

  @override
  _DeviceHomeActivityState createState() => _DeviceHomeActivityState();
}

class _DeviceHomeActivityState extends State<DeviceHomeActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Jumulage effectué avec  " + Home.device.name,
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      "Niveau battrie de l'appareil",
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      "50%",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                SizedBox(width: 50),
                Icon(
                  Icons.battery_std_rounded,
                  color: Colors.blue,
                  size: 35,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),
              ],
            ),
          ),
          Text(
            "Remarque : Il est mieux de analyser l'état de votre pied le matin aprés votre réveille pour avoir des resultats correcte",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                onPressed: () /*async*/ {
                  dispose();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    ),
                  );
                },
                child: Text("Accueuil"),
              ),
              SizedBox(width: 40),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnalyseDesPieds(),
                    ),
                  );
                },
                child: Text("Analyse des pieds"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
