import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class DeviceHomeActivity extends StatefulWidget {
  DeviceHomeActivity(this.device);
  final BluetoothDevice device;
  @override
  _DeviceHomeActivityState createState() => _DeviceHomeActivityState();
}

class _DeviceHomeActivityState extends State<DeviceHomeActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connected to " + widget.device.name),
      ),
    );
  }
}
