import 'package:flutter/material.dart';
import 'package:workspace/AnalyseModule/components/size_config.dart';

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final double fontsize;
  final double hei;
  final double wei;
  final Function(List<String>) onSelectionChanged; // +added
  MultiSelectChip(this.reportList, this.fontsize, this.hei, this.wei,
      {this.onSelectionChanged} // +added
      );
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  // String selectedChoice = "";
  List<String> selectedChoices = List();
  _buildChoiceList() {
    List<Widget> choices = List();
    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(5.0),
        child: choiceIcon(item),
      ));
    });
    return choices;
  }

  ChoiceChip choiceIcon(String item) {
    return ChoiceChip(
      selectedColor: new Color(0xFF00A19A),
      avatar: avatarek(item),
      label: Text(
        item,
        style: TextStyle(fontSize: 2.8 * widget.fontsize, color: Colors.black),
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

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}

CircleAvatar avatarek(String item) {
  if (item == "SMS") {
    return CircleAvatar(
      backgroundImage: AssetImage("lib/AnalyseModule/assets/smslogo.png"),
      backgroundColor: Colors.transparent,
    );
  } else {
    return CircleAvatar(
      backgroundImage: AssetImage("lib/AnalyseModule/assets/emaillogo.jpg"),
      backgroundColor: Colors.transparent,
    );
  }
}
