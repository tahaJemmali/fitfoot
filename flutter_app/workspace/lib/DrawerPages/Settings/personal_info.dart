import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:clean_settings_nnbd/clean_settings_nnbd.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:workspace/DrawerPages/Settings/google_map.dart';
import 'package:workspace/Login/utils/constants.dart';
import 'package:workspace/Models/address.dart';
import '../home.dart';
import 'cities_data.dart';
import 'medecin_info.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class PersonalInfo extends StatefulWidget {
  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  SharedPreferences sharedPreferences;

  GlobalKey<FormState> _key = GlobalKey<FormState>();
  String _email, _nom, _prenom, _phone, _phoneM, _ville;

  String _validEmail(value) {
    _email = value;
    if (_email.isEmpty) {
      return kFieldNullError;
    } else if (!emailValidatorRegExp.hasMatch(_email)) {
      return kInvalidEmailError;
    } else {
      return null;
    }
  }

  String _validNom(value) {
    _nom = value;
    if (_nom.isEmpty) {
      return kFieldNullError;
    } else if (!nameValidatorRegExp.hasMatch(_nom)) {
      return kInvalidNomError;
    } else {
      return null;
    }
  }

  String _validVille(value) {
    _ville = value;
    if (_ville.isEmpty) {
      return kFieldNullError;
    } /*else if (!adresseValidatorRegExp.hasMatch(_ville)) {
      return kInvalidAdresseError;
    }*/
    else {
      return null;
    }
  }

  String _validPrenom(value) {
    _prenom = value;
    if (_prenom.isEmpty) {
      return kFieldNullError;
    } else if (!nameValidatorRegExp.hasMatch(_prenom)) {
      return kInvalidPrenomError;
    } else {
      return null;
    }
  }

  String _validPhone(value) {
    _phone = value;
    if (_phone.isEmpty) {
      return kFieldNullError;
    } else if (!_checkPwd(_phone)) {
      return kInvalidPhoneError;
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
    loadShared();
  }

  void loadShared() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(getTranslated(context, 'personal_infos')),
        ),
        body: Container(
          child: SettingContainer(
            sections: [
              SettingSection(
                title: getTranslated(context, 'ID'),
                items: [
                  SettingItem(
                    displayValue: Home.currentUser.email,
                    title: getTranslated(context, 'Email address'),
                    onTap: () {
                      /*_showDialog(
                          title: 'Modfier votre adresse E-mail',
                          f: _validEmail,
                          initValue: Home.currentUser.email,
                          hintValue: "Entrez votre adresse E-mail...",
                          labelTxt: "E-mail",
                          textInputType: TextInputType.text,
                          iconData: Icons.email);*/
                    },
                  ),
                  SettingItem(
                    displayValue: DateFormat('dd-MM-yyyy')
                        .format(Home.currentUser.signUpDate),
                    title: getTranslated(context, 'Membre depuis'),
                    onTap: () {},
                  ),
                ],
              ),
              SettingSection(
                title: getTranslated(context, 'Vos informations personnelles'),
                items: [
                  SettingItem(
                    displayValue: Home.currentUser.lastName,
                    title: getTranslated(context, 'lastName'),
                    onTap: () {
                      _showDialog(
                          title: 'Modifier votre nom',
                          f: _validNom,
                          initValue: Home.currentUser.lastName,
                          hintValue: "Entrez votre nom...",
                          labelTxt: "Nom",
                          textInputType: TextInputType.text,
                          iconData: Icons.supervised_user_circle);
                    },
                  ),
                  SettingItem(
                    displayValue: Home.currentUser.firstName,
                    title: getTranslated(context, 'firstName'),
                    onTap: () {
                      _showDialog(
                          title: 'Modfier votre prénom',
                          f: _validPrenom,
                          initValue: Home.currentUser.firstName,
                          hintValue: "Entrez votre prénom...",
                          labelTxt: "Prénom",
                          textInputType: TextInputType.text,
                          iconData: Icons.supervised_user_circle);
                    },
                  ),
                  SettingItem(
                    displayValue: Home.currentUser.address == "null"
                        ? getTranslated(context, 'Non mentioné')
                        : Home.currentUser.address,
                    title: getTranslated(context, 'Adresse'),
                    onTap: () {
                      _showDialog2(
                          title: 'Entrez votre adresse',
                          f: _validVille,
                          initValue: Home.currentUser.address == "null"
                              ? ''
                              : Home.currentUser.address,
                          hintValue: "Tunisia...",
                          labelTxt: "Adresse",
                          textInputType: TextInputType.text,
                          iconData: Icons.location_city_sharp);
                    },
                  ),
                  SettingItem(
                    displayValue: Home.currentUser.phone == "null"
                        ? getTranslated(context, 'Non mentioné')
                        : Home.currentUser.phone,
                    title: getTranslated(context, 'Numéro de téléphone'),
                    onTap: () {
                      _showDialog(
                          title: 'Entrez votre numéro de téléphone',
                          f: _validPhone,
                          initValue: Home.currentUser.phone == "null"
                              ? ''
                              : Home.currentUser.phone,
                          hintValue: "",
                          labelTxt:
                              getTranslated(context, "Numéro de téléphone"),
                          textInputType: TextInputType.phone,
                          iconData: Icons.call);
                    },
                  ),
                  /*SettingItem(
                    displayValue: Home.currentUser.phoneDoctor == "null"
                        ? 'Non mentioné'
                        : Home.currentUser.phoneDoctor,
                    title: 'Numéro de téléphone du médecin',
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
                  ),*/
                ],
              ),
              SettingSection(
                title: getTranslated(context, 'Informations sur votre médecin'),
                items: [
                  SettingItem(
                    title: getTranslated(
                        context, 'Modifier les informations du médecin'),
                    displayValue: '',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MedecinInfo()));
                    },
                  ),
                ],
              ),
              /*SettingSection(
                title: 'Profil',
                items: [
                  SettingItem(
                    displayValue: Home.currentUser.birthDate == null
                        ? 'Non mentioné'
                        : DateFormat('dd-MM-yyyy')
                            .format(Home.currentUser.birthDate),
                    title: 'Date de naissance',
                    onTap: () {},
                  ),
                  SettingItem(
                    displayValue: Home.currentUser.gender == Gender.Homme
                        ? 'Homme'
                        : 'Femme',
                    title: 'Gender',
                    onTap: () {},
                  ),
                  SettingItem(
                    displayValue: Home.currentUser.height == -1.0
                        ? 'Non mentioné'
                        : Home.currentUser.height.toString() + ' (cm)',
                    title: 'Taille',
                    onTap: () {},
                  ),
                  SettingItem(
                    displayValue: Home.currentUser.weight == -1.0
                        ? 'Non mentioné'
                        : Home.currentUser.weight.toString() + ' (kg)',
                    title: 'Poids',
                    onTap: () {},
                  ),
                ],
              ),*/
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
        content: SingleChildScrollView(
          child: Container(
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
                      borderSide:
                          BorderSide(color: Colors.black54, width: 2.0)),
                ),
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

                if (_email != null)
                  setState(() {
                    Home.currentUser.email = _email;
                    sharedPreferences.setString('email', _email);
                  });
                if (_nom != null)
                  setState(() {
                    Home.currentUser.lastName = _nom;
                    sharedPreferences.setString('lastName', _nom);
                  });
                if (_prenom != null)
                  setState(() {
                    Home.currentUser.firstName = _prenom;
                    sharedPreferences.setString('firstName', _prenom);
                  });
                if (_ville != null)
                  setState(() {
                    Home.currentUser.address = _ville;
                    sharedPreferences.setString('address', _ville);
                  });
                if (_phone != null)
                  setState(() {
                    Home.currentUser.phone = _phone;
                    sharedPreferences.setString('phone', _phone);
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController(
      text: Home.currentUser.address == "null" ? '' : Home.currentUser.address);

  String _selectedCity;

  _showDialog2(
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
        title: SingleChildScrollView(
          child: Row(
            children: [
              Expanded(
                  child: Text(
                title,
                style: TextStyle(fontSize: 17),
              )),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.only(top: 0, left: 8, bottom: 0, right: 8),
                  primary: Colors.blue.shade500,
                  // background
                ),
                child: Row(
                  children: [
                    Text(
                      "Ouvrir map ",
                      style: TextStyle(fontSize: 12),
                    ),
                    Icon(
                      Icons.location_on_outlined,
                      size: 15,
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GoogleMapService()))
                      .then((value) {
                    setState(() {
                      if (GoogleMapService.addresse != null) {
                        _typeAheadController.text =
                            GoogleMapService.addresse.addressLine;
                        GoogleMapService.addresse = null;
                      }
                    });
                  });
                },
              )
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: _key,
              child: TypeAheadFormField<Address>(
                debounceDuration: Duration(milliseconds: 500),
                noItemsFoundBuilder: (value) {
                  return Container(
                      height: 30,
                      alignment: Alignment.center,
                      child: Text(
                        'Aucun élément correspondant trouvé',
                        style: TextStyle(
                            color: Colors.grey.shade300, fontSize: 15),
                      ));
                },
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _typeAheadController,
                  keyboardType: textInputType,
                  autofocus: false,
                  maxLength: 300,
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
                        borderSide:
                            BorderSide(color: Colors.black54, width: 2.0)),
                  ),
                ),
                validator: f,
                suggestionsCallback: (pattern) {
                  return BackendService.getSuggestions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion.name),
                  );
                },
                transitionBuilder: (context, suggestionsBox, controller) {
                  return suggestionsBox;
                },
                onSuggestionSelected: (suggestion) {
                  this._typeAheadController.text = suggestion.name;
                  setState(() {
                    _ville = suggestion.name;
                  });
                },
                onSaved: (value) => this._selectedCity = value,
              ),
            ),
          ),
        ),
        actions: [
          SingleChildScrollView(
            child: Row(
              children: [
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

                      if (_email != null)
                        setState(() {
                          Home.currentUser.email = _email;
                          sharedPreferences.setString('email', _email);
                        });
                      if (_nom != null)
                        setState(() {
                          Home.currentUser.lastName = _nom;
                          sharedPreferences.setString('lastName', _nom);
                        });
                      if (_prenom != null)
                        setState(() {
                          Home.currentUser.firstName = _prenom;
                          sharedPreferences.setString('firstName', _prenom);
                        });
                      if (_ville != null)
                        setState(() {
                          Home.currentUser.address = _ville;
                          sharedPreferences.setString('address', _ville);
                        });
                      if (_phone != null)
                        setState(() {
                          Home.currentUser.phone = _phone;
                          sharedPreferences.setString('phone', _phone);
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
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: kPrimaryColor, // background
                  ),
                  child: Text("Annuler"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
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
