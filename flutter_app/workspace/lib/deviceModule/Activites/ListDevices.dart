import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/Login/utils/constants.dart';
import './BluetoothDeviceListEntry.dart';
import 'deviceHomeActivity.dart';

class DiscoveryPage extends StatefulWidget {
  /// If true, discovery starts on page start, otherwise user must press action button.
  final bool start;

  const DiscoveryPage({this.start = true});

  @override
  _DiscoveryPage createState() => new _DiscoveryPage();
}

class _DiscoveryPage extends State<DiscoveryPage> {
  StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
  List<BluetoothDiscoveryResult> results = List<BluetoothDiscoveryResult>();
  bool isDiscovering;
  BluetoothState bluetoothState;
  _DiscoveryPage();

  @override
  void initState() {
    super.initState();
    setState(() {
      bluetoothState = Home.bluetoothState;
      if (Home.bluetoothState == BluetoothState.STATE_ON) {
        isDiscovering = widget.start;
      } else {
        isDiscovering = false;
      }
    });

    if (isDiscovering) {
      _startDiscovery();
    }
  }

  void _restartDiscovery() {
    setState(() {
      results.clear();
      isDiscovering = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() {
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        if (r.device.isBonded) {
          Home.device = r.device;
          _streamSubscription?.cancel();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeviceHomeActivity(),
            ),
          );
        }
        results.add(r);
      });
    });

    _streamSubscription.onDone(() {
      setState(() {
        isDiscovering = false;
      });
    });
  }

  // @TODO . One day there should be `_pairDevice` on long tap on something... ;)

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Home.bluetoothState == BluetoothState.STATE_ON) {
      return Scaffold(
        appBar: AppBar(
          title: isDiscovering
              ? Text('Discovering devices')
              : Text('Discovered devices'),
          actions: <Widget>[
            isDiscovering
                ? FittedBox(
                    child: Container(
                      margin: new EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  )
                : IconButton(
                    icon: Icon(Icons.replay),
                    onPressed: _restartDiscovery,
                  )
          ],
        ),
        body: ListView.builder(
          itemCount: results.length,
          itemBuilder: (BuildContext context, index) {
            BluetoothDiscoveryResult result = results[index];
            return BluetoothDeviceListEntry(
              device: result.device,
              rssi: result.rssi,
              onTap: () async {
                try {
                  bool bonded = false;
                  if (result.device.isBonded) {
                    print('Unbonding from ${result.device.address}...');
                    await FlutterBluetoothSerial.instance
                        .removeDeviceBondWithAddress(result.device.address);
                    print('Unbonding from ${result.device.address} has succed');
                    Home.device = null;
                  } else {
                    print('Bonding with ${result.device.address}...');
                    bonded = await FlutterBluetoothSerial.instance
                        .bondDeviceAtAddress(result.device.address);
                    print(
                        'Bonding with ${result.device.address} has ${bonded ? 'succed' : 'failed'}.');
                    Home.device = result.device;
                    Home.bluetoothState = bluetoothState;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeviceHomeActivity(),
                      ),
                    );
                  }
                  setState(() {
                    results[results.indexOf(result)] = BluetoothDiscoveryResult(
                        device: BluetoothDevice(
                          name: result.device.name ?? '',
                          address: result.device.address,
                          type: result.device.type,
                          bondState: bonded
                              ? BluetoothBondState.bonded
                              : BluetoothBondState.none,
                        ),
                        rssi: result.rssi);
                  });
                } catch (ex) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error occured while bonding'),
                        content: Text("${ex.toString()}"),
                        actions: <Widget>[
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
            );
          },
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(getTranslated(context, "listApp")),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            Switch(
              value: Home.bluetoothState.isEnabled,
              onChanged: (bool value) async {
                print(value);
                if (value) {
                  // Enable Bluetooth

                  await FlutterBluetoothSerial.instance.requestEnable();
                  setState(() {
                    Home.bluetoothState = BluetoothState.STATE_ON;
                  });
                } else {
                  // Disable Bluetooth
                  await FlutterBluetoothSerial.instance.requestDisable();
                  setState(() {
                    Home.bluetoothState = BluetoothState.STATE_OFF;
                  });
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
                'Bluetooth Adapter is ${bluetoothState != null ? bluetoothState.toString().substring(15) : 'not available'}.',
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
}
