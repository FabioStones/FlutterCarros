import 'dart:async';

import 'package:carros/pages/api_response.dart';
import 'package:carros/pages/carro/home_page.dart';
import 'package:carros/pages/login/login_api.dart';
import 'package:carros/pages/login/login_bloc.dart';
import 'package:carros/pages/login/usuario.dart';
import 'package:carros/utils/alert.dart';
import 'package:carros/utils/nav.dart';
import 'package:carros/widget/app_button.dart';
import 'package:carros/widget/app_text.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //final _streamController = StreamController<bool>();
  final _tLogin = TextEditingController();
  final _tSenha = TextEditingController(/*text: "123"*/);
  final _formKey = GlobalKey<FormState>();
  final _focusSenha = FocusNode();
  final _bloc = LoginBloc();
  //bool _showProgress = false; //Substituído pelo _streamController

  @override
  void initState() {
    super.initState();

    /*//Transferido para a Splash
    Future<Usuario> future = Usuario.get();
    future.then((value) {
      if (value != null) {
        //Voltar a aplicação já logado
        push(context, HomePage(), replace: true);
        //Continua abrindo a tela de login, mas informando o último usuário logado
        //setState(() {_tLogin.text = value.login;});
      }
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //Destroi ou fecha o Listener do Stream.
    //_streamController.close();
    _bloc.dispose();
  }

  _onClickLogin() async {
    String login = _tLogin.text.trim();
    String senha = _tSenha.text;
    //Valida se os campos estão válidos
    if (_formKey.currentState.validate()) {
      //Redesenha a tela
      //Substituído pelo StreamController, pois o SetState recria a tela toda e não é necessário, pois
      //somente o botão é que precisa ser recriado (animação).
      /*setState(() {
        _showProgress = true;
      });*/
      //Envia a informação que a animação deve ser executada
      //_streamController.add(true); //Migra para dentro do BLOC

      print("Login: $login, Senha: $senha");
      //ApiResponse response = await LoginApi.login(login, senha);
      ApiResponse response = await _bloc.login(login, senha);
      if (response.ok) {
        Usuario user = response.result;
        print(">>> $user");
        push(context, HomePage(), replace: true);
      } else {
        alert(context, response.msg);
      }
      //Redesenha a tela
      /*//Explicado acima pq a linha foi comentada
      setState(() {
        _showProgress = false;
      });*/
      //Envia a informação que a animação deve parar
      //_streamController.add(false); Migra para dentro do BLOC
    } else {
      return;
    }
  }

  String _validateLogin(String value) {
    if (value.isEmpty) {
      return "Digite o login!";
    } else {
      return null;
    }
  }

  String _validateSenha(String value) {
    if (value.isEmpty) {
      return "Digite a senha!";
    } else {
      if (value.length < 3) {
        return "A senha precisa ser maior que 3 caracteres!";
      } else {
        return null;
      }
    }
  }

  Widget _body() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carros"),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(16), //Padrão do MaterialDesing
          child: ListView(
            children: <Widget>[
              AppText("Login", "Digite o login", _tLogin,
                  validator: _validateLogin,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  nextFocus: _focusSenha),
              SizedBox(height: 10),
              AppText("Senha", "Digite a senha", _tSenha,
                  validator: _validateSenha,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  focusNode: _focusSenha,
                  password: true),
              SizedBox(height: 20),
              /*AppButton(
              "Login",
              onPressed: _onClickLogin,
              showProgress: _showProgress,
            )*/

              StreamBuilder<bool>(
                stream: _bloc.stream,
                initialData: false,
                //Caso não queira usar o ?? false. Essa propriedade inicializa o Snapshot.data
                builder: (context, snapshot) {
                  return AppButton(
                    "Login",
                    onPressed: _onClickLogin,
                    showProgress: snapshot.data ?? false, //Valor nulo é falso
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
