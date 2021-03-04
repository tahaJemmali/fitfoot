import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_sms/flutter_sms.dart';

void _sendSMS(String message, List<String> recipents) async {
  String _result = await sendSMS(message: message, recipients: recipents)
      .catchError((onError) {
    print(onError);
  });
  print(_result);
}

void sendit() {
  String message = "This is a test message!";
  List<String> recipents = ["+21651775991"];

  _sendSMS(message, recipents);
}

sendMail() async {
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
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
  sendit();
}

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Add a new car"),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text("Notifier le medecin"),
                    onPressed: sendMail,
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
