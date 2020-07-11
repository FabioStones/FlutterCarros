import 'package:carros/utils/prefs.dart';
import 'dart:convert' as convert;

class Usuario {
  int id;
  String login;
  String nome;
  String email;
  String urlFoto;
  String token;
  List<String> roles;

  Usuario(
      {this.id,
        this.login,
        this.nome,
        this.email,
        this.urlFoto,
        this.token,
        this.roles});

  //Construtor nomeado ("Name de Constructor").
  // Utiliza-se : ao invés de {} quando deseja-se somente inicializar os parâmetros.
  // Neste caso ; será somente na última linha, nas demais usa-se ,
  Usuario.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    login = json['login'];
    nome = json['nome'];
    email = json['email'];
    urlFoto = json['urlFoto'];
    token = json['token'];
    roles = json['roles'].cast<String>();
    //A opção acima é uma forma mais simplificada se fazer o que foi feito abaixo.
    //A diferença é que estamos usando um If ternário para validar se é nulo.
    //roles = map["roles"] != null
    //    ? map["roles"].map<String>((role) => role.toString()).toList()
    //    : null; // If ternário >> Condição ? Então : Senão

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['login'] = this.login;
    data['nome'] = this.nome;
    data['email'] = this.email;
    data['urlFoto'] = this.urlFoto;
    data['token'] = this.token;
    data['roles'] = this.roles;
    return data;
  }

  void save() {
    Prefs.setString("user.prefs", convert.json.encode(toJson()));
  }

  static Future<Usuario> get() async{
    var result;
    String json = await Prefs.getString("user.prefs");
    if (!json.isEmpty){
      result = Usuario.fromJson(convert.json.decode(json));
    }else{
      result = null;
    }
    return result;
  }

  static void clear() {
    Prefs.setString("user.prefs", "");
  }
}