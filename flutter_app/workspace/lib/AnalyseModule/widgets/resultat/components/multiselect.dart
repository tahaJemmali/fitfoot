import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workspace/Login/utils/constants.dart';

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;

  final Function(List<String>) onSelectionChanged; // +added
  MultiSelectChip(this.reportList, {this.onSelectionChanged} // +added
      );
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  // String selectedChoice = "";
  // ignore: deprecated_member_use
  List<String> selectedChoices = List();
  bool isArab = false;
  SharedPreferences sharedPreferences;

  Future<void> getShared() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  _buildChoiceList() {
    // ignore: deprecated_member_use
    List<Widget> choices = List();
    widget.reportList.forEach((item) {
      choices.add(Expanded(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              choiceIcon(item),
              SizedBox(
                height: 5,
              ),
              Text(
                tr(item, context),
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ],
          ),
        ),
      ));
    });
    return choices;
  }

  ChoiceChip choiceIcon(String item) {
    return ChoiceChip(
      selectedColor: new Color(0xFF00A19A),
      avatar: avatarek(item),
      padding: pad(isArab),
      labelPadding: EdgeInsets.all(15),
      label: Text(
        "",
        style: TextStyle(fontSize: 15, color: Colors.black),
      ),
      selected: selectedChoices.contains(item),
      onSelected: (selected) {
        setState(() {
          selectedChoices.contains(item)
              ? selectedChoices.remove(item)
              : selectedChoices.add(item);
          widget.onSelectionChanged(selectedChoices);
          // +added
        });
      },
    );
  }

  EdgeInsets pad(bool a) {
    if (a)
      return EdgeInsets.only(right: 20);
    else
      return EdgeInsets.only(left: 24);
  }

  @override
  void initState() {
    super.initState();
    getShared().then((value) {
      if (sharedPreferences != null) {
        if (sharedPreferences.containsKey(LANGUAGE_CODE)) {
          if (sharedPreferences.getString(LANGUAGE_CODE) == ARABE) {
            setState(() {
              isArab = true;
            });
          } else {
            setState(() {
              isArab = false;
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}

String tr(String item, BuildContext c) {
  if (item == "SMS") {
    return getTranslated(c, "smss");
  } else {
    return getTranslated(c, "mmail");
  }
}

CircleAvatar avatarek(String item) {
  if (item == "SMS") {
    return CircleAvatar(
      backgroundImage: AssetImage("lib/AnalyseModule/assets/smslogo.png"),
      radius: 25,
      backgroundColor: Colors.transparent,
    );
  } else {
    return CircleAvatar(
      backgroundImage: AssetImage("lib/AnalyseModule/assets/emaillogo.png"),
      backgroundColor: Colors.transparent,
      radius: 25,
    );
  }
}
