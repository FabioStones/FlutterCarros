import 'package:carros/pages/carro/home_page.dart';
import 'file:///C:/Users/fabio/AndroidStudioProjects/carros/lib/utils/sql/db_helper.dart';
import 'package:carros/pages/login/login_page.dart';
import 'package:carros/pages/login/usuario.dart';
import 'package:carros/utils/nav.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    //Inicializa as variáveis
    Future database = DatabaseHelper.getInstance().db; //Inicializa o banco de dados
    Future waiting = Future.delayed(Duration(seconds: 3)); //Timer de 3 segundos
    Future<Usuario> user = Usuario.get();
    /*                               ATENÇÃO
    *  Cuidado se a aplicação demorar muito para carregar. Neste caso, use
    *  barra de progresso ou mensagens para que o usuário não pense que a sua
    *  rotina tem um bug e não abre.*/

    //Aguarda a execução de todos os futures
    Future.wait([database, waiting, user]).then((List values){
      //imprime os retornos dos Futures
      print(values);

      //Verifica se a Future "user" retornou um usuário. (Array começa em ZERO)
      if (values[2] != null){
        //Voltar a aplicação já logado
        push(context, HomePage(), replace: true);
      } else {
        //Abre a tela de login
        push(context, LoginPage(), replace: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[200], //O 200 é um gradiente da cor azul
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}