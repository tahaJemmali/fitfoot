import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:workspace/Login/utils/constants.dart';
import 'package:workspace/Login/utils/default_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'password_reset.dart';

class RecoveryCode extends StatefulWidget {
  final String code;
  final String email;
  RecoveryCode(this.code,this.email);

  @override
  _RecoveryCodeState createState() => _RecoveryCodeState(code,email);
}

class _RecoveryCodeState extends State<RecoveryCode> {
  final String _code;
  final String _email;
  _RecoveryCodeState(this._code,this._email);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: defaultTargetPlatform == TargetPlatform.android
                ? Icon(
                    Icons.arrow_back,
                    color: Colors.black87,
                  )
                : Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          elevation: 0.0,
        ),
        body: SafeArea(
            child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.only(bottom: 40, top: 0),
                    child: Image.asset(
                      'assets/fflogo.png',
                      width: 200,
                    ),
                  ),
                  Text(
                    getTranslated(context, "Récupération de compte"),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    getTranslated(context, "R2"),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  RecoveryCodeForm(_code,_email),
                ],
              ),
            ),
          ),
        )));
  }
}

class RecoveryCodeForm extends StatefulWidget {
  final String code;
  final String email;
  RecoveryCodeForm(this.code,this.email);

  @override
  _RecoveryCodeFormState createState() => _RecoveryCodeFormState(code,email);
}

class _RecoveryCodeFormState extends State<RecoveryCodeForm> {
  final String _code;
  final String _email;
  _RecoveryCodeFormState(this._code,this._email);

  GlobalKey<FormState> _key = GlobalKey<FormState>();

  String _currentText = "";
  bool hasError = false;
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _key,
        child: Column(
          children: [
            PinCodeTextField(

              dialogConfig: DialogConfig(
                  affirmativeText: "Coller",
                  negativeText: "Annuler",
                  dialogTitle: "Coller code",
                  dialogContent: "Voulez-vous utiliser ce code "),
              keyboardType: TextInputType.number,
              length: 6,
              obscureText: false,
              animationType: AnimationType.scale,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: MediaQuery.of(context).size.height * 0.08,//60,
                fieldWidth: MediaQuery.of(context).size.width * 0.13,//50,
                activeFillColor: Colors.white,
                inactiveColor: hasError == false ? Colors.black54 : Colors.red,
                activeColor: kPrimaryColor,
                selectedFillColor: kPrimaryColor,
                selectedColor: kPrimaryColor,
                disabledColor: kPrimaryColor,
                inactiveFillColor: kPrimaryColor,
              ),
              errorAnimationController: errorController,
              animationDuration: Duration(milliseconds: 200),
              backgroundColor: Colors.white,
              enableActiveFill: false,
              onCompleted: (v) {
                //print("Completed");
              },
              onChanged: (value) {
                setState(() {
                  _currentText = value;
                });
              },
              beforeTextPaste: (text) {
                return _checkPastedCode(text);
              },
              appContext: context,
            ),
            SizedBox(
              height: 15,
            ),
            DefaultButton(
              text: getTranslated(context, 'Envoyer'),
              press: () {
                if (!this._key.currentState.validate()) {
                  return;
                } else {
                  if (_currentText.length == 6 &&
                      _checkPastedCode(_currentText) &&
                      _currentText == _code) {
                    this._key.currentState.save();
                    setState(() {
                      hasError = false;
                    });
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PasswordReset(_email)));
                  } else {
                    setState(() {
                      hasError = true;
                    });
                    errorController.add(ErrorAnimationType.shake);
                  }
                }
              },
            ),
          ],
        ));
  }
}

bool _checkPastedCode(String string) {
  List<String> myList = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  for (int i = 0; i < string.length; i++) {
    if (!myList.contains(string[i])) {
      return false;
    }
  }
  return true;
}
