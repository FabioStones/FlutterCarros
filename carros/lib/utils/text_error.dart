import 'package:flutter/material.dart';
/*Classe genérica para mostrar a mensagem de erro de forma padrão a todas as listas que existirem.*/
class TextError extends StatelessWidget {
  String msg;

  Function onPressed;

  TextError(this.msg, {this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: GestureDetector(
          onTap: onPressed,
          child: Text(
            msg,
            style: TextStyle(color: Colors.red, fontSize: 22),
          ),
        ));
  }
}
