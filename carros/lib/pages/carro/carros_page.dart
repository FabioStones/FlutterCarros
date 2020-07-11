import 'dart:async';

import 'package:carros/pages/carro/carros_bloc.dart';
import 'package:carros/pages/carro/carro.dart';
import 'package:carros/pages/carro/carro_page.dart';
import 'package:carros/pages/carro/carros_listview.dart';
import 'package:carros/utils/nav.dart';
import 'package:carros/utils/text_error.dart';
import 'package:flutter/material.dart';
//import 'package:carros/pages/carro/carros_model.dart';
//import 'package:flutter_mobx/flutter_mobx.dart';

class CarrosPage extends StatefulWidget {
  String tipo;

  CarrosPage(this.tipo);

  @override
  _CarrosPageState createState() => _CarrosPageState();
}

class _CarrosPageState extends State<CarrosPage>
    with AutomaticKeepAliveClientMixin<CarrosPage> {
  List<Carro> carros;

  //final _streamController = StreamController<List<Carro>>();
  final _bloc = CarrosBloc(); //Substitui o _StreamController quando usa-se o conceito BLOC.
  //Padrão Mobx
  //final _model = CarroModel();

  String get tipo =>
      widget.tipo; //Quando não se quer utilizar a sintaxe widget.tipo.

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Local mais apropriado para fazer a requisição ao BD.
/*  Future<List<Carro>> future = CarrosApi.getCarros(widget.tipo);
    future.then((List<Carro> values){
    });*/
    //Outra opção é criar um método LoadData e tratar o Future como Async .. Await dentro dela.
    //Detalhe, não dá para fazer isso aqui, pois o retorno da InitState é void e não Future de Carros.
    //_loadData()
    //Padrão Bloc
    _bloc.fetch(tipo);
    //Padrão Mobx
    //_model.fetch(tipo);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); //Obrigatório para o WantKeepAlive funcionar
    //Evite colocar as requisições a banco de dados aqui, pois o Flutter chama várias
    //vezes os métodos Build. Por exemplo, na tela principal quando abre uma segunda tela
    //tanto o Build da 2º quanto da 1º são executados. Use o InitState para fazer a requisição
    // ao banco de dados. Isso somente é possível por causa do StatefulWidget.
    return _body();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //Destroi ou fecha o Listener do Stream.
    //_streamController.close()
    _bloc.dispose();
    //Mobx não precisa fazer Dispose!!!
  }

  _body() {
    //StreamBuilder é um listener que aguarda ser chamado. A chamada ocorre tanto na
    // chamada do método _body quanto no método _LoadData.
    // O uso de Streams é também conhecido como programação reativa "ReactiveX" (http://reactivex.io)
    // onde é feito uma programação assincrona através de Streams observáveis.
    //Padrão Bloc
    return StreamBuilder(
      stream: _bloc.stream, //Antigo >> stream: _streamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return TextError("Não foi possível buscar os carros\n\nClique aqui para tentar novamente.", onPressed: _fetch,);
        }

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        List<Carro> carros = snapshot.data;
        return RefreshIndicator( //Cria a animação que ao arrastar para baixo o refresh é feito.
            onRefresh: _onRefresh,
            child: CarrosListView(carros));
      },
    );
    //Padrão Mobx
    //A Classe Observer faz o mesmo que a StreamBuilder
    /*return Observer(
      builder: (context) {
        List<Carro> carros = _model.carros;

        if (_model.error != null) {
          print(_model.error);
          return TextError(
            "Não foi possível buscar os carros\n\nClique aqui para tentar novamente.",
            onPressed: _fetch,
          );
        }

        if (_model.carros == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return _listView(carros);
      },
    );*/
  }


  /*No padrão Bloc esse método é tranferido para dentro da classe bloc.
  _loadData() async {
    List<Carro> values = await CarrosApi.getCarros(widget.tipo);
    //Com o uso do StreamController não é mais necessário o uso do SetState'
    /*setState(() {
      this.carros = values;
    });*/
    //Isso fará com que a classe StreamBuilder, dentro do método _body, seja executada.
    //vale ressaltar que somente o que está na propriedade Builder será executado.
    //O uso do SetState fará com que TODA a tela seja recriada e não só uma parte como
    //ocorre usando o StreamController.
    //_streamController.sink.add(values);
    _streamController.add(values); //Forma simplificada da linha acima.
  }*/

  _fetch() {
    //Refaz a busca
    _bloc.fetch(tipo);
    //_model.fetch(tipo);
  }

  Future<void> _onRefresh() {
    return _bloc.fetch(tipo);
  }
}
