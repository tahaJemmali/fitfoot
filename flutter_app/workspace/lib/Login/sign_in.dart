import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/Login/forget_password.dart';
import 'package:workspace/Login/sign_up.dart';
import 'package:workspace/Login/utils/constants.dart';
import 'package:workspace/Login/utils/default_button.dart';
import 'package:workspace/Models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //resizeToAvoidBottomInset: false,
        //appBar: null,
        body: SafeArea(
            child: SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 20),
              Image.asset(
                'assets/fflogo.png',
                width: 200,
              ),
              SizedBox(height: 20),
              Text(
                "",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                getTranslated(context, 'cnx'),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              SignInForm(),
            ],
          ),
        ),
      ),
    )));
  }
}

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  SharedPreferences sharedPreferences;
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  String _email;
  String _password;
  bool _rememberMe = false;
  bool _passwordVisible;

  Alignment _alignment = Alignment.bottomRight;

  Future<void> getShared() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    getShared().then((value) {
      if (sharedPreferences != null) {
        if (sharedPreferences.containsKey(LANGUAGE_CODE)) {
          if (sharedPreferences.getString(LANGUAGE_CODE) == ARABE) {
            setState(() {
              _alignment = Alignment.bottomLeft;
            });
          } else {
            setState(() {
              _alignment = Alignment.bottomRight;
            });
          }
        }
      }
    });
    _passwordVisible = false;
  }

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

  String _validPass(value) {
    _password = value;
    if (_password.isEmpty) {
      return kPasswordNullError;
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
            /*onSaved: (value) {
              setState(() {
                _nom = value;
              });
            },*/
            initialValue: "mohamedtaha.jammali@esprit.tn",
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
            keyboardType: TextInputType.text,
            obscureText: !_passwordVisible,
            initialValue: "12345678",
            validator: _validPass,
            maxLength: 25,
            decoration: InputDecoration(
              counterText: '',
              hintText: getTranslated(context, 'EPassword'),
              labelText: getTranslated(context, 'Password'),
              floatingLabelBehavior: FloatingLabelBehavior.always,
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
          SizedBox(height: 10),
          Stack(
            children: [
              Row(
                children: [
                  Checkbox(
                      value: _rememberMe,
                      activeColor: kPrimaryColor,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value;
                        });
                      }),
                  Text(
                    getTranslated(context, 'Remember me'),
                    style: TextStyle(color: Colors.black87),
                  ),
                ],
              ),
              Container(
                alignment: _alignment,
                padding: EdgeInsets.only(top: 0),
                child: RichText(
                  text: TextSpan(
                    text: '',
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      /*TextSpan(
                  text: 'world!',
                  style: TextStyle(fontWeight: FontWeight.bold)),*/
                      TextSpan(
                          text: getTranslated(context, 'Forgot password'),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgetPassword(),
                                  ));
                            }),
                    ],
                  ),
                ),
              ),
            ],
          ),
          DefaultButton(
            text: getTranslated(context, 'Log in'),
            press: () {
              if (!this._key.currentState.validate()) {
                return;
              } else {
                this._key.currentState.save();

                _login(User(email: _email, password: _password))
                    .then((user) async {
                  if (user != null) {
                    //get user infos
                    //print(user.toJson());

                    final SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    sharedPreferences.setString('id', user.id);
                    sharedPreferences.setString('email', user.email);
                    sharedPreferences.setString('emailM', user.emailDoctor);
                    sharedPreferences.setString('firstName', user.firstName);
                    sharedPreferences.setString('lastName', user.lastName);
                    sharedPreferences.setBool(
                        'emailVerification', user.emailVerification);
                    //sharedPreferences.setString('password', user.password);
                    sharedPreferences.setString('photo', user.photo);
                    sharedPreferences.setString('phone', user.phone);
                    sharedPreferences.setString(
                        'phoneDoctor', user.phoneDoctor);
                    sharedPreferences.setDouble('height', user.height);
                    sharedPreferences.setString(
                        'gender', user.gender.toString());
                    sharedPreferences.setDouble('weight', user.weight);
                    sharedPreferences.setString('address', user.address);

                    String signupdate =
                        DateFormat(kkdateFormat).format(user.signUpDate);
                    sharedPreferences.setString('signUpDate', signupdate);
                    //print(signupdate); //2021-03-20 11:56:43
                    String lastlogindate =
                        DateFormat(kkdateFormat).format(user.lastLoginDate);
                    sharedPreferences.setString('lastLoginDate', lastlogindate);

                    if (user.birthDate != null) {
                      String birthdate =
                          DateFormat(kkdateFormat).format(user.birthDate);
                      sharedPreferences.setString('birthDate', birthdate);
                    }

                    if (_rememberMe) {
                      await sharedPreferences.setString('rememberMe', 'true');
                    } else {
                      await sharedPreferences.setString('rememberMe', 'false');
                    }

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  }
                });
              }
            },
          ),
          SizedBox(height: 115),
          Align(
            alignment: Alignment.bottomCenter,
            child: RichText(
              text: TextSpan(
                text: '',
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                      text: getTranslated(context, 'No account'),
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black87)),
                  TextSpan(
                      text: getTranslated(context, 'SignUp'),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUp()))
                            }),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomCenter,
            child: RichText(
              text: TextSpan(
                text: '',
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                      text: "Set ip"+"("+Url+")",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                          fontSize: 11,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => {
                              _showDialog(title: "Set server ip",initValue: "",hintValue: "192.168.1.",labelTxt: "ip server",textInputType: TextInputType.number,iconData: Icons.arrow_drop_down_outlined)
                            }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showDialog(
      {String title,
      String initValue,
      String hintValue,
      String labelTxt,
      TextInputType textInputType,
      IconData iconData})  {
     showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Container(
          width: 300,
          child: Form(
            child: TextFormField(
              onChanged: (value){setState(() {
                Url=value+":54001";
              }); },
              keyboardType: textInputType,
              autofocus: true,
              initialValue: initValue,
              maxLength: 40,
              decoration: InputDecoration(
                counterText: '',
                hintText: hintValue,
                labelText: labelTxt,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: Icon(iconData, size: 18.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  gapPadding: 15,
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                    gapPadding: 10,
                    borderSide: BorderSide(color: Colors.black54, width: 2.0)),
              ),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: kPrimaryColor, // background
            ),
            child: Text("Enregistrer"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: kPrimaryColor, // background
            ),
            child: Text("Annuler"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
  
  Future<User> _login(User user) async {
    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black);
    SVProgressHUD.setRingNoTextRadius(20);
    SVProgressHUD.show();
    try {
      final response =
          await http.put(Uri.http(Url, "/user/login"), body: user.toJson());
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        SVProgressHUD.dismiss();
        if (jsonResponse['user'] != null) {
          //print(jsonResponse['user']['emailVerification']);
          User user = User.fromJson(jsonResponse['user']);
          //print(user.toJson());
          /*final SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('firstName', user.firstName);
        sharedPreferences.setString('lastName', user.lastName);
        sharedPreferences.setString('email', user.email);
        sharedPreferences.setBool('rememberMe', _rememberMe);*/
          return user;
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
  }
}

/*TextButton(
            onPressed: () {
              print('Pressed');
            },
            child: Text(
              'Login',
            ),
            style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.0),
                    side: BorderSide(color: Colors.blue)),
                primary: Colors.white,
                backgroundColor: Colors.blue,
                textStyle:
                    TextStyle(fontSize: 24, fontStyle: FontStyle.normal)),
          ),*/
