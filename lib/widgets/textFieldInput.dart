import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final TextInputType textInputType;
  final bool isPass;

  const TextFieldInput(
      {Key? key,
      required this.textEditingController,
      required this.hintText,
      required this.textInputType,
      this.isPass = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
          border: inputBorder,
          focusedBorder: inputBorder,
          hintText: hintText,
          enabledBorder: inputBorder,
          filled: true,
          contentPadding: EdgeInsets.all(8)),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
