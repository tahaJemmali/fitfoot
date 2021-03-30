import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:workspace/AnalyseModule/components/delayed_animation.dart';
import 'package:workspace/AnalyseModule/components/size_config.dart';
import 'package:workspace/AnalyseModule/widgets/resultat/components/radial_progress.dart';
import 'package:sms/sms.dart';
import 'package:flushbar/flushbar.dart';
import 'components/multiselect.dart';

class Resultat extends StatefulWidget {
  @override
  _ResultatState createState() => _ResultatState();
}

class _ResultatState extends State<Resultat> {
  @override
  Widget build(BuildContext c) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(builder: (context, constraints) {
          return OrientationBuilder(builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            double h = SizeConfig.heightMultiplier;
            double w = SizeConfig.widthMultiplier;
            double f = SizeConfig.textMultiplier;
            return Column(
              children: <Widget>[
                SizedBox(
                  height: 7 * SizeConfig.heightMultiplier,
                ),
                AnimationDroite(c),
                SizedBox(
                  height: 3 * SizeConfig.heightMultiplier,
                ),
                MessageDroite(),
                SizedBox(
                  height: 3 * SizeConfig.heightMultiplier,
                ),
                AnimationGauche(c),
                SizedBox(
                  height: 3 * SizeConfig.heightMultiplier,
                ),
                MessageGauche(),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
                              onPressed: () => openAlertBox(context, h, w, f),
                              color: new Color(0xFF00A19A),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              child: Text(
                                'Notifier le medecin'.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 2.4 * SizeConfig.textMultiplier,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 2 * SizeConfig.widthMultiplier,
                            ),
                            RaisedButton(
                              onPressed: () =>
                                  {print("add to database and push to home")},
                              color: new Color(0xFF00A19A),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Continuer'.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          });
        }));
  }

  Expanded MessageGauche() {
    return Expanded(
      flex: 2,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        DelayedAnimation(
          child: Row(
            children: [
              Align(
                child: Text(
                  message_etat(calcul_etat_Gauche()),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 5 * SizeConfig.textMultiplier,
                      fontFamily: "Muli",
                      color: color_message(calcul_etat_Gauche())),
                ),
              ),
            ],
          ),
          delay: 1300,
        ),
      ]),
    );
  }

  // ignore: non_constant_identifier_names
  Expanded AnimationGauche(BuildContext context) {
    LinearGradient x;
    if (calcul_etat_Gauche() * 100 < 50) {
      x = LinearGradient(colors: [
        Colors.red,
        Colors.redAccent,
      ]);
    } else if (calcul_etat_Gauche() * 100 >= 50) {
      x = LinearGradient(colors: [
        Colors.green,
        Colors.greenAccent,
      ]);
    }

    return Expanded(
      flex: 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => {detailsPiedGauche(context)},
            splashColor: new Color(0xFF00A19A),
            borderRadius: BorderRadius.circular(360.0),
            child: RadialProgress(
              goalCompleted: calcul_etat_Gauche(),
              msg: "Pied Gauche",
              amelioration: 6,
              fontt: 4 * SizeConfig.textMultiplier,
              hei: SizeConfig.heightMultiplier,
              wei: SizeConfig.widthMultiplier,
              lg: x,
            ),
          ),
        ],
      ),
    );
  }

  Future detailsPiedGauche(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                  height: 230.0,
                  width: 200.0,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            height: 80.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                ),
                                color: Colors.teal),
                          ),
                          Positioned(
                              top: 20.0,
                              left: 50.0,
                              child: Container(
                                child: Center(
                                    child: Text("Details du pied Gauche",
                                        style: TextStyle(color: Colors.white))),
                                height: 50.0,
                                width: 170.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(45.0),
                                  border: Border.all(
                                      color: Colors.white,
                                      style: BorderStyle.solid,
                                      width: 2.0),
                                ),
                              ))
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Temperature:",
                                style: TextStyle(
                                  fontFamily: 'Muli',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "25°",
                                style: TextStyle(
                                  fontFamily: 'Muli',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "Gonflement:",
                                style: TextStyle(
                                  fontFamily: 'Muli',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "59%",
                                style: TextStyle(
                                  fontFamily: 'Muli',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "Rougeur:",
                                style: TextStyle(
                                  fontFamily: 'Muli',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              SizedBox(
                                width: 49,
                              ),
                              Text(
                                "Trés rouge",
                                style: TextStyle(
                                  fontFamily: 'Muli',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Expanded(
                        child: FlatButton(
                            child: Center(
                              child: Text(
                                'Fermer',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14.0,
                                    color: Colors.teal),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: Colors.transparent),
                      )
                    ],
                  )));
        });
  }

  // ignore: non_constant_identifier_names
  Expanded MessageDroite() {
    return Expanded(
      flex: 2,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        DelayedAnimation(
          child: Row(
            children: [
              Align(
                child: Text(
                  message_etat(calcul_etat_Droite()),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 5 * SizeConfig.textMultiplier,
                      fontFamily: "Muli",
                      color: color_message(calcul_etat_Droite())),
                ),
              ),
            ],
          ),
          delay: 1300,
        ),
      ]),
    );
  }

  // ignore: non_constant_identifier_names
  Expanded AnimationDroite(BuildContext context) {
    LinearGradient x;
    if (calcul_etat_Droite() * 100 < 50) {
      x = LinearGradient(colors: [
        Colors.red,
        Colors.redAccent,
      ]);
    } else if (calcul_etat_Droite() * 100 >= 50) {
      x = LinearGradient(colors: [
        Colors.green,
        Colors.greenAccent,
      ]);
    }
    return Expanded(
      flex: 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => {detailsPiedDroite(context)},
            splashColor: new Color(0xFF00A19A),
            borderRadius: BorderRadius.circular(360.0),
            child: RadialProgress(
              goalCompleted: calcul_etat_Droite(),
              msg: "Pied Droite",
              amelioration: -22,
              lg: x,
              fontt: 4 * SizeConfig.textMultiplier,
              hei: SizeConfig.heightMultiplier,
              wei: SizeConfig.widthMultiplier,
            ),
          ),
        ],
      ),
    );
  }

  Future detailsPiedDroite(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                  height: 230,
                  width: 100,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            height: 70.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                ),
                                color: Colors.teal),
                          ),
                          Positioned(
                              top: 12.0,
                              left: 50.0,
                              child: Container(
                                child: Center(
                                    child: Text("Details du pied Droite",
                                        style: TextStyle(color: Colors.white))),
                                height: 50.0,
                                width: 160.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(45.0),
                                  border: Border.all(
                                      color: Colors.white,
                                      style: BorderStyle.solid,
                                      width: 2.0),
                                ),
                              ))
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Temperature:",
                                style: TextStyle(
                                  fontFamily: 'Muli',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "25°",
                                style: TextStyle(
                                  fontFamily: 'Muli',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "Gonflement:",
                                style: TextStyle(
                                  fontFamily: 'Muli',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "59%",
                                style: TextStyle(
                                  fontFamily: 'Muli',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "Rougeur:",
                                style: TextStyle(
                                  fontFamily: 'Muli',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              SizedBox(
                                width: 49,
                              ),
                              Text(
                                "Trés rouge",
                                style: TextStyle(
                                  fontFamily: 'Muli',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Expanded(
                        child: FlatButton(
                            child: Center(
                              child: Text(
                                'Fermer',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14.0,
                                    color: Colors.teal),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: Colors.transparent),
                      )
                    ],
                  )));
        });
  }
}

