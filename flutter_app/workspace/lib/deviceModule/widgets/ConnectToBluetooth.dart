import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothOffScreen extends StatefulWidget {
  //  bool final _connected = false;
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);

  final BluetoothState state;

  @override
  _BluetoothOffScreenState createState() => _BluetoothOffScreenState();
}

class _BluetoothOffScreenState extends State<BluetoothOffScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste appareils"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Switch(
            value: widget.state.isEnabled,
            onChanged: (bool value) async {
              print(value);
              if (value) {
                // Enable Bluetooth
                await FlutterBluetoothSerial.instance.requestEnable();
              } else {
                // Disable Bluetooth
                await FlutterBluetoothSerial.instance.requestDisable();
              }
            },
          )
        ],
      ),
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${widget.state != null ? widget.state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subhead
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
