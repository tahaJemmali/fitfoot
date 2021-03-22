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
      backgroundImage: NetworkImage(
          "https://e7.pngegg.com/pngimages/935/611/png-clipart-sms-text-messaging-computer-icons-mobile-phones-sms-icon-text-logo.png"),
      backgroundColor: Colors.transparent,
    );
  } else {
    return CircleAvatar(
      backgroundImage: NetworkImage(
          "https://banner2.cleanpng.com/20180720/ixe/kisspng-computer-icons-email-icon-design-equipo-comercial-5b525b3cdb7d21.311695661532123964899.jpg"),
      backgroundColor: Colors.transparent,
    );
  }
}
