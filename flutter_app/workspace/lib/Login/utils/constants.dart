import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workspace/Languages/my_localization.dart';

//const kPrimaryColor = Color(0xFFFF7643);
//const kPrimaryColor = Colors.blue;
const kPrimaryColor = Color(0xFF00A19A);
const kLightGrey = Color(0xFFF3F3F3);
const kLightGrey4 = Color(0xF0F6F6F6);
const kGreenVFVSC = Color(0xFF4EC9B0);
const kGrey = Color(0xF0999DA0);
const kGrey2 = Color(0xF0D9DDDC);
const kGrey3 = Color(0xFF808D88);
const kPrimaryLightColor = Color(0xFFFFECDF);
/*const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);*/
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);
//Form Empty
const String kFieldNullError = "ce champ ne peut pas être vide *";
const String kPhoneNullError = "Ce champ est obligatoire *";
const String kInvalidPhoneError = "Numéro de téléphone invalide";
const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: (28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

//docker image put your local host adress
//const String Url = "192.168.1.30:54001";
//ip taha
//const String Url = "192.168.1.10:34000";
//ip fahd
//const String Url = "192.168.1.219:34000";
//ip firas
//const String Url = "192.168.1.219:34000";

//const String Url = "172.16.186.44:34000";
//const String Url = "10.0.2.2:34000";
String Url = "192.168.1.10:54001";

//DateFormat
const kkdateFormat = 'yyyy-MM-dd hh:mm:ss';

const defaultDuration = Duration(milliseconds: 250);

//Gender enum
enum Gender { Homme, Femme }

// Form RegExp
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$");
final RegExp nameValidatorRegExp = RegExp(r"^[a-zA-Z\s]*$");
final RegExp adresseValidatorRegExp = RegExp(r"^[a-zA-Z\s]*$");
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
const String kInvalidAdresseError = "Adresse invalide";

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

//LANG
const String ENGLISH = 'en';
const String FRENCH = 'fr';
const String ARABE = 'ar';

String getTranslated(BuildContext context, String key) {
  return MyLocalisation.of(context).getTranslatedValue(key);
}

const String LANGUAGE_CODE = 'languageCode';

Locale _locale(String languageCode) {
  Locale _temp;
  switch (languageCode) {
    case ENGLISH:
      _temp = Locale(languageCode, 'US');
      break;
    case FRENCH:
      _temp = Locale(languageCode, 'FR');
      break;
    case ARABE:
      _temp = Locale(languageCode, 'TN');
      break;
    default:
      _temp = Locale(ENGLISH, 'US');
      break;
  }
  return _temp;
}

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  _prefs.setString(LANGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String langC = _prefs.getString(LANGUAGE_CODE) ?? FRENCH;
  return _locale(langC);
}
