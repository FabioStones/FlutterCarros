//Padrão Bloc
import 'dart:async';

import 'package:carros/utils/simple_bloc.dart';
import 'package:http/http.dart' as http;

//Conceito BLoC >> Business Logic Component.
class LoripsumBloc extends SimpleBloc<String> {
  static String cache; //Cache para evitar buscas desnecessárias.

  fetch() async {
    try {
      String value = cache ?? await LoripsumApi.getLoripsum();
      cache = value;

      add(value);
    } catch(e){
      //Informa a Stream que há um erro
      addError(e);
    }
  }

}

class LoripsumApi {
  static Future<String> getLoripsum() async{
    var response = await http.get("https://loripsum.net/api");
    return response.body.replaceAll("<p>", "").replaceAll("</p>", "");
  }
}