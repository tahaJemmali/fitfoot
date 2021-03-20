import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:workspace/AnalyseModule/components/delayed_animation.dart';
import 'package:workspace/AnalyseModule/components/size_config.dart';
import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/AnalyseModule/widgets/resultat/components/radial_progress.dart';
import 'package:sms/sms.dart';
import 'package:flushbar/flushbar.dart';
import 'package:workspace/AnalyseModule/widgets/resultat/components/custom_checkbox.dart';

class Resultat extends StatefulWidget {
  @override
  _ResultatState createState() => _ResultatState();
}

class _ResultatState extends State<Resultat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(builder: (context, constraints) {
          return OrientationBuilder(builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return Column(
              children: <Widget>[
                SizedBox(
                  height: 7 * SizeConfig.heightMultiplier,
                ),
                AnimationDroite(),
                SizedBox(
                  height: 3 * SizeConfig.heightMultiplier,
                ),
                MessageDroite(),
                SizedBox(
                  height: 3 * SizeConfig.heightMultiplier,
                ),
                AnimationGauche(),
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
                              onPressed: () => openAlertBox(context),
                              color: new Color(0xFF00A19A),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              child: Text(
                                'Notifier le medecin'.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 2.7 * SizeConfig.textMultiplier,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 2 * SizeConfig.widthMultiplier,
                            ),
                            RaisedButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => Home(),
                                ),
                              ),
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
                                      fontSize: 2.7 * SizeConfig.textMultiplier,
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

  Expanded AnimationGauche() {
    return Expanded(
      flex: 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RadialProgress(
            goalCompleted: calcul_etat_Gauche(),
            msg: "Pied Gauche",
            amelioration: 6,
            fontt: 4 * SizeConfig.textMultiplier,
            hei: SizeConfig.heightMultiplier,
            wei: SizeConfig.widthMultiplier,
          ),
        ],
      ),
    );
  }

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

  Expanded AnimationDroite() {
    return Expanded(
      flex: 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RadialProgress(
            goalCompleted: calcul_etat_Droite(),
            msg: "Pied Droite",
            amelioration: -22,
            fontt: 4 * SizeConfig.textMultiplier,
            hei: SizeConfig.heightMultiplier,
            wei: SizeConfig.widthMultiplier,
          ),
        ],
      ),
    );
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
            message: "SMS et Email non envoyées",
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
            message: "SMS non envoyée",
            duration: Duration(seconds: 2),
          )..show(c);
        }
      }
    });
  }
}

openAlertBox(BuildContext c) {
  bool a = true, b = true;
  return showDialog(
      context: c,
      builder: (context) {
        return StatefulBuilder(
          // StatefulBuilder
          builder: (x, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              contentPadding: EdgeInsets.only(top: 10.0),
              content: Container(
                width: 300.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Methode de notification",
                          style: TextStyle(fontSize: 24.0),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 4.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: CustomCheckBox(Icons.ac_unit, "test",
                          onSelect: (bool value) {}),
                    ),
                    new GestureDetector(
                      onTap: () => {
                        if (!a && !b)
                          {print("do-nothing")}
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
                          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                          decoration: BoxDecoration(
                            color: new Color(0xFF00A19A),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(32.0),
                                bottomRight: Radius.circular(32.0)),
                          ),
                          child: Text(
                            "Confirmer",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
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
