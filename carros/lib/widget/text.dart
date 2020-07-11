import 'package:flutter/material.dart';

Text text(String msg,
    {double fontSize = 16, color = Colors.black, bold = false}) {
  return Text(msg ?? "", style: TextStyle(fontSize: fontSize,
      color: color,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal),);
}