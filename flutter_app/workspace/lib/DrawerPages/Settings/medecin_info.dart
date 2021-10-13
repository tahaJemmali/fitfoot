import 'package:clean_settings_nnbd/clean_settings_nnbd.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/Login/utils/constants.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class MedecinInfo extends StatefulWidget {
  @override
  _MedecinInfoState createState() => _MedecinInfoState();
}

class _MedecinInfoState extends State<MedecinInfo> {
  SharedPreferences sharedPreferences;

  GlobalKey<FormState> _key = GlobalKey<FormState>();
  String _emailM, _phoneM;

  String _validEmailM(value) {
    _emailM = value;
    if (_emailM.isEmpty) {
      return kFieldNullError;
    } else if (!emailValidatorRegExp.hasMatch(_emailM)) {
      return kInvalidEmailError;
    } else {
      return null;
    }
  }

  String _validPhoneM(value) {
    _phoneM = value;
    if (_phoneM.isEmpty) {
      return kFieldNullError;
    } else if (!_checkPwd(_phoneM)) {
      return kInvalidPhoneError;
    } else {
      return null;
    }
  }

  bool _checkPwd(String string) {
    if (string.length != 8) {
      return false;
    }
    List<String> myList = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    List<String> myList2 = [
      '99',
      '98',
      '97',
      '96',
      '52',
      '53',
      '54',
      '55',
      '56',
      '20',
      '21',
      '22',
      '23',
      '24',
      '26',
      '27'
    ];
    for (int i = 0; i < string.length; i++) {
      if (!myList.contains(string[i])) {
        return false;
      }
    }

    String x = string[0] + string[1];
    for (int i = 0; i < myList2.length; i++) {
      if (!myList2.contains(x)) {
        return false;
      }
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    print(Home.currentUser.emailDoctor);
    loadShared();
  }

  void loadShared() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(getTranslated(context, "Informations du médecin")),
        ),
        body: Container(
          child: SettingContainer(
            sections: [
              SettingSection(
                title: getTranslated(context, "Informations sur votre médecin"),
                items: [
                  SettingItem(
                    displayValue: Home.currentUser.emailDoctor == "null"
                        ? getTranslated(context, 'Non mentioné')
                        : Home.currentUser.emailDoctor,
                    title: getTranslated(context, 'Adresse E-mail du médecin'),
                    onTap: () {
                      _showDialog(
                          title: 'Entrez l adresse E-mail du médecin',
                          f: _validEmailM,
                          initValue: Home.currentUser.emailDoctor == "null"
                              ? ''
                              : Home.currentUser.emailDoctor,
                          hintValue: "",
                          labelTxt: "Adresse E-mail du médecin",
                          textInputType: TextInputType.text,
                          iconData: Icons.email);
                    },
                  ),
                  SettingItem(
                    displayValue: Home.currentUser.phoneDoctor == "null"
                        ? getTranslated(context,'Non mentioné')
                        : Home.currentUser.phoneDoctor,
                    title: getTranslated(context, 'Numéro de téléphone du médecin'),
                    onTap: () {
                      _showDialog(
                          title: 'Entrez le numéro de téléphone du médecin',
                          f: _validPhoneM,
                          initValue: Home.currentUser.phoneDoctor == "null"
                              ? ''
                              : Home.currentUser.phoneDoctor,
                          hintValue: "",
                          labelTxt: "Numéro de téléphone du médecin",
                          textInputType: TextInputType.phone,
                          iconData: Icons.call);
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  _showDialog(
      {String title,
      Function f,
      String initValue,
      String hintValue,
      String labelTxt,
      TextInputType textInputType,
      IconData iconData}) async {
    await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Container(
          width: 420,
          child: Form(
            key: _key,
            child: TextFormField(
              keyboardType: textInputType,
              autofocus: true,
              initialValue: initValue,
              maxLength: 40,
              validator: f,
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
            onPressed: () async {
              if (!this._key.currentState.validate()) {
                return;
              } else {
                this._key.currentState.save();
                if (_emailM != null)
                  setState(() {
                    Home.currentUser.emailDoctor = _emailM;
                    sharedPreferences.setString('emailM', _emailM);
                  });
                if (_phoneM != null)
                  setState(() {
                    Home.currentUser.phoneDoctor = _phoneM;
                    sharedPreferences.setString('phoneDoctor', _phoneM);
                  });
                updateUser();
                Navigator.of(context).pop();
              }
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

  SnackBar mySnackBar(String text) {
    return SnackBar(
      content: Text(text),
      action: SnackBarAction(
        label: '',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
  }

  Future<String> updateUser() async {
    //print(json.encode(Home.currentUser.toJson()));
    try {
      final response = await http.put(Uri.http(Url, "/user/updateUser"),
          body: jsonDecode(json.encode(Home.currentUser.toJson()).toString()));
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print(jsonResponse['message']);
        if (jsonResponse['message'] == 'user updated' && mounted) {
          /*ScaffoldMessenger.of(context)
              .showSnackBar(mySnackBar("user updated"));*/
        } else {
          return null;
        }
      }
    } on HttpException catch (err) {
      print("Network exception error: $err");
      return null;
    } finally {
      //
    }
  }
}
