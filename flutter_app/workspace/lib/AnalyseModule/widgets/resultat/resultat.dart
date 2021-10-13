import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:workspace/AnalyseModule/classes/Static.dart';
import 'package:workspace/AnalyseModule/components/delayed_animation.dart';

import 'package:workspace/AnalyseModule/widgets/resultat/components/radial_progress.dart';
import 'package:sms/sms.dart';
import 'package:flushbar/flushbar.dart';
import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/Login/utils/constants.dart';
import 'package:workspace/deviceModule/classes/cote.dart';
import 'package:workspace/deviceModule/classes/pied.dart';
import 'components/multiselect.dart';
import 'package:http/http.dart' as http;

class Resultat extends StatefulWidget {
  final Pied pied1;
  final Pied pied2;

  const Resultat(this.pied1, this.pied2);

  @override
  _ResultatState createState() => _ResultatState();
}

class _ResultatState extends State<Resultat> {
  String doctorPhone = Home.currentUser.phoneDoctor;
  String doctorMail = Home.currentUser.emailDoctor;

  String _dp, _dm;
  bool saveInfo = false;
  // ignore: non_constant_identifier_names
  SmsMessage SendSms(String address, Pied p1, Pied p2) {
    SmsSender sender = new SmsSender();

    SmsMessage message = new SmsMessage(
        address,
        Home.currentUser.firstName +
            " " +
            Home.currentUser.lastName +
            " : Pied " +
            cotePied(p1) +
            " : " +
            (p1.etat * 100).toInt().toString() +
            "% , Pied " +
            cotePied(p2) +
            " : " +
            (p2.etat * 100).toInt().toString() +
            "%");
    sender.sendSms(message);
    return message;
  }

  String _validEmailM(value) {
    Home.currentUser.emailDoctor = value;
    if (Home.currentUser.emailDoctor.isEmpty) {
      return kFieldNullError;
    } else if (!emailValidatorRegExp.hasMatch(Home.currentUser.emailDoctor)) {
      return kInvalidEmailError;
    } else {
      return null;
    }
  }

