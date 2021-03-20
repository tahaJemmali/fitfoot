import 'package:flutter/material.dart';
import 'package:workspace/AnalyseModule/widgets/analyse/analyse.dart';

class Mesure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prendre les mesures"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
                color: new Color(0xFF00A19A),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Analyse()));
                },
                child: Text(
                  "Analyser les données",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
          ],
        ),
      ),
    );
  }
}
