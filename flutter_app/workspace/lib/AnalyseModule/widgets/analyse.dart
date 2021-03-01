import 'package:flutter/material.dart';

class Analyse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Analyse des données"),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text("Add"),
                    onPressed: null,
                  ),
                  SizedBox(width: 2),
                  RaisedButton(
                    child: Text("Cancel"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
