import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class DeviceHomeActivity extends StatefulWidget {
  DeviceHomeActivity(this.device);
  final BluetoothDevice device;
  @override
  _DeviceHomeActivityState createState() => _DeviceHomeActivityState();
}

class _DeviceHomeActivityState extends State<DeviceHomeActivity> {
  BluetoothConnection connection;
  bool isConnecting = true;
  bool isDisconnecting = true;

  connect(String address) async {
    if (isConnecting) {
      BluetoothConnection.toAddress(widget.device.address).then((_connection) {
        print('Connected to the device');
        connection = _connection;
        connection.input.listen((Uint8List data) {
          print(ascii.decode(data));
        });
        setState(() {
          isConnecting = false;
          isDisconnecting = false;
        });
      });
      print('Connected to the device');
    } else {
      print('already connected to the device');
    }
  }

  @override
  Widget build(BuildContext context) {
    connect(widget.device.address);
    return Scaffold(
      appBar: AppBar(
        title: Text("Connected to " + widget.device.name),
      ),
      body: FlatButton(
        onPressed: () /*async*/ {
          connection.output.add(utf8.encode("1" + "\r\n"));
          /* await*/ connection.output.allSent;
        },
        child: Text("hello"),
      ),
    );
  }
}
