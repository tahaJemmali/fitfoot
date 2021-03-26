import 'package:flutter/material.dart';
import 'package:workspace/AnalyseModule/widgets/circular_progress_button.dart';
import 'package:workspace/AnalyseModule/widgets/delayed_animation.dart';
import 'package:workspace/AnalyseModule/widgets/resultat.dart';

class Loading extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Analyse des données"),
      ),
      body: MyHomePage(),
    );
  }
}

const TWO_PI = 3.14 * 2;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Null> _onAnimationComplete() async {
    await Future.delayed(Duration(seconds: 2));

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Resultat()));

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = 200.0;
    int percentage;
    bool show = false;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Center(
                // This Tween Animation Builder is Just For Demonstration, Do not use this AS-IS in Projects
                // Create and Animation Controller and Control the animation that way.
                child: TweenAnimationBuilder(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(seconds: 6),
                  builder: (context, value, child) {
                    percentage = (value * 100).ceil();
                    if (percentage > 0) show = true;
                    return Container(
                      width: size,
                      height: size,
                      child: Stack(
                        children: [
                          ShaderMask(
                            shaderCallback: (rect) {
                              return SweepGradient(
                                  startAngle: 0.0,
                                  endAngle: TWO_PI,
                                  stops: [value, value],
                                  // 0.0 , 0.5 , 0.5 , 1.0
                                  center: Alignment.center,
                                  colors: [
                                    new Color(0xFF00A19A),
                                    Colors.grey.withAlpha(55)
                                  ]).createShader(rect);
                            },
                            child: Container(
                              width: size,
                              height: size,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: Image.asset(
                                              "lib/AnalyseModule/assets/radial_scale.png")
                                          .image)),
                            ),
                          ),
                          Center(
                            child: Container(
                              width: size - 40,
                              height: size - 40,
                              decoration: BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              child: Center(
                                  child: Text(
                                "$percentage",
                                style: TextStyle(fontSize: 40),
                              )),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
            ),
            Row(
              children: [
                DelayedAnimation(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '  - Analyse de la température',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 23),
                    ),
                  ),
                  delay: 2,
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                ),
                DelayedAnimation(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '  - Analyse du gonflement',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 23),
                    ),
                  ),
                  delay: 2000,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
            ),
            DelayedAnimation(
              child: CircularProgressButton(
                  text: "Afficher la resultat",
                  textStyle: TextStyle(color: Colors.white),
                  onAnimationComplete: _onAnimationComplete),
              delay: 6000,
            )
          ],
        ),
      ),
    );
  }
}
