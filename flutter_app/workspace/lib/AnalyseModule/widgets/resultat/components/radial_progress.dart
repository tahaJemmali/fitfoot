import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'package:workspace/AnalyseModule/components/size_config.dart';

class RadialProgress extends StatefulWidget {
  final double goalCompleted;
  final String msg;
  final double amelioration;
  final double fontt;
  final double hei;
  final double wei;
  final LinearGradient lg;
  RadialProgress(
      {@required this.goalCompleted,
      @required this.msg,
      @required this.hei,
      @required this.wei,
      @required this.amelioration,
      @required this.fontt,
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
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return CustomPaint(
          child: Container(
            height: 200.0 * SizeConfig.heightMultiplier,
            width: 140.0 * SizeConfig.widthMultiplier,
            child: AnimatedOpacity(
              opacity: progressDegrees > 30 ? 1.0 : 0.0,
              duration: fadeInDuration,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 1 * widget.hei,
                  ),
                  Text(
                    widget.msg,
                    style: TextStyle(
                        fontSize: widget.fontt - 1, letterSpacing: 0.7),
                  ),
                  SizedBox(
                    height: 2 * widget.hei,
                  ),
                  Container(
                    height: 1 * widget.hei,
                    width: 26.0 * widget.wei,
                    decoration: BoxDecoration(
                        color: new Color(0xFF00A19A),
                        borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  ),
                  SizedBox(
                    height: 2 * widget.hei,
                  ),
                  Text(
                    ((widget.goalCompleted * 100).round()).toString() + "%",
                    style: TextStyle(
                        fontSize: widget.fontt - 2,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 1 * widget.hei,
                  ),
                  Align(
                    alignment: Alignment(-0.1, 1.0),
                    child: Text(
                      getAmString(widget.amelioration),
                      style: TextStyle(
                          color: getColour(widget.amelioration),
                          fontSize: widget.fontt - 7,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          painter: RadialPainter(progressDegrees, widget.lg),
        );
      });
    });
  }

  String getAmString(double m) {
    if (m == 0) return ((widget.amelioration).round()).toString();
    if (m < 0) return ((widget.amelioration).round()).toString();
    if (m > 0) return "+" + ((widget.amelioration).round()).toString();
  }

  Color getColour(double m) {
    if (m > 0) return Colors.green;
    if (m < 0) return Colors.red;
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
      ..strokeWidth = 8.0;

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
