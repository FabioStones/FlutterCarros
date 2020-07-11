import 'dart:async';

import 'package:carros/pages/carro/carros_bloc.dart';
import 'package:carros/pages/carro/carro.dart';
import 'package:carros/pages/carro/carro_page.dart';
import 'package:carros/pages/carro/carros_listview.dart';
import 'package:carros/pages/favoritos/favoritos_bloc.dart';
import 'package:carros/utils/nav.dart';
import 'package:carros/utils/text_error.dart';
import 'package:flutter/material.dart';

class FavoritosPage extends StatefulWidget {
  @override
  _FavoritosPageState createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage>
    with AutomaticKeepAliveClientMixin<FavoritosPage> {
  List<Carro> carros;

  final _bloc = FavoritosBloc();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //Padrão Bloc
    _bloc.fetch();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _body();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //Destroi ou fecha o Listener do Stream.
    _bloc.dispose();
  }

  _body() {
    return StreamBuilder(
      stream: _bloc.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return TextError("Não foi possível buscar os favoritos\n\nClique aqui para tentar novamente.", onPressed: _fetch,);
        }

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        List<Carro> carros = snapshot.data;
        return RefreshIndicator(
            onRefresh: _onRefresh,
            child: CarrosListView(carros));
      },
    );
  }

  _fetch() {
    //Refaz a busca
    _bloc.fetch();
  }

  Future<void> _onRefresh() {
    return _bloc.fetch();
  }
}
