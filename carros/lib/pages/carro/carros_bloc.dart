//Padrão Bloc
import 'dart:async';

import 'package:carros/utils/simple_bloc.dart';
import 'package:carros/pages/carro/carro.dart';
import 'package:carros/pages/carro/carros_api.dart';
import 'package:carros/pages/carro/carro_dao.dart';
import 'package:carros/utils/network.dart';

//Conceito BLoC >> Business Logic Component.
class CarrosBloc extends SimpleBloc<List<Carro>> {

  Future<List<Carro>> fetch(String tipo) async {
    try {
      final dao = CarroDAO();
      List<Carro> values;

      //Verifica se há internet
      if (! await isNetworkOn()){
        values = await dao.findAllByTipo(tipo);
      } else {
        values = await CarrosApi.getCarros(tipo);
        //Verifica se recuperou valores
        if (values.isNotEmpty) {
          //Salvar todos os carros no banco de dados
          /*for (Carro c in carros) { dao.save(c); }*/
          //Forma mais resumida de escrever o For...
          //carros.forEach((c) => dao.save(c));
          //Como o método Save recebe o mesmo parâmetro entregue pelo método forEach dá para resumir mais.
          values.forEach(dao.save);
        }
      }
      //Atualiza a Stream
      add(values);
      return values;

    } catch(e){
      //Informa a Stream que há um erro
      addError(e);
    }
  }

}
