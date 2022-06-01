import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ProfileButton extends StatelessWidget {
  final Function()? function;
  final String text;
  final Color borderColor;
  final Color color;
  const ProfileButton(
      {Key? key,
      this.function,
      required this.text,
      required this.borderColor,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor;
    color == Colors.white ? textColor = Colors.black : textColor = Colors.white;
    return TextButton(
      onPressed: function,
      child: Container(
        decoration: BoxDecoration(
            color: color,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(5)),
        alignment: Alignment.center,
        width: 250,
        height: 25,
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
