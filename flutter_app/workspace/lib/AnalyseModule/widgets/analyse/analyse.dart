import 'package:flutter/material.dart';
import 'package:workspace/AnalyseModule/components/size_config.dart';
import 'package:workspace/AnalyseModule/components/delayed_animation.dart';
import 'package:workspace/AnalyseModule/widgets/resultat/resultat.dart';
import 'package:workspace/AnalyseModule/widgets/analyse/components/circular_progress_button.dart';

class Analyse extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Analyse des données"),
        automaticallyImplyLeading: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return OrientationBuilder(
            //return OrientationBuilder
            builder: (context, orientation) {
              SizeConfig().init(constraints, orientation);
              //initialize SizerUtil()
              //initialize SizerUtil
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: MyHomePage(),
              );
            },
          );
        },
      ),
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
    //SizeConfig().init(context);
    final size = 220.0;
    int percentage;
    bool show = false;

    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          Expanded(
            flex: 2,
            child: Center(
              // This Tween Animation Builder is Just For Demonstration, Do not use this AS-IS in Projects
              // Create and Animation Controller and Control the animation that way.
              child: AnalyseAnimation(percentage, show, size),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0 * SizeConfig.widthMultiplier),
          ),
          Expanded(
            flex: 2,
            child: FittedBox(
              child: TextAnimation(),
            ),
          ),
          SizedBox(
            height: 10 * SizeConfig.heightMultiplier,
          ),
          Expanded(
            flex: 1,
            child: Column(children: <Widget>[
              DelayedAnimation(
                child: CircularProgressButton(
                    width: 70.0 * SizeConfig.widthMultiplier,
                    color: new Color(0xFF00A19A),
                    text: "Afficher la resultat",
                    textStyle: TextStyle(
                        fontSize: 4 * SizeConfig.textMultiplier,
                        color: Colors.white),
                    onAnimationComplete: _onAnimationComplete),
                delay: 6000,
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Column TextAnimation() {
    return Column(
      children: [
        DelayedAnimation(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Analyse des températures',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 3 * SizeConfig.textMultiplier, fontFamily: "Muli"),
            ),
          ),
          delay: 2,
        ),
        Padding(
          padding: EdgeInsets.all(6.0 * SizeConfig.widthMultiplier),
        ),
        DelayedAnimation(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Analyse de Gonflement',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 3 * SizeConfig.textMultiplier, fontFamily: "Muli"),
            ),
          ),
          delay: 2000,
        ),
        Padding(
          padding: EdgeInsets.all(6.0 * SizeConfig.widthMultiplier),
        ),
        DelayedAnimation(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Analyse de rougeur',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 3 * SizeConfig.textMultiplier, fontFamily: "Muli"),
            ),
          ),
          delay: 4000,
        ),
      ],
    );
  }

  TweenAnimationBuilder<double> AnalyseAnimation(
      int percentage, bool show, double size) {
    return TweenAnimationBuilder(
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
                  constraints: BoxConstraints(
                      minHeight: 6.5 * SizeConfig.heightMultiplier,
                      maxHeight: 7.9 * SizeConfig.heightMultiplier),
                  width: size - 40,
                  height: size - 40,
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Center(
                      child: Text(
                    "$percentage" + "%",
                    style: TextStyle(fontSize: 4.5 * SizeConfig.textMultiplier),
                  )),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
