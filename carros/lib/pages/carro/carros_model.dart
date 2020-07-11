import 'package:carros/pages/carro/carro.dart';
import 'package:carros/pages/carro/carros_api.dart';
import 'package:mobx/mobx.dart';

part 'carros_model.g.dart'; //Instrução que define o nome do arquivo.
//Necessário executar na aba Terminal a instrução flutter packages pub run build_runner build
//com ela o arquivo definido no part será criado. Caso faça alteração na classe o comando deve ser
//executado novamente para recriar o arquivo, no caso, carro_model.g.dart

//links
//https://pub.dev/packages/mobx
//https://pub.dev/packages/flutter_mobx
//https://pub.dev/packages/build_runner
//https://pub.dev/packages/mobx_codegen

//Padrão MobX
class CarrosModel = CarrosModelBase with _$CarrosModel;

abstract class CarrosModelBase with Store {
  @observable //Indica que a propriedade está em observação. Quando ela for alterada a classe Observer será executada.
  List<Carro> carros;

  @observable
  Exception error;

  @action //Ação que irá disparar as propriedades que estiverem como @Observable.
  fetch(String tipo) async {
    try {
      error = null;
      this.carros = await CarrosApi.getCarros(tipo);


    } catch(e){
      //Informa a Stream que há um erro
      error = e;
    }
  }

}

