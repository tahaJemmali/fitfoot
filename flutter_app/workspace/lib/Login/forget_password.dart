import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workspace/Login/recovery_code.dart';
import 'package:workspace/Login/utils/constants.dart';
import 'package:workspace/Login/utils/default_button.dart';
import 'package:workspace/Models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
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
                    getTranslated(context, 'Récupération de compte'),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    getTranslated(context, 'R1'),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ForgetPasswordForm(),
                ],
              ),
            ),
          ),
        )));
  }
}

class ForgetPasswordForm extends StatefulWidget {
  @override
  _ForgetPasswordFormState createState() => _ForgetPasswordFormState();
}

class _ForgetPasswordFormState extends State<ForgetPasswordForm> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  String _email;

  String _validEmail(value) {
    _email = value;
    if (_email.isEmpty) {
      return kEmailNullError;
    } else if (!emailValidatorRegExp.hasMatch(_email)) {
      return kInvalidEmailError;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Column(
        children: [
          SizedBox(height: 20),
          TextFormField(
            initialValue: "fahd.larayedh@gmail.com",
            maxLength: 40,
            validator: _validEmail,
            decoration: InputDecoration(
              counterText: '',
              hintText: getTranslated(context, "EEmail address"),
              labelText: getTranslated(context, "Email address"),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              prefixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Icon(Icons.email, size: 18.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                gapPadding: 10,
                borderSide: BorderSide(color: Colors.black),
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  gapPadding: 10,
                  borderSide: BorderSide(color: Colors.black54, width: 2.0)),
            ),
          ),
          SizedBox(height: 20),
          DefaultButton(
            text: getTranslated(context, 'Envoyer'),
            press: () {
              if (!this._key.currentState.validate()) {
                return;
              } else {
                this._key.currentState.save();
                getRecoveryCode(_email).then((code) async {
                  if (code != null) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecoveryCode(code, _email)));
                  }
                });
              }
            },
          ),
          //SizedBox(height: 10),
        ],
      ),
    );
  }

  Future<String> getRecoveryCode(String email) async {
    String objText = '{"email": "' + email + '" }';
    String code;
    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black);
    SVProgressHUD.setRingNoTextRadius(20);
    SVProgressHUD.show();
    try {
      final response = await http.post(
          Uri.http(Url, "/user/getPasswordRecoveryCode"),
          body: convert.jsonDecode(objText));
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        print(jsonResponse);
        SVProgressHUD.dismiss();
        if (jsonResponse['code'] != null) {
          code = (jsonResponse['code']).toString();
        } else {
          Fluttertoast.showToast(
              msg: jsonResponse['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black45,
              textColor: Colors.white,
              fontSize: 14.0);
        }
      }
    } on HttpException catch (err) {
      print("Network exception error: $err");
      return null;
    } finally {
      //SVProgressHUD.dismiss();
    }
    return code;
  }
}