  _showDialoSMS(String mail, Pied p1, Pied p2) {
    String x = "";
    if (Home.currentUser.phoneDoctor != "null") {
      x = Home.currentUser.phoneDoctor;
    }
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(getTranslated(context, "saisim")),
        content: Container(
          width: 420,
          child: Form(
            child: TextFormField(
              autofocus: false,
              initialValue: x,
              maxLength: 20,
              keyboardType: TextInputType.phone,
              //validator: function,
              onChanged: (text) {
                _dp = text;
                Home.currentUser.phoneDoctor = text;
              },
              decoration: InputDecoration(
                counterText: '',
                hintText: '',
                labelText: getTranslated(context, "numem"),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: Icon(Icons.phone, size: 18.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  gapPadding: 15,
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                    gapPadding: 10,
                    borderSide: BorderSide(color: kPrimaryColor, width: 2.0)),
              ),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: kPrimaryColor,
            ),
            child: Text(getTranslated(context, "nout")),
            onPressed: () {
              Navigator.pop(context);
              if (mail == "") {
                SmsMessage m = SendSms(_dp, p1, p2);
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
                      backgroundGradient: LinearGradient(
                          colors: [new Color(0xFF00A19A), Colors.teal]),
                      title: getTranslated(context, "nouten"),
                      message: getTranslated(context, "votrme"),
                      duration: Duration(seconds: 2),
                    )..show(context);
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
                      backgroundGradient: LinearGradient(
                          colors: [new Color(0xFF00A19A), Colors.teal]),
                      title: getTranslated(context, "echecno"),
                      message: getTranslated(context, "smsno"),
                      duration: Duration(seconds: 2),
                    )..show(context);
                  }
                });
              } else {
                bool sent = SendMail(mail, p1, p2);

                SmsMessage m = SendSms(_dp, p1, p2);
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
                        backgroundGradient: LinearGradient(
                            colors: [new Color(0xFF00A19A), Colors.teal]),
                        title: getTranslated(context, "nouten"),
                        message: getTranslated(context, "votrme"),
                        duration: Duration(seconds: 2),
                      )..show(context);
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
                        backgroundGradient: LinearGradient(
                            colors: [new Color(0xFF00A19A), Colors.teal]),
                        title: getTranslated(context, "echecno"),
                        message: getTranslated(context, "emailnoo"),
                        duration: Duration(seconds: 2),
                      )..show(context);
                    }
                  } else if (state == SmsMessageState.Fail) {
                    if (!sent) {
                      FlushEchec(context);
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
                        backgroundGradient: LinearGradient(
                            colors: [new Color(0xFF00A19A), Colors.teal]),
                        title: getTranslated(context, "echecno"),
                        message: getTranslated(context, "smsno"),
                        duration: Duration(seconds: 2),
                      )..show(context);
                    }
                  }
                });
              }
              updateUser();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: kPrimaryColor, // background
            ),
            child: Text(getTranslated(context, "cancel")),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  _showDialoEmail(String phone, Pied p1, Pied p2) {
    String x = "";
    if (Home.currentUser.emailDoctor != "null") {
      x = Home.currentUser.emailDoctor;
    }

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(getTranslated(context, "saisime")),
        content: Container(
          width: 420,
          child: Form(
            child: TextFormField(
              autofocus: false,
              initialValue: x,
              validator: _validEmailM,
              maxLength: 100,
              keyboardType: TextInputType.emailAddress,
              onChanged: (text) {
                _dm = text;
                Home.currentUser.emailDoctor = text;
              },
              decoration: InputDecoration(
                counterText: '',
                hintText: '',
                labelText: getTranslated(context, "adrm"),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: Icon(Icons.email, size: 18.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  gapPadding: 15,
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                    gapPadding: 10,
                    borderSide: BorderSide(color: kPrimaryColor, width: 2.0)),
              ),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: kPrimaryColor,
            ),
            child: Text(getTranslated(context, "nout")),
            onPressed: () {
              Navigator.pop(context);
              if (phone == "") {
                bool sent = SendMail(_dm, p1, p2);
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
                    backgroundGradient: LinearGradient(
                        colors: [new Color(0xFF00A19A), Colors.teal]),
                    title: getTranslated(context, "nouten"),
                    message: getTranslated(context, "votrme"),
                    duration: Duration(seconds: 2),
                  )..show(context);
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
                    backgroundGradient: LinearGradient(
                        colors: [new Color(0xFF00A19A), Colors.teal]),
                    title: getTranslated(context, "echecno"),
                    message: getTranslated(context, "emailnoo"),
                    duration: Duration(seconds: 2),
                  )..show(context);
                }
              } else {
                bool sent = SendMail(_dm, p1, p2);

                SmsMessage m = SendSms(phone, p1, p2);
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
                        backgroundGradient: LinearGradient(
                            colors: [new Color(0xFF00A19A), Colors.teal]),
                        title: getTranslated(context, "nouten"),
                        message: getTranslated(context, "votrme"),
                        duration: Duration(seconds: 2),
                      )..show(context);
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
                        backgroundGradient: LinearGradient(
                            colors: [new Color(0xFF00A19A), Colors.teal]),
                        title: getTranslated(context, "echecno"),
                        message: getTranslated(context, "emailnoo"),
                        duration: Duration(seconds: 2),
                      )..show(context);
                    }
                  } else if (state == SmsMessageState.Fail) {
                    if (!sent) {
                      FlushEchec(context);
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
                        backgroundGradient: LinearGradient(
                            colors: [new Color(0xFF00A19A), Colors.teal]),
                        title: getTranslated(context, "echecno"),
                        message: getTranslated(context, "smsno"),
                        duration: Duration(seconds: 2),
                      )..show(context);
                    }
                  }
                });
              }
              updateUser();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: kPrimaryColor, // background
            ),
            child: Text(getTranslated(context, "cancel")),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  _showDialoBoth(Pied p1, Pied p2) {
    String x = "";
    if (Home.currentUser.phoneDoctor != "null") {
      x = Home.currentUser.phoneDoctor;
    }
    String x1 = "";
    if (Home.currentUser.emailDoctor != "null") {
      x1 = Home.currentUser.emailDoctor;
    }
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(getTranslated(context, "sess")),
        content: Container(
          height: 145,
          width: 420,
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  autofocus: false,
                  initialValue: x,
                  maxLength: 20,
                  keyboardType: TextInputType.phone,
                  onChanged: (text) {
                    _dp = text;
                    Home.currentUser.phoneDoctor = text;
                  },
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '',
                    labelText: getTranslated(context, "numem"),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Icon(Icons.phone, size: 18.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      gapPadding: 15,
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        gapPadding: 10,
                        borderSide:
                            BorderSide(color: kPrimaryColor, width: 2.0)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  autofocus: false,
                  initialValue: x1,
                  maxLength: 100,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (text) {
                    _dm = text;
                    Home.currentUser.emailDoctor = text;
                  },
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '',
                    labelText: getTranslated(context, "adrm"),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Icon(Icons.email, size: 18.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      gapPadding: 15,
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        gapPadding: 10,
                        borderSide:
                            BorderSide(color: kPrimaryColor, width: 2.0)),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: kPrimaryColor,
            ),
            child: Text(getTranslated(context, "nout")),
            onPressed: () {
              Navigator.pop(context);
              bool sent = SendMail(_dm, p1, p2);

              SmsMessage m = SendSms(_dp, p1, p2);
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
                      backgroundGradient: LinearGradient(
                          colors: [new Color(0xFF00A19A), Colors.teal]),
                      title: getTranslated(context, "nouten"),
                      message: getTranslated(context, "votrme"),
                      duration: Duration(seconds: 2),
                    )..show(context);
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
                      backgroundGradient: LinearGradient(
                          colors: [new Color(0xFF00A19A), Colors.teal]),
                      title: getTranslated(context, "echecno"),
                      message: getTranslated(context, "emailnoo"),
                      duration: Duration(seconds: 2),
                    )..show(context);
                  }
                } else if (state == SmsMessageState.Fail) {
                  if (!sent) {
                    FlushEchec(context);
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
                      backgroundGradient: LinearGradient(
                          colors: [new Color(0xFF00A19A), Colors.teal]),
                      title: getTranslated(context, "echecno"),
                      message: getTranslated(context, "smsno"),
                      duration: Duration(seconds: 2),
                    )..show(context);
                  }
                }
              });
              updateUser();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: kPrimaryColor, // background
            ),
            child: Text(getTranslated(context, "cancel")),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  sendNotif(bool a, bool b, Pied p1, Pied p2) async {
    bool sent = false;
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    SmsMessage m;
    if (a && !b) {
      // print("sms");
      if (doctorPhone.length < 8 ||
          doctorPhone.isEmpty ||
          doctorPhone == "null") {
        _showDialoSMS("", p1, p2);
      } else {
        m = SendSms(doctorPhone, p1, p2);
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
              title: getTranslated(context, "nouten"),
              message: getTranslated(context, "votrme"),
              duration: Duration(seconds: 2),
            )..show(context);
            Statis.lastAuto = date;
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
              title: getTranslated(context, "echecno"),
              message: getTranslated(context, "smsno"),
              duration: Duration(seconds: 2),
            )..show(context);
          }
        });
      }
    } else if (b && !a) {
      //print("email");
      if (doctorMail == "null" || doctorMail.length < 5 || doctorMail.isEmpty) {
        _showDialoEmail("", p1, p2);
      } else {
        sent = SendMail(doctorMail, p1, p2);
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
            title: getTranslated(context, "nouten"),
            message: getTranslated(context, "votrme"),
            duration: Duration(seconds: 2),
          )..show(context);
          Statis.lastAuto = date;
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
            title: getTranslated(context, "echecno"),
            message: getTranslated(context, "emailnoo"),
            duration: Duration(seconds: 2),
          )..show(context);
        }
      }
    } else if (a && b) {
      //print("sms+mail");
      if (doctorPhone.length < 8 && doctorMail.length < 5 ||
          (doctorMail.isEmpty ||
              doctorMail == "null" ||
              doctorPhone.isEmpty ||
              doctorPhone == "null")) {
        _showDialoBoth(p1, p2);
      } else if ((doctorPhone.length < 8 ||
              doctorPhone.isEmpty ||
              doctorPhone == "null") &&
          doctorMail.length > 5) {
        _showDialoSMS(doctorMail, p1, p2);
      } else if (doctorPhone.length >= 8 &&
          (doctorMail.length < 5 ||
              doctorMail.isEmpty ||
              doctorMail == "null")) {
        _showDialoEmail(doctorPhone, p1, p2);
      } else {
        sent = SendMail(doctorMail, p1, p2);

        m = SendSms(doctorPhone, p1, p2);
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
                backgroundGradient: LinearGradient(
                    colors: [new Color(0xFF00A19A), Colors.teal]),
                title: getTranslated(context, "nouten"),
                message: getTranslated(context, "votrme"),
                duration: Duration(seconds: 2),
              )..show(context);
              Statis.lastAuto = date;
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
                backgroundGradient: LinearGradient(
                    colors: [new Color(0xFF00A19A), Colors.teal]),
                title: getTranslated(context, "echecno"),
                message: getTranslated(context, "emailnoo"),
                duration: Duration(seconds: 2),
              )..show(context);
            }
          } else if (state == SmsMessageState.Fail) {
            if (!sent) {
              FlushEchec(context);
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
                backgroundGradient: LinearGradient(
                    colors: [new Color(0xFF00A19A), Colors.teal]),
                title: getTranslated(context, "echecno"),
                message: getTranslated(context, "smsno"),
                duration: Duration(seconds: 2),
              )..show(context);
            }
          }
        });
      }
    }
  }

  _openAlertBox({Pied p1, Pied p2}) {
    bool a = false, b = false;

    return showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            content: SingleChildScrollView(
              child: Container(
                width: 500,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      getTranslated(context, "notipar"),
                      style: TextStyle(fontSize: 20),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 5,
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    MediaQuery.of(context).size.width < 400
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MultiSelectChip(
                                reportList,
                                onSelectionChanged: (selectedList) {
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
                                },
                              ),
                            ],
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MultiSelectChip(
                                reportList,
                                onSelectionChanged: (selectedList) {
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
                                },
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () => {
                        if (!a && !b)
                          {
                            new SuperTooltip(
                              popupDirection: TooltipDirection.down,
                              content: new Material(
                                  child: Text(
                                getTranslated(context, "choi"),
                                softWrap: true,
                              )),
                            ).show(context),
                          }
                        else
                          {
                            Navigator.of(context).pop(),
                            sendNotif(a, b, p1, p2),
                          }
                      },
                      child: InkWell(
                        child: Container(
                          width: 200,
                          height: 50,
                          padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
                          decoration: BoxDecoration(
                            color: new Color(0xFF00A19A),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(32.0),
                                bottomRight: Radius.circular(32.0)),
                          ),
                          child: Text(
                            getTranslated(context, "ccc"),
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    if (Statis.notif == null) {
      Statis.notif = true;
    }

    return WillPopScope(
        // ignore: missing_return
        onWillPop: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(getTranslated(context, "vulez")),
                content: Text(getTranslated(context, "toutledon")),
                actions: <Widget>[
                  // ignore: deprecated_member_use
                  new FlatButton(
                    child: new Text(getTranslated(context, "wi")),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => Home()));
                    },
                  ),
                  // ignore: deprecated_member_use
                  new FlatButton(
                    child: new Text(getTranslated(context, "nn")),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(getTranslated(context, "res")),
              automaticallyImplyLeading: true,
            ),
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  AnimationDroite(),
                  SizedBox(
                    height: 10,
                  ),
                  MessageDroite(),
                  SizedBox(height: 20),
                  AnimationGauche(),
                  SizedBox(height: 10),
                  MessageGauche(),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // ignore: deprecated_member_use
                      RaisedButton(
                        onPressed: () {
                          // ignore: missing_required_param
                          _openAlertBox(p1: widget.pied1, p2: widget.pied2);
                        },
                        color: new Color(0xFF00A19A),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        child: Text(
                          getTranslated(context, "notimp").toUpperCase(),
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      // ignore: deprecated_member_use
                      RaisedButton(
                        onPressed: () => {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Home())),
                          Fluttertoast.showToast(
                              msg: getTranslated(context, "anat"),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black45,
                              textColor: Colors.white,
                              fontSize: 14.0),
                          if (Statis.notif)
                            {
                              autoNotifi(widget.pied1, widget.pied2),
                            }
                        },
                        color: new Color(0xFF00A19A),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              getTranslated(context, "retu").toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
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
                  )
                ],
              ),
            )));
  }

  // ignore: non_constant_identifier_names
  Row MessageGauche() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      DelayedAnimation(
        child: Row(
          children: [
            Align(
              child: Text(
                message_etat(calcul_etat_Gauche(widget.pied1, widget.pied2)),
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 30,
                    fontFamily: "Muli",
                    fontWeight: FontWeight.w500,
                    color: color_message(
                        calcul_etat_Gauche(widget.pied1, widget.pied2))),
              ),
            ),
          ],
        ),
        delay: 1300,
      ),
    ]);
  }

  // ignore: missing_return
  Future<String> updateUser() async {
    try {
      final response = await http.put(Uri.http(Url, "/user/updateUser"),
          body: jsonDecode(json.encode(Home.currentUser.toJson()).toString()));
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['message'] == 'user updated' && mounted) {
          /*ScaffoldMessenger.of(context)
              .showSnackBar(mySnackBar("user updated"));*/
        } else {
          return null;
        }
      }
    } on HttpException catch (err) {
      //print("Network exception error: $err");
      return null;
    } finally {
      //
    }
  }

  // ignore: non_constant_identifier_names
  Row AnimationGauche() {
    LinearGradient x;
    if (calcul_etat_Gauche(widget.pied1, widget.pied2) * 100 >= 80) {
      x = LinearGradient(colors: [
        Colors.redAccent,
        Colors.yellow[900],
        Colors.red,
      ]);
    } else if (calcul_etat_Gauche(widget.pied1, widget.pied2) * 100 < 80) {
      x = LinearGradient(colors: [
        kPrimaryColor,
        Colors.greenAccent,
      ]);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () => {_detailsPiedGauche()},
          splashColor: new Color(0xFF00A19A),
          borderRadius: BorderRadius.circular(360.0),
          child: RadialProgress(
            goalCompleted: calcul_etat_Gauche(widget.pied1, widget.pied2),
            msg: getTranslated(context, "piedg"),
            amelioration: calcul_am_Gauche(widget.pied1, widget.pied2),
            lg: x,
          ),
        ),
      ],
    );
  }

  _detailsPiedGauche() async {
    await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              child: SingleChildScrollView(
                child: Container(
                    //height: MediaQuery.of(context).size.width < 360 ? 500 : 320,

                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32.0)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child: Container(
                            child: Center(
                                child: Text(getTranslated(context, "detaipg"),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20))),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(45.0),
                              color: Colors.teal,
                              border: Border.all(
                                  color: Colors.white,
                                  style: BorderStyle.solid,
                                  width: 2.0),
                            ),
                          ),
                          height: 70.0,
                          width: 500,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(32.0),
                                topRight: Radius.circular(32.0),
                              ),
                              color: Colors.white),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Image.asset(
                                    'assets/temperature.png',
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    " " +
                                        getTranslated(context, "ttemp") +
                                        " :",
                                    style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize:
                                          MediaQuery.of(context).size.width <
                                                  380
                                              ? 12
                                              : 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    TemperatureGauche(
                                            widget.pied1, widget.pied2) +
                                        "°C",
                                    style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize:
                                          MediaQuery.of(context).size.width <
                                                  380
                                              ? 12
                                              : 18,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Image.asset(
                                    'assets/gonflement.png',
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "  " +
                                        getTranslated(context, "gonfo") +
                                        " :",
                                    style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize:
                                          MediaQuery.of(context).size.width <
                                                  380
                                              ? 12
                                              : 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    GonflementGauche(
                                            widget.pied1, widget.pied2) +
                                        " " +
                                        getTranslated(context, "oni"),
                                    style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize:
                                          MediaQuery.of(context).size.width <
                                                  380
                                              ? 12
                                              : 18,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Image.asset(
                                    'assets/rougeur.png',
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "  " + getTranslated(context, "rou") + " :",
                                    style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize:
                                          MediaQuery.of(context).size.width <
                                                  380
                                              ? 12
                                              : 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    " " +
                                        RougeurGauche(
                                            widget.pied1, widget.pied2) +
                                        "%",
                                    style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize:
                                          MediaQuery.of(context).size.width <
                                                  380
                                              ? 12
                                              : 18,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            FlatButton(
                                child: Center(
                                  child: Text(
                                    getTranslated(context, "Fermer"),
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize:
                                            MediaQuery.of(context).size.width <
                                                    380
                                                ? 10
                                                : 14,
                                        color: Colors.teal),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                color: Colors.transparent)
                          ],
                        ),
                      ],
                    )),
              ));
        });
  }

  // ignore: non_constant_identifier_names
  Row MessageDroite() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      DelayedAnimation(
        child: Row(
          children: [
            Align(
              child: Text(
                message_etat(calcul_etat_Droite(widget.pied1, widget.pied2)),
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 30,
                    fontFamily: "Muli",
                    fontWeight: FontWeight.w500,
                    color: color_message(
                        calcul_etat_Droite(widget.pied1, widget.pied2))),
              ),
            ),
          ],
        ),
        delay: 1300,
      ),
    ]);
  }

  // ignore: non_constant_identifier_names
  Row AnimationDroite() {
    LinearGradient x;
    if (calcul_etat_Droite(widget.pied1, widget.pied2) * 100 >= 80) {
      x = LinearGradient(colors: [
        Colors.redAccent,
        Colors.yellow[900],
        Colors.red,
      ]);
    } else if (calcul_etat_Droite(widget.pied1, widget.pied2) * 100 < 80) {
      x = LinearGradient(colors: [
        kPrimaryColor,
        Colors.greenAccent,
      ]);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () => {detailsPiedDroite()},
          splashColor: new Color(0xFF00A19A),
          borderRadius: BorderRadius.circular(360.0),
          child: RadialProgress(
            goalCompleted: calcul_etat_Droite(widget.pied1, widget.pied2),
            msg: getTranslated(context, "piedd"),
            amelioration: calcul_am_Droite(widget.pied1, widget.pied2),
            lg: x,
          ),
        ),
      ],
    );
  }

  Future detailsPiedDroite() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              child: SingleChildScrollView(
                child: Container(
                    //height: MediaQuery.of(context).size.width < 360 ? 500 : 320,

                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32.0)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child: Container(
                            child: Center(
                                child: Text(getTranslated(context, "detaipd"),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20))),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(45.0),
                              color: Colors.teal,
                              border: Border.all(
                                  color: Colors.white,
                                  style: BorderStyle.solid,
                                  width: 2.0),
                            ),
                          ),
                          height: 70.0,
                          width: 500,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(32.0),
                                topRight: Radius.circular(32.0),
                              ),
                              color: Colors.white),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Image.asset(
                                    'assets/temperature.png',
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    " " +
                                        getTranslated(context, "ttemp") +
                                        " :",
                                    style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize:
                                          MediaQuery.of(context).size.width <
                                                  380
                                              ? 12
                                              : 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    TemperatureDroite(
                                            widget.pied1, widget.pied2) +
                                        "°C",
                                    style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize:
                                          MediaQuery.of(context).size.width <
                                                  380
                                              ? 12
                                              : 18,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Image.asset(
                                    'assets/gonflement.png',
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "  " +
                                        getTranslated(context, "gonfo") +
                                        " :",
                                    style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize:
                                          MediaQuery.of(context).size.width <
                                                  380
                                              ? 12
                                              : 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    GonflementDroite(
                                            widget.pied1, widget.pied2) +
                                        getTranslated(context, "oni"),
                                    style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize:
                                          MediaQuery.of(context).size.width <
                                                  380
                                              ? 12
                                              : 18,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Image.asset(
                                    'assets/rougeur.png',
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "  " + getTranslated(context, "rou") + " :",
                                    style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize:
                                          MediaQuery.of(context).size.width <
                                                  380
                                              ? 12
                                              : 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    " " +
                                        RougeurDroite(
                                            widget.pied1, widget.pied2) +
                                        "%",
                                    style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize:
                                          MediaQuery.of(context).size.width <
                                                  380
                                              ? 12
                                              : 18,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            FlatButton(
                                child: Center(
                                  child: Text(
                                    getTranslated(context, "Fermer"),
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize:
                                            MediaQuery.of(context).size.width <
                                                    380
                                                ? 10
                                                : 14,
                                        color: Colors.teal),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                color: Colors.transparent)
                          ],
                        ),
                      ],
                    )),
              ));
        });
  }

  String cotePied(Pied p) {
    if (p.cote == Cote.droit)
      return "Droite";
    else
      return "Gauche";
  }

  autoNotifi(Pied p1, Pied p2) {
    bool sent = false;
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    bool go = false;
    if (Statis.lastAuto == null) {
      Statis.lastAuto = date;
      go = true;
    } else if (Statis.lastAuto != date) {
      go = true;
    }

    if ((p1.etat > 1 || p2.etat > 1) & go) {
      if (doctorPhone.length < 8 && doctorMail.length < 5 ||
          (doctorMail.isEmpty ||
              doctorMail == "null" ||
              doctorPhone.isEmpty ||
              doctorPhone == "null")) {
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
          title: getTranslated(context, "notauto"),
          message: getTranslated(context, "veggfa"),
          duration: Duration(seconds: 2),
        )..show(context);
      } else if ((doctorPhone.length < 8 ||
              doctorPhone.isEmpty ||
              doctorPhone == "null") &&
          doctorMail.length > 5) {
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
          title: getTranslated(context, "notauto"),
          message: getTranslated(context, "aefdza"),
          duration: Duration(seconds: 2),
        )..show(context);
      } else if (doctorPhone.length >= 8 &&
          (doctorMail.length < 5 ||
              doctorMail.isEmpty ||
              doctorMail == "null")) {
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
          title: getTranslated(context, "notauto"),
          message: getTranslated(context, "aevfdza"),
          duration: Duration(seconds: 2),
        )..show(context);
      } else {
        sent = SendMail(doctorMail, p1, p2);

        SmsMessage m = SendSms(doctorPhone, p1, p2);
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
                backgroundGradient: LinearGradient(
                    colors: [new Color(0xFF00A19A), Colors.teal]),
                title: getTranslated(context, "nouten"),
                message: getTranslated(context, "votrme"),
                duration: Duration(seconds: 2),
              )..show(context);
              Statis.lastAuto = date;
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
                backgroundGradient: LinearGradient(
                    colors: [new Color(0xFF00A19A), Colors.teal]),
                title: getTranslated(context, "echecno"),
                message: getTranslated(context, "emailnoo"),
                duration: Duration(seconds: 2),
              )..show(context);
            }
          } else if (state == SmsMessageState.Fail) {
            if (!sent) {
              FlushEchec(context);
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
                backgroundGradient: LinearGradient(
                    colors: [new Color(0xFF00A19A), Colors.teal]),
                title: getTranslated(context, "echecno"),
                message: getTranslated(context, "smsno"),
                duration: Duration(seconds: 2),
              )..show(context);
            }
          }
        });
      }
    }
  }

  // ignore: non_constant_identifier_names
  bool SendMail(String address, Pied p1, Pied p2) {
    String username = 'fitfoot.service@gmail.com';
    String password = 'fitfoot123';
    bool sent = false;
    // ignore: deprecated_member_use
    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'FitFoot')
      ..recipients.add(address)
      ..subject = 'FitFoot Assitance '
      ..html = "<h1>Patient : " +
          Home.currentUser.firstName +
          " " +
          Home.currentUser.lastName +
          "</h1><hr><p><h2>Resultats du derniére analyse : <br><br> Pied " +
          cotePied(p1) +
          " : " +
          (p1.etat * 100).toInt().toString() +
          "% </h2>  Temperature : " +
          p1.temperature.toString() +
          "°C<br> Gonflement :" +
          p1.dimention.toString() +
          " unité<br> Rougeur : " +
          p1.rougeur.toString() +
          "%<br> <h2>Pied " +
          cotePied(p2) +
          " : " +
          (p2.etat * 100).toInt().toString() +
          "% </h2>  Temperature : " +
          p2.temperature.toString() +
          "°C<br> Gonflement :" +
          p2.dimention.toString() +
          " unité<br> Rougeur : " +
          p2.rougeur.toString() +
          "% </p> ";

    try {
      final sendReport = send(message, smtpServer);
      sent = true;
    } on MailerException catch (e) {
      //print('Message not sent.');
      for (var p in e.problems) {
        //print('Problem: ${p.code}: ${p.msg}');
      }
    }
    return sent;
  }

  // ignore: non_constant_identifier_names
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
      title: getTranslated(context, "echecno"),
      message: getTranslated(context, "zouzle"),
      duration: Duration(seconds: 2),
    )..show(c);
  }

