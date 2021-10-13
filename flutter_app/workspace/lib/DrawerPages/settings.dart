import 'package:clean_settings_nnbd/clean_settings_nnbd.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workspace/AnalyseModule/classes/Static.dart';
import 'package:workspace/Languages/my_localization.dart';
import 'package:workspace/Login/sign_in.dart';
import 'package:workspace/Login/utils/constants.dart';
import 'package:workspace/Login/utils/language.dart';
import 'package:workspace/main.dart';
import 'Settings/personal_info.dart';
import 'home.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int counter = 0;
  String langue = 'Français';
  bool disableDemoItems = false;
  //bool smartCompose = true;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    if (Statis.notif == null) {
      Statis.notif = true;
    }
    loadShared().then((value) {
      if (sharedPreferences.containsKey(LANGUAGE_CODE))
        switch (sharedPreferences.get(LANGUAGE_CODE)) {
          case ENGLISH:
            setState(() {
              langue = "English";
            });
            break;
          case FRENCH:
            setState(() {
              langue = "Français";
            });
            break;
          case ARABE:
            setState(() {
              langue = "العربية";
            });
            break;
        }
    });
  }

  Future<void> loadShared() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  void _changeLanguage(MyLanguage language) async {
    Locale _temp = await setLocale(language.languageCode);
    if (language.languageCode == ARABE) {
      setState(() {
        Home.drawerDirection = false;
      });
    } else {
      Home.drawerDirection = true;
    }
    //print(_temp.countryCode);
    MyApp.setLocale(context, _temp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'settings_title_page')),
      ),
      body: Container(
        child: SettingContainer(
          sections: [
            SettingSection(
              title: getTranslated(context, 'personal_infos'),
              items: [
                SettingItem(
                  title: getTranslated(context, 'modif_personal_infos'),
                  displayValue: '@' + Home.currentUser.email,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PersonalInfo()));
                  },
                ),
              ],
            ),
            SettingSection(
              title: getTranslated(context, 'prefs'),
              items: [
                SettingSwitchItem(
                  title: getTranslated(context, 'notifs'),
                  value: Statis.notif,
                  onChanged: (v) => setState(() => Statis.notif = v),
                  description: Statis.notif
                      ? getTranslated(context, 'on')
                      : getTranslated(context, 'off'),
                ),
              ],
            ),
            SettingSection(
              title: getTranslated(context, 'general'),
              items: [
                SettingRadioItem<String>(
                  cancelText: getTranslated(context, 'cancel'),
                  title: getTranslated(context, 'language'),
                  displayValue: '$langue',
                  selectedValue: langue,
                  items: [
                    SettingRadioValue('English', 'English'),
                    SettingRadioValue('Français', 'Français'),
                    SettingRadioValue('العربية', 'العربية'),
                  ],
                  onChanged: (v) {
                    switch (v) {
                      case 'English':
                        _changeLanguage(MyLanguage.languageList()[0]);
                        break;
                      case 'Français':
                        _changeLanguage(MyLanguage.languageList()[1]);
                        break;
                      case 'العربية':
                        _changeLanguage(MyLanguage.languageList()[2]);
                        break;
                      default:
                        _changeLanguage(MyLanguage.languageList()[0]);
                        break;
                    }

                    setState(() => langue = v);
                  },
                  priority: disableDemoItems
                      ? ItemPriority.disabled
                      : ItemPriority.normal,
                ),
                SettingItem(
                  title: getTranslated(context, 'logout'),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(getTranslated(context, 'logout')),
                            content:
                                Text(getTranslated(context, 'logout_confirm')),
                            actions: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: kPrimaryColor, // background
                                ),
                                child: Text(
                                    getTranslated(context, 'confirm_logout')),
                                onPressed: () {
                                  String l =
                                      sharedPreferences.get(LANGUAGE_CODE);
                                  sharedPreferences.clear();
                                  sharedPreferences.setString(LANGUAGE_CODE, l);
                                  Navigator.popUntil(
                                      context, (route) => route.isFirst);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignIn(),
                                    ),
                                  );
                                },
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: kPrimaryColor, // background
                                ),
                                child: Text(getTranslated(context, 'cancel')),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        });
                  },
                ),
              ],
            ),
            SettingSection(
              title: getTranslated(context, 'app_info'),
              items: [
                SettingItem(
                  title: getTranslated(context, 'version'),
                  displayValue: '1.0.0',
                  onTap: () {},
                ),
                SettingItem(
                  title: getTranslated(context, 'about_us'),
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
