import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'package:workspace/AnalyseModule/classes/Static.dart';

class RadialProgress extends StatefulWidget {
  final double goalCompleted;
  final String msg;
  final double amelioration;

  final LinearGradient lg;
  RadialProgress(
      {@required this.goalCompleted,
      @required this.msg,
      @required this.amelioration,
      @required this.lg});
  @override
  _RadialProgressState createState() => _RadialProgressState();
}

class _RadialProgressState extends State<RadialProgress>
    with SingleTickerProviderStateMixin {
  AnimationController _radialProgressAnimationController;
  Animation<double> _progressAnimation;
  final Duration fadeInDuration = Duration(milliseconds: 500);
  final Duration fillDuration = Duration(seconds: 2);

  double progressDegrees = 0;
  var count = 0;

  @override
  void initState() {
    super.initState();
    _radialProgressAnimationController =
        AnimationController(vsync: this, duration: fillDuration);
    _progressAnimation = Tween(begin: 0.0, end: 360.0).animate(CurvedAnimation(
        parent: _radialProgressAnimationController, curve: Curves.easeIn))
      ..addListener(() {
        setState(() {
          progressDegrees = widget.goalCompleted * _progressAnimation.value;
        });
      });

    _radialProgressAnimationController.forward();
  }

  @override
  void dispose() {
    _radialProgressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Container(
        height: 200,
        width: 200,
        child: AnimatedOpacity(
          opacity: progressDegrees > 30 ? 1.0 : 0.0,
          curve: Curves.bounceInOut,
          duration: fadeInDuration,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Sizee(),
              Text(
                widget.msg,
                style: TextStyle(fontSize: 22, letterSpacing: 0.7),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 5,
                width: 100.0,
                decoration: BoxDecoration(
                    color: new Color(0xFF00A19A),
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                ((widget.goalCompleted * 100).round()).toString() + "%",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment(0, 1.0),
                child: Text(
                  getAmString(),
                  style: TextStyle(
                      color: getColour(widget.amelioration),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
      painter: RadialPainter(progressDegrees, widget.lg),
    );
  }

  // ignore: non_constant_identifier_names
  SizedBox Sizee() {
    if (this.getAmString() == ' ') {
      return SizedBox(
        height: 30,
      );
    }

    return SizedBox(
      height: 15,
    );
  }

  // ignore: missing_return
  String getAmString() {
    double m = widget.amelioration;
    if (m == 500) {
      return ' ';
    } else {
      if (m == 0)
        return double.parse((widget.amelioration * 100).toStringAsFixed(2))
                .toString() +
            "%";
      if (m < 0)
        return double.parse((widget.amelioration * 100).toStringAsFixed(2))
                .toString() +
            "%";
      if (m > 0)
        return "+" +
            double.parse((widget.amelioration * 100).toStringAsFixed(2))
                .toString() +
            "%";
    }
  }

  // ignore: missing_return
  Color getColour(double m) {
    if (m < 0) return Colors.green;
    if (m > 0) return Colors.red;
    if (m == 0) return Colors.black;
  }
}

class RadialPainter extends CustomPainter {
  double progressInDegrees;
  LinearGradient lg;
  RadialPainter(this.progressInDegrees, this.lg);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0;

    Offset center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width / 2, paint);

    Paint progressPaint = Paint()
      ..shader = lg
          .createShader(Rect.fromCircle(center: center, radius: size.width / 2))
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;
    canvas.drawArc(
        Rect.fromCircle(center: center, radius: size.width / 2),
        math.radians(-90),
        math.radians(progressInDegrees),
        false,
        progressPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