SmsMessage sms() {
  SmsSender sender = new SmsSender();
  String address = "+21651775991";
  SmsMessage message = new SmsMessage(address, 'Fitfoot Patient Details');
  sender.sendSms(message);
  return message;
}

sendMail(BuildContext c, bool a, bool b) async {
  bool sent = false;
  SmsMessage m;
  if (a && !b) {
    print("sms");
    m = sms();
    m.onStateChanged.listen((state) {
      if (state == SmsMessageState.Delivered) {
        Flushbar(
          margin: EdgeInsets.all(8 * SizeConfig.widthMultiplier),
          borderRadius: 8,
          boxShadows: [
            BoxShadow(
              color: Colors.blue[800],
              offset: Offset(0.0, 2.0),
              blurRadius: 3.0,
            )
          ],
          backgroundGradient:
              LinearGradient(colors: [new Color(0xFF00A19A), Colors.teal]),
          title: "Notification Envoyée",
          message: "Votre medecin est notifié",
          duration: Duration(seconds: 2),
        )..show(c);
      } else if (state == SmsMessageState.Fail) {
        Flushbar(
          margin: EdgeInsets.all(8 * SizeConfig.widthMultiplier),
          borderRadius: 8,
          boxShadows: [
            BoxShadow(
              color: Colors.blue[800],
              offset: Offset(0.0, 2.0),
              blurRadius: 3.0,
            )
          ],
          backgroundGradient:
              LinearGradient(colors: [new Color(0xFF00A19A), Colors.teal]),
          title: "Echec notification",
          message: "SMS non envoyée",
          duration: Duration(seconds: 2),
        )..show(c);
      }
    });
  } else if (b && !a) {
    print("email");
    String username = 'fitfoot.service@gmail.com';
    String password = 'fitfoot123';

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'FitFoot')
      ..recipients.add('firas.selmen@esprit.tn')
      ..subject = 'FitFoot Notification ${DateTime.now()}'
      ..html =
          "<h1>Patient : Flen Ben Foulen</h1>\n<p>Hey! Here's some patient details</p>";

    try {
      final sendReport = await send(message, smtpServer);
      sent = true;
    } on MailerException catch (e) {
      //print('Message not sent.');
      for (var p in e.problems) {
        //print('Problem: ${p.code}: ${p.msg}');
      }
    }
    if (sent) {
      Flushbar(
        margin: EdgeInsets.all(8 * SizeConfig.widthMultiplier),
        borderRadius: 8,
        boxShadows: [
          BoxShadow(
            color: Colors.blue[800],
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
        backgroundGradient:
            LinearGradient(colors: [new Color(0xFF00A19A), Colors.teal]),
        title: "Notification Envoyée",
        message: "Votre medecin est notifié",
        duration: Duration(seconds: 2),
      )..show(c);
    } else {
      Flushbar(
        margin: EdgeInsets.all(8),
        borderRadius: 8,
        boxShadows: [
          BoxShadow(
            color: Colors.blue[800],
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
        backgroundGradient:
            LinearGradient(colors: [new Color(0xFF00A19A), Colors.teal]),
        title: "Echec notification",
        message: "Email non envoyée",
        duration: Duration(seconds: 2),
      )..show(c);
    }
  } else if (a && b) {
    print("sms+mail");
    String username = 'fitfoot.service@gmail.com';
    String password = 'fitfoot123';

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'FitFoot')
      ..recipients.add('firas.selmen@esprit.tn')
      ..subject = 'FitFoot Notification ${DateTime.now()}'
      ..html =
          "<h1>Patient : Flen Ben Foulen</h1>\n<p>Hey! Here's some patient details</p>";

    try {
      final sendReport = await send(message, smtpServer);
      sent = true;
    } on MailerException catch (e) {
      //print('Message not sent.');
      for (var p in e.problems) {
        //print('Problem: ${p.code}: ${p.msg}');
      }
    }
    m = sms();
    m.onStateChanged.listen((state) {
      if (state == SmsMessageState.Delivered) {
        if (sent) {
          Flushbar(
            margin: EdgeInsets.all(8),
            borderRadius: 8,
            boxShadows: [
              BoxShadow(
                color: Colors.blue[800],
                offset: Offset(0.0, 2.0),
                blurRadius: 3.0,
              )
            ],
            backgroundGradient:
                LinearGradient(colors: [new Color(0xFF00A19A), Colors.teal]),
            title: "Notification Envoyée",
            message: "Votre medecin est notifié",
            duration: Duration(seconds: 2),
          )..show(c);
        } else {
          Flushbar(
            margin: EdgeInsets.all(8),
            borderRadius: 8,
            boxShadows: [
              BoxShadow(
                color: Colors.blue[800],
                offset: Offset(0.0, 2.0),
                blurRadius: 3.0,
              )
            ],
            backgroundGradient:
                LinearGradient(colors: [new Color(0xFF00A19A), Colors.teal]),
            title: "Echec notification",
            message: "Email non envoyée",
            duration: Duration(seconds: 2),
          )..show(c);
        }
      } else if (state == SmsMessageState.Fail) {
        if (!sent) {
          FlushEchec(c);
        } else {
          Flushbar(
            margin: EdgeInsets.all(8),
            borderRadius: 8,
            boxShadows: [
              BoxShadow(
                color: Colors.blue[800],
                offset: Offset(0.0, 2.0),
                blurRadius: 3.0,
              )
            ],
            backgroundGradient:
                LinearGradient(colors: [new Color(0xFF00A19A), Colors.teal]),
            title: "Echec notification",
            message: "SMS non envoyée",
            duration: Duration(seconds: 2),
          )..show(c);
        }
      }
    });
  }
}

Flushbar FlushEchec(BuildContext c) {
  return Flushbar(
    margin: EdgeInsets.all(8),
    borderRadius: 8,
    boxShadows: [
      BoxShadow(
        color: Colors.blue[800],
        offset: Offset(0.0, 2.0),
        blurRadius: 3.0,
      )
    ],
    backgroundGradient:
        LinearGradient(colors: [new Color(0xFF00A19A), Colors.teal]),
    title: "Echec notification",
    message: "SMS et Email non envoyées",
    duration: Duration(seconds: 2),
  )..show(c);
}

openAlertBox(BuildContext c, double hei, double wei, double font) {
  bool a = false, b = false, showtool = false;

  return showDialog(
      context: c,
      builder: (context) {
        return StatefulBuilder(
          // StatefulBuilder

          builder: (x, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              content: Container(
                height: 28.9 * hei,
                width: 100 * wei,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Methode de Notification",
                            style: TextStyle(fontSize: 3.1 * font),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 1 * hei,
                    ),
                    SizedBox(
                      height: 3 * hei,
                    ),
                    Expanded(
                      child: Center(
                        child: MultiSelectChip(
                          reportList,
                          font,
                          hei,
                          wei,
                          onSelectionChanged: (selectedList) {
                            setState(() {
                              if (selectedList.length > 1) {
                                a = true;
                                b = true;
                              } else if (selectedList.length == 0) {
                                a = false;
                                b = false;
                              } else if (selectedList[0] == "SMS") {
                                a = true;
                                b = false;
                              } else {
                                a = false;
                                b = true;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6 * hei,
                    ),
                    new GestureDetector(
                      onTap: () => {
                        if (!a && !b)
                          {
                            new SuperTooltip(
                              popupDirection: TooltipDirection.down,
                              content: new Material(
                                  child: Text(
                                "Choisir au moins une methode",
                                softWrap: true,
                              )),
                            ).show(x),
                          }
                        else
                          {
                            sendMail(c, a, b),
                            setState(() {
                              Navigator.of(context).pop();
                            })
                          }
                      },
                      child: InkWell(
                        child: Container(
                          width: 200 * wei,
                          height: 9 * hei,
                          padding: EdgeInsets.only(
                              top: 2.0 * hei, bottom: 2.0 * hei),
                          decoration: BoxDecoration(
                            color: new Color(0xFF00A19A),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(32.0),
                                bottomRight: Radius.circular(32.0)),
                          ),
                          child: Expanded(
                            flex: 2,
                            child: Text(
                              "Confirmer",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 3.2 * font),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      });
}

// ignore: non_constant_identifier_names
double calcul_etat_Gauche() {
  return 0.91;
}

// ignore: non_constant_identifier_names
double calcul_etat_Droite() {
  return 0.15;
}

String message_etat(double etat) {
  double t = etat * 100;
  if (t < 26)
    return "Criticité Trés grave";
  else if (t > 25 && t < 51)
    return "Criticité Grave";
  else if (t > 50 && t < 76)
    return "Criticité Moyenne";
  else if (t > 75) return "Criticité Faible";
}

void showtooltip(BuildContext x) {}

Color color_message(double etat) {
  double t = etat * 100;
  if (t < 26)
    return new Color(0xFFB71C1C);
  else if (t > 25 && t < 51)
    return new Color(0xFFFFC107);
  else if (t > 50 && t < 76)
    return new Color(0xFF000000);
  else if (t > 75) return new Color(0xFF000000);
}

List<String> reportList = [
  "SMS",
  "EMAIL",
];