// ignore: non_constant_identifier_names
  // ignore: missing_return
  double calcul_etat_Gauche(Pied p1, Pied p2) {
    if (p1.cote == Cote.gauche) {
      return p1.etat;
    } else if (p2.cote == Cote.gauche) {
      return p2.etat;
    }
  }

  double calcul_am_Gauche(Pied p1, Pied p2) {
    if (p1.cote == Cote.gauche) {
      return p1.amelioration;
    } else if (p2.cote == Cote.gauche) {
      return p2.amelioration;
    }
  }

  double calcul_am_Droite(Pied p1, Pied p2) {
    if (p1.cote == Cote.droit) {
      return p1.amelioration;
    } else if (p2.cote == Cote.droit) {
      return p2.amelioration;
    }
  }

// ignore: non_constant_identifier_names
  double calcul_etat_Droite(Pied p1, Pied p2) {
    if (p1.cote == Cote.droit) {
      return p1.etat;
    } else {
      return p2.etat;
    }
  }

  String message_etat(double etat) {
    etat = etat * 100;
    if (etat >= 80)
      return getTranslated(context, "pcr");
    else
      return getTranslated(context, "ped");
  }

  Color color_message(double etat) {
    etat = etat * 100;
    if (etat >= 80)
      return new Color(0xFFB71C1C);
    else
      return kPrimaryColor;
  }

  String TemperatureGauche(Pied p1, Pied p2) {
    if (p1.cote == Cote.gauche) {
      return p1.temperature.toString();
    } else if (p2.cote == Cote.gauche) {
      return p2.temperature.toString();
    }
  }

  String TemperatureDroite(Pied p1, Pied p2) {
    if (p1.cote == Cote.droit) {
      return p1.temperature.toString();
    } else if (p2.cote == Cote.droit) {
      return p2.temperature.toString();
    }
  }

  String GonflementGauche(Pied p1, Pied p2) {
    if (p1.cote == Cote.gauche) {
      return p1.dimention.toString();
    } else if (p2.cote == Cote.gauche) {
      return p2.dimention.toString();
    }
  }

  String GonflementDroite(Pied p1, Pied p2) {
    if (p1.cote == Cote.droit) {
      return p1.dimention.toString();
    } else if (p2.cote == Cote.droit) {
      return p2.dimention.toString();
    }
  }

  String RougeurGauche(Pied p1, Pied p2) {
    if (p1.cote == Cote.gauche) {
      return p1.rougeur.toString();
    } else if (p2.cote == Cote.gauche) {
      return p2.rougeur.toString();
    }
  }

  String RougeurDroite(Pied p1, Pied p2) {
    if (p1.cote == Cote.droit) {
      return p1.rougeur.toString();
    } else if (p2.cote == Cote.droit) {
      return p2.rougeur.toString();
    }
  }

  List<String> reportList = [
    "SMS",
    "EMAIL",
  ];

  //////////////////////// end of state
}
