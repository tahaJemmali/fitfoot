import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:typed_data';
import 'dart:convert';

import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/deviceModule/Activites/piedSuivanteActivity.dart';
import 'package:workspace/deviceModule/classes/cote.dart';
import 'package:workspace/deviceModule/classes/pied.dart';
import 'package:workspace/deviceModule/widgets/Dialog.dart';

import '../../Login/utils/constants.dart';

class AnalyseDesPieds extends StatefulWidget {
  @override
  _AnalyseDesPiedsState createState() => _AnalyseDesPiedsState();
}

class _AnalyseDesPiedsState extends State<AnalyseDesPieds> {
  BluetoothConnection connection;

  bool connectionStatus = false;

  int _selectedLeg = -1;
  String result = "";

  @override
  void initState() {
    super.initState();
    // connect().then((value) => print("fahd"));
  }

  Future<void> connect() async {
    print("########################################" + Home.device.address);
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
    connection.close();
    setState(() {
      this.connectionStatus = false;
    });
  }

  @override
  void dispose() {
    this.connectionStatus = false;
    if (connection != null) {
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(getTranslated(context, "vulez")),
                content: Text(getTranslated(context, "toutledon")),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text(getTranslated(context, "wi")),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Home()));
                    },
                  ),
                  new FlatButton(
                    child: new Text(getTranslated(context, "nn")),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              getTranslated(context, "prepA") + Home.device.name,
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
                    getTranslated(context, "piedNext"),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontFamily: 'Montserrat'),
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
                              getTranslated(context, "piedg"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Montserrat',
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
                              getTranslated(context, "piedd"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
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
                      onPressed: () async {
                        if (_selectedLeg != -1) {
                          Dialogs.showLoadingDialog(context, _keyLoader);
                          if (!connectionStatus) {
                            connect().then((value) => recieveData());
                          } else {
                            recieveData();
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title:
                                    Text(getTranslated(context, "selectPied")),
                                content: Text(
                                    getTranslated(context, "selectPiedDesc")),
                                actions: <Widget>[
                                  new FlatButton(
                                    child:
                                        new Text(getTranslated(context, "Ok")),
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
                      child: Text(getTranslated(context, "startAnaly"),
                          style: TextStyle(color: Colors.white)),
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void recieveData() {
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
      pied.dimention = double.parse(result.substring(0, separator));
      print(result.substring(separator + 1, result.length));
      pied.temperature =
          double.parse(result.substring(separator + 1, result.length));
      pied.cote = _selectedLeg == 1 ? Cote.droit : Cote.gauche;
      print("waaaaaaaaa" + pied.cote.toString());
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => PiedSuivantActivity(pied)));
    });
  }
}
