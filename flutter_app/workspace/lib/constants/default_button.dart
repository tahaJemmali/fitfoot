import 'package:flutter/material.dart';

import 'constants.dart';

class DefaultButton2 extends StatelessWidget {
  const DefaultButton2({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 30;
    return SizedBox(
      width: width,
      height: 56,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: kPrimaryColor,
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
