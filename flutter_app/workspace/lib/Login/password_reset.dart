import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workspace/Login/utils/constants.dart';
import 'package:workspace/Login/utils/default_button.dart';
import 'package:workspace/Models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:pin_code_fields/pin_code_fields.dart';

class PasswordReset extends StatefulWidget {
  final String email;
  PasswordReset(this.email);

  @override
  _PasswordResetState createState() => _PasswordResetState(email);
}

class _PasswordResetState extends State<PasswordReset> {
  final String _email;
  _PasswordResetState(this._email);

  GlobalKey<FormState> _key = GlobalKey<FormState>();

  String _password, _confirmPassword;
  bool _passwordVisible = false;

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
                    getTranslated(context, "R3"),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  recoveryCodeForm(),
                ],
              ),
            ),
          ),
        )));
  }

  Widget recoveryCodeForm() {
    return Form(
        key: _key,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              onTap: () {},
              initialValue: "",
              maxLength: 25,
              validator: _validPass,
              obscureText: true,
              decoration: InputDecoration(
                counterText: '',
                hintText: getTranslated(context, "EPassword"),
                labelText: getTranslated(context, "Password"),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: Icon(Icons.lock, size: 18.0),
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
            SizedBox(height: 15),
            TextFormField(
              onTap: () {},
              initialValue: "",
              maxLength: 20,
              validator: _validCPass,
              keyboardType: TextInputType.text,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                counterText: '',
                hintText: getTranslated(context, "ECPassword"),
                labelText: getTranslated(context, "CPassword"),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: Icon(Icons.lock, size: 18.0),
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: kPrimaryColor,
                      size: 23.0,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
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
            SizedBox(
              height: 15,
            ),
            DefaultButton(
              text: getTranslated(context, "Envoyer"),
              press: () {
                if (!this._key.currentState.validate()) {
                  return;
                } else {
                  this._key.currentState.save();
                  //api
                  resetPassword(_email, _password).then((value) {
                    if (value) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(getTranslated(
                                  context, "Votre demande a été acceptée")),
                              content: Text(getTranslated(context,
                                  "Votre mot de passe a été réinitialisé avec succès !")),
                              actions: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: kPrimaryColor, // background
                                  ),
                                  child: Text(getTranslated(context, "Ok")),
                                  onPressed: () {
                                    Navigator.popUntil(
                                        context, (route) => route.isFirst);
                                  },
                                )
                              ],
                            );
                          });
                    }
                  });
                }
              },
            ),
          ],
        ));
  }

  String _validPass(value) {
    _password = value;
    if (_password.isEmpty) {
      return kPasswordNullError;
    } else if (_password.length < 8) {
      return kShortPassError;
    } else if (_password.length > 16) {
      return kLongPassError;
    } else {
      return null;
    }
  }

  String _validCPass(value) {
    _confirmPassword = value;
    if (_confirmPassword.isEmpty) {
      return kPasswordNullError;
    } else if (_confirmPassword != _password) {
      return kMatchPassError;
    } else {
      return null;
    }
  }

  Future<bool> resetPassword(String email, String password) async {
    String objText =
        '{"email": "' + email + '", "password": "' + password + '" }';

    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black);
    SVProgressHUD.setRingNoTextRadius(20);
    SVProgressHUD.show();

    try {
      final response = await http.put(Uri.http(Url, "/user/resetPassword"),
          body: convert.jsonDecode(objText));
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        print(jsonResponse);
        SVProgressHUD.dismiss();
        if (jsonResponse['message'] == "Password has been reset") {
          return true;
        } else {
          Fluttertoast.showToast(
              msg: jsonResponse['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black45,
              textColor: Colors.white,
              fontSize: 14.0);
          return false;
        }
      }
    } on HttpException catch (err) {
      print("Network exception error: $err");
      return false;
    } finally {
      //SVProgressHUD.dismiss();
    }
    return false;
  }
}
