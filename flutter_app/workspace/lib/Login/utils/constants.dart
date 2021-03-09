import 'package:flutter/material.dart';

//const kPrimaryColor = Color(0xFFFF7643);
//const kPrimaryColor = Colors.blue;
const kPrimaryColor = Color(0xFF00A19A);
const kPrimaryLightColor = Color(0xFFFFECDF);
/*const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);*/
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: (28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const String Url = "10.0.2.2:34000";

const defaultDuration = Duration(milliseconds: 250);

// Form RegExp
final RegExp emailValidatorRegExp = RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$");
final RegExp nameValidatorRegExp = RegExp(r"^[a-zA-Z\s]*$");
final RegExp addressValidatorRegExp = RegExp(r"^[\p{L} .'-]+$");

// Form Error Null
const String kNomNullError = "Le champ nom est obligatoire *";
const String kPrenomNullError = "Le champ prenom est obligatoire *";
const String kEmailNullError = "Le champ email est obligatoire *";
const String kPasswordNullError = "Le champ mot de passe est obligatoire *";

// Form Error Invalid
const String kInvalidNomError = "Nom invalide";
const String kInvalidPrenomError = "Prenom invalide";
const String kInvalidEmailError = "Adresse email invalide";

// Form Error Password
const String kLongPassError = "Le mot de passe est trop long";
const String kShortPassError = "Le mot de passe est trop court";
const String kMatchPassError = "Les mots de passe ne correspondent pas";



final otpInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: (15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular((15)),
    borderSide: BorderSide(color: kTextColor),
  );
}
