import 'package:flutter/material.dart';
import 'package:workspace/deviceModule/Activites/ListDevices.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Réglages"),
      ),
      body: Center(
        child: Column(
          children: [
            RaisedButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListDevices(),
                  ),
                )
              },
              child: Text("Bluetooth"),
            )
          ],
        ),
      ),
    );
  }
}
