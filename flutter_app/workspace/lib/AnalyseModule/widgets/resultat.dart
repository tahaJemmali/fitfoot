import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:workspace/AnalyseModule/widgets/delayed_animation.dart';
import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/AnalyseModule/widgets/radial_progress.dart';
import 'package:sms/sms.dart';
import 'package:flushbar/flushbar.dart';

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
      } else if (state == SmsMessageState.Fail) {
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
  } else {
    print("no-notif");
  }
}

openAlertBox(BuildContext c) {
  bool a = true, b = true;
  return showDialog(
      context: c,
      builder: (context) {
        return StatefulBuilder(
          // StatefulBuilder
          builder: (c, setState) {
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
                      child: CheckboxListTile(
                        value: a,
                        title: Text("SMS",
                            style: TextStyle(
                              fontFamily: "Muli",
                            )),
                        secondary: const Icon(Icons.sms),
                        activeColor: new Color(0xFF00A19A),
                        checkColor: Colors.white,
                        onChanged: (value) {
                          setState(() {
                            a = value;
                          });
                        },
                      ),
                    ),
                    Divider(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: CheckboxListTile(
                        value: b,
                        title: Text("Email"),
                        secondary: const Icon(Icons.email),
                        activeColor: new Color(0xFF00A19A),
                        checkColor: Colors.white,
                        onChanged: (value) {
                          setState(() {
                            b = value;
                          });
                        },
                      ),
                    ),
                    new GestureDetector(
                      onTap: () => {
                        sendMail(c, a, b),
                        setState(() {
                          Navigator.of(context).pop();
                        })
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

void _showDialog(BuildContext c) {
  bool a = true, b = true;
  showDialog(
    context: c,
    builder: (context) {
      return StatefulBuilder(
        // StatefulBuilder
        builder: (context, setState) {
          return AlertDialog(
            actions: <Widget>[
              Container(
                  width: 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Méthode de notification",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 2,
                        color: new Color(0xFF00A19A),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CheckboxListTile(
                        value: a,
                        title: Text("SMS",
                            style: TextStyle(
                              fontFamily: "Muli",
                            )),
                        secondary: const Icon(Icons.sms),
                        activeColor: new Color(0xFF00A19A),
                        checkColor: Colors.white,
                        onChanged: (value) {
                          setState(() {
                            a = value;
                          });
                        },
                      ),
                      Divider(
                        height: 10,
                      ),
                      CheckboxListTile(
                        value: b,
                        title: Text("Email"),
                        secondary: const Icon(Icons.email),
                        activeColor: new Color(0xFF00A19A),
                        checkColor: Colors.white,
                        onChanged: (value) {
                          setState(() {
                            b = value;
                          });
                        },
                      ),
                      Divider(
                        height: 10,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Material(
                            elevation: 5.0,
                            color: new Color(0xFF00A19A),
                            child: MaterialButton(
                              padding:
                                  EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                              child: Text("Confirmer",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  )),
                            ),
                          ),
                          Material(
                            elevation: 5.0,
                            color: new Color(0xFF00A19A),
                            child: MaterialButton(
                              padding:
                                  EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                              onPressed: () {
                                setState(() {
                                  Navigator.of(context).pop();
                                });
                              },
                              child: Text("Annuler",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  )),
                            ),
                          ),
                        ],
                      )
                    ],
                  ))
            ],
          );
        },
      );
    },
  );
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

class Resultat extends StatefulWidget {
  @override
  _ResultatState createState() => _ResultatState();
}

class _ResultatState extends State<Resultat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Etat du pied"),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RadialProgress(
                  goalCompleted: calcul_etat_Gauche(),
                  msg: "Pied Gauche",
                  amelioration: 6,
                ),
                RadialProgress(
                  goalCompleted: calcul_etat_Droite(),
                  msg: "Pied Droite",
                  amelioration: -10,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(13.0),
            ),
            DelayedAnimation(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 1,
                  ),
                  Align(
                    child: Text(
                      message_etat(calcul_etat_Gauche()),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Muli",
                          color: color_message(calcul_etat_Gauche())),
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Align(
                    child: Text(
                      message_etat(calcul_etat_Droite()),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Muli",
                          color: color_message(calcul_etat_Droite())),
                    ),
                  ),
                  SizedBox(
                    width: 0.1,
                  )
                ],
              ),
              delay: 1300,
            ),
            Padding(
              padding: const EdgeInsets.all(200.0),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                      color: new Color(0xFF00A19A),
                      child: Text("Notifier le medecin"),
                      onPressed: () => openAlertBox(context)),
                  SizedBox(width: 2),
                  RaisedButton(
                    child: Text("Continuer"),
                    color: new Color(0xFF00A19A),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
