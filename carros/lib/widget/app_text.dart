import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  String label;
  String hint;
  TextEditingController controller;
  TextInputType keyboardType;
  TextInputAction textInputAction;
  FocusNode focusNode;
  FocusNode nextFocus;
  bool password;
  FormFieldValidator<String> validator;

  AppText(
    this.label,
    this.hint,
    this.controller, {
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.nextFocus,
    this.password = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: password,
      //Não mostra a informação
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      focusNode: focusNode,
      onFieldSubmitted: (String text) {
        if (FocusNode != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        }
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        labelText: label,
        labelStyle: TextStyle(fontSize: 25, color: Colors.grey),
        hintText: hint,
        hintStyle: TextStyle(fontSize: 16, color: Colors.blue),
      ),
    );
    ;
  }
}
