import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:typed_data';
import 'dart:convert';

import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/deviceModule/classes/cote.dart';
import 'package:workspace/deviceModule/classes/pied.dart';
import 'package:workspace/deviceModule/widgets/loading.dart';

class AnalyseDesPieds extends StatefulWidget {
  @override
  _AnalyseDesPiedsState createState() => _AnalyseDesPiedsState();
}

class _AnalyseDesPiedsState extends State<AnalyseDesPieds> {
  static BluetoothConnection connection;

  bool connectionStatus;

  int _selectedLeg = -1;
  String result = "";

  @override
  void initState() {
    super.initState();
    connect();
  }

  void connect() async {
    await BluetoothConnection.toAddress(Home.device.address)
        .then((_connection) {
      print('Connected to the device');
      setState(() {
        connection = _connection;
        connectionStatus = true;
      });
    });
  }

  void disconnect() {
    //print('Disconnected');
    connection.finish();
    setState(() {
      this.connectionStatus = false;
    });
  }

  @override
  void dispose() {
    this.connectionStatus = false;
    connection.dispose();
    connection = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Préparation à l'analyse " + Home.device.name,
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                "Veuiller mettre le braclet sur votre pied et assurez vous de bien l'avoir sérrer",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () => setState(() => _selectedLeg = 0),
                  child: Container(
                    height: 240,
                    width: 150,
                    color: _selectedLeg == 0
                        ? Colors.greenAccent
                        : Colors.transparent,
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Image.asset(
                          'assets/left.png',
                          height: 200,
                          width: 150,
                        ),
                        SizedBox(height: 3),
                        Text(
                          "pied gauche",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              color: _selectedLeg == 0
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 4),
                GestureDetector(
                  onTap: () => setState(() => _selectedLeg = 1),
                  child: Container(
                    height: 240,
                    width: 150,
                    color: _selectedLeg == 1
                        ? Colors.greenAccent
                        : Colors.transparent,
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Image.asset(
                          'assets/right.png',
                          height: 200,
                          width: 150,
                        ),
                        SizedBox(height: 3),
                        Text(
                          "pied droit",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              color: _selectedLeg == 1
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
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
                SizedBox(width: 30),
                RaisedButton(
                  onPressed: () async {
                    if (_selectedLeg != -1) {
                      if (!connectionStatus) {
                        connect();
                      }
                      connection.output.add(utf8.encode("1"));
                      connection.output.allSent;
                      connection.input.listen((Uint8List data) {
                        result += ascii.decode(data);
                        print("///////////////////");
                        print(result);
                        if (result.contains("!")) {
                          disconnect();
                        }
                      }).onDone(() {
                        result = result.substring(0, result.length - 2);
                        Pied pied = new Pied();
                        int separator = result.indexOf(",");
                        pied.dimention =
                            int.parse(result.substring(0, separator));
                        print(result.substring(separator + 1, result.length));
                        pied.temperature = double.parse(
                            result.substring(separator + 1, result.length));
                        pied.cote =
                            _selectedLeg == 1 ? Cote.droit : Cote.gauche;
                        print(pied.toString());
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Loading()));
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Selectionner le pied'),
                            content: Text(
                                "Veuillez selectionner le pied que vous voulez mesurer "),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text("Compris"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text("Démarrer l'analyse"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
