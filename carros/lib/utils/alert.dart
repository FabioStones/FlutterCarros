import 'package:flutter/material.dart';

void alert(BuildContext context, String msg, {Function callBack}) {
  showDialog(
    context: context,
    barrierDismissible: false, //Impede que a janela feche se clicar fora dela
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        //Impede que o botão voltar (Android) consiga fechar
        child: AlertDialog(
            title: Text("Carros"),
            content: Text(msg),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  //Necessário para Fechar a tela do ShowDialog
                  Navigator.pop(context);
                  if (callBack != null){
                    callBack();
                  }
                },
              )
            ]),
      );
    },
  );
}
