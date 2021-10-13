import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyLocalisation {
  final Locale locale;
  MyLocalisation(this.locale);

    static MyLocalisation of(BuildContext context) {
    return Localizations.of<MyLocalisation>(context, MyLocalisation);
  }

  Map<String,String> _localizedValues;

  Future load()async{
    String jsonStringValues = await rootBundle.loadString('lib/Languages/Lang/${locale.languageCode}.json');

    Map<String,dynamic> mappedJson = json.decode(jsonStringValues);

    _localizedValues = mappedJson.map((key, value) => MapEntry(key, value.toString()));
  } 

  String getTranslatedValue(String key){
    return _localizedValues[key];
  }

//
static const LocalizationsDelegate<MyLocalisation> delegate = _MyLocalisationDelegate();
}

class _MyLocalisationDelegate extends LocalizationsDelegate<MyLocalisation>{

const _MyLocalisationDelegate();

  @override
  bool isSupported(Locale locale) {
      return ['en','fr','ar'].contains(locale.languageCode);
    }
  
    @override
    Future<MyLocalisation> load(Locale locale) async {
      MyLocalisation myLocalisation = new MyLocalisation(locale);
      await myLocalisation.load();
      return myLocalisation;
    }
  
    @override
    bool shouldReload(_MyLocalisationDelegate old) => false;
  }
  
