import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/Login/sign_in.dart';
import 'package:workspace/Login/utils/constants.dart';
import 'package:workspace/Login/utils/default_button.dart';
import 'package:workspace/Models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatelessWidget {
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
                  SizedBox(height: 10),
                  Text(
                    getTranslated(context, 'SignUp'),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    getTranslated(context, 'please complete all fields'),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  SignUpForm(),
                ],
              ),
            ),
          ),
        )));
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String _nom, _prenom, _email, _password, _confirmPassword;
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  int _test;

  bool _passwordVisible;

  @override
  void initState() {
    _passwordVisible = false;
  }

  String _validNom(value) {
    if (_test == 11 || _test == 200) {
      _nom = value;
      if (_nom.isEmpty) {
        return kNomNullError;
      } else if (!nameValidatorRegExp.hasMatch(_nom)) {
        return kInvalidNomError;
      }
    } else {
      return null;
    }
  }

  String _validPrenom(value) {
    if (_test == 12 || _test == 200) {
      _prenom = value;
      if (_prenom.isEmpty) {
        return kPrenomNullError;
      } else if (!nameValidatorRegExp.hasMatch(_prenom)) {
        return kInvalidPrenomError;
      }
    } else {
      return null;
    }
  }

  String _validEmail(value) {
    if (_test == 13 || _test == 200) {
      _email = value;
      if (_email.isEmpty) {
        return kEmailNullError;
      } else if (!emailValidatorRegExp.hasMatch(_email)) {
        return kInvalidEmailError;
      }
    } else {
      return null;
    }
  }

  String _validPass(value) {
    if (_test == 14 || _test == 200) {
      _password = value;
      if (_password.isEmpty) {
        return kPasswordNullError;
      } else if (_password.length < 8) {
        return kShortPassError;
      } else if (_password.length > 16) {
        return kLongPassError;
      }
    } else {
      return null;
    }
  }

  String _validCPass(value) {
    if (/*_test == 15 || */ _test == 200) {
      _confirmPassword = value;
      if (_confirmPassword.isEmpty) {
        return kPasswordNullError;
      } else if (_confirmPassword != _password) {
        return kMatchPassError;
      }
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          Theme(
            data: ThemeData(
              primaryColor: kPrimaryColor,
              primaryColorDark: kPrimaryColor,
            ),
            child: TextFormField(
              /*onSaved: (value) {
                setState(() {
                  _nom = value;
                });
              },*/
              onTap: () {
                setState(() {
                  _test = 11;
                });
              },
              validator: _validNom,
              maxLength: 20,
              decoration: InputDecoration(
                counterText: '',
                hintText: getTranslated(context, 'ElastName'),
                labelText: getTranslated(context, 'lastName'),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: Icon(Icons.supervised_user_circle, size: 18.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  gapPadding: 10,
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  gapPadding: 10,
                  borderSide: BorderSide(color: Colors.black54, width: 2.0),
                ),
                /*suffixIcon: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: new Icon(Icons.email)),*/
                /*contentPadding:
                    EdgeInsets.symmetric(horizontal: 42, vertical: 20),
                */
              ),
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            onTap: () {
              setState(() {
                _test = 12;
              });
            },
            maxLength: 20,
            validator: _validPrenom,
            decoration: InputDecoration(
              counterText: '',
              hintText: getTranslated(context, 'EfirstName'),
              labelText: getTranslated(context, 'firstName'),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              prefixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Icon(Icons.supervised_user_circle_rounded, size: 18.0),
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
          TextFormField(
            onTap: () {
              setState(() {
                _test = 13;
              });
            },
            initialValue: "",
            maxLength: 40,
            validator: _validEmail,
            decoration: InputDecoration(
              counterText: '',
              hintText: getTranslated(context, 'EEmail address'),
              labelText: getTranslated(context, 'Email address'),
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
          TextFormField(
            onTap: () {
              setState(() {
                _test = 14;
              });
            },
            initialValue: "",
            maxLength: 25,
            validator: _validPass,
            obscureText: true,
            decoration: InputDecoration(
              counterText: '',
              hintText: getTranslated(context, 'EPassword'),
              labelText: getTranslated(context, 'Password'),
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
            onTap: () {
              setState(() {
                _test = 15;
              });
            },
            initialValue: "",
            maxLength: 20,
            validator: _validCPass,
            keyboardType: TextInputType.text,
            obscureText: !_passwordVisible,
            decoration: InputDecoration(
              counterText: '',
              hintText: getTranslated(context, 'ECPassword'),
              labelText: getTranslated(context, 'CPassword'),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              prefixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Icon(Icons.lock, size: 18.0),
              ),
              suffixIcon: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: kPrimaryColor //Theme.of(context).primaryColorDark
                    ,
                    size: 23.0,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
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
              /*errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  gapPadding: 10,
                  borderSide: BorderSide(color: Colors.red, width: 1.0)),*/
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  gapPadding: 10,
                  borderSide: BorderSide(color: Colors.black54, width: 2.0)),
            ),
          ),
          SizedBox(height: 30),
          DefaultButton(
            text: getTranslated(context, 'SignUp'),
            press: () async {
              setState(() {
                _test = 200;
              });
              if (!this._key.currentState.validate()) {
                return;
              } else {
                this._key.currentState.save();
                _register(User(
                        firstName: _prenom,
                        lastName: _nom,
                        email: _email,
                        password: _password))
                    .then((value) {
                  //SVProgressHUD.dismiss();
                  if (value == 'Registration success') {
                    //Dialog verifier l'adress email pour confirmer l'activation de votre compte
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(getTranslated(
                                context, "Vous êtes maintement inscris")),
                            content: Text(getTranslated(
                                context, "Vérifiez votre boite e-mail")),
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
                  } else if (value == 'Email already exists') {
                    //Dialog adress email existe déja
                    Fluttertoast.showToast(
                        msg: getTranslated(
                            context, "Cette adresse E-mail exsite déja"),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black45,
                        textColor: Colors.white,
                        fontSize: 14.0);
                  }
                  return value;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}

Future<String> _register(User user) async {
  SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black);
  SVProgressHUD.setRingNoTextRadius(20); // default is 24 pt
  SVProgressHUD.show();
  try {
    final response =
        await http.post(Uri.http(Url, "/user/register"), body: user.toJson());
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      //print(jsonResponse['message']);
      return jsonResponse['message'];
    }
  } on HttpException catch (err) {
    print("Network exception error: $err");
    return null;
  } finally {
    SVProgressHUD.dismiss();
    /*print("All Done!");
    Navigator.pop(context);*/
  }
}
