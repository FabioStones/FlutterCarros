import 'dart:io';

import 'package:carros/pages/api_response.dart';
import 'package:carros/pages/carro/carro.dart';
import 'package:carros/pages/carro/upload_api.dart';
import 'dart:convert';
import 'package:carros/utils/http_helper.dart' as http;

/*Não foi usado, pois não tem a opção para retornar somente o nome sem o nome da classe
enum TipoCarro{
  classicos,
  esportivos,
  luxo
}*/

class TipoCarro {
  static final String classicos = "classicos";
  static final String esportivos = "esportivos";
  static final String luxo = "luxo";
}

class CarrosApi {
  static Future<List<Carro>> getCarros(String tipo) async {
    //String tipoCarro = tipo.toString().replaceAll("TipoCarro.", "");
    var url = 'https://carros-springboot.herokuapp.com/api/v2/carros/tipo/$tipo';
    var response = await http.get(url);
    List list = json.decode(response.body);
    final carros = list.map<Carro>((map) => Carro.fromMap(map)).toList();

    /* A expressão abaixo é substituída pela expressão acima
    for (Map map in list) {
      Carro c = Carro.fromJson(map);
      carros.add(c);
    }*/

    return carros;
  }

  static Future<ApiResponse<bool>> save(Carro c, File file) async {
    try {
      if (file != null){
        ApiResponse<String> response = await UploadApi.upload(file);
        if (response.ok) {
          c.urlFoto = response.result;
        }
      }

      var url = 'https://carros-springboot.herokuapp.com/api/v2/carros${c.id != null ? '/${c.id}' : ''}';

      print("POST > $url");

      var response = await (c.id == null
          ? http.post(url, body: c.toJson())
          : http.put(url, body: c.toJson()));

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      Map mapResponse = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Carro carro = Carro.fromMap(mapResponse);
        print("Novo Carro: ${carro.id}");

        return ApiResponse.ok(true);
      } else {
        if (response.body == null || response.body.isEmpty) {
          return ApiResponse.error("Não foi possível salvar o carro!");
        }
      }

      return ApiResponse.error(
          mapResponse["error"] ?? "Não foi possível salvar o carro!");
    } catch (e) {
      print(e);
      return ApiResponse.error("Não foi possível salvar o carro!");
    }
  }

  static delete(Carro c) async {
    try {
      var url = 'https://carros-springboot.herokuapp.com/api/v2/carros${c.id != null ? '/${c.id}' : ''}';

      print("Delete > $url");

      var response = await http.delete(url);

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return ApiResponse.ok(true);
      } else {
        return ApiResponse.error("Não foi possível apagar o carro!");
      }
    } catch (e) {
      print(e);
      return ApiResponse.error("Não foi possível apagar o carro!");
    }

  }
}
