import 'package:carros/pages/api_response.dart';
import 'package:carros/pages/carro/carro.dart';
import 'package:carros/pages/carro/carro_form_page.dart';
import 'package:carros/pages/carro/carros_api.dart';
import 'package:carros/pages/carro/loripsum_api.dart';
import 'package:carros/pages/favoritos/favorito_service.dart';
import 'package:carros/utils/alert.dart';
import 'package:carros/utils/nav.dart';
import 'package:carros/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CarroPage extends StatefulWidget {
  Carro carro;

  CarroPage(this.carro);

  @override
  _CarroPageState createState() => _CarroPageState();
}

class _CarroPageState extends State<CarroPage> {
  final _loripsumBloc = LoripsumBloc();

  Carro get carro => widget.carro;
  Color color = Colors.grey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loripsumBloc.fetch();

    FavoritoServive.isFavorito(carro).then((value) {
      setState(() {
        color = value ? Colors.red : Colors.grey;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _loripsumBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("build executado");
    //No Android Studio para criar templates acesse: File/ Settings/ Editor/ Live Templates/ Flutter
    // Clique no botão + para incluir um novo template.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.carro.nome),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.place),
            onPressed: _onClickMapa,
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: _onClickVideo,
          ),
          PopupMenuButton<String>(
            onSelected: _onClickPopupMenu,
            //onSelected: (String value) => _onClickPopupMenu(value),
            //Pode ser escrito tb >> onSelected: _onClickPopupMenu
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: "Editar",
                  child: Text("Editar"),
                ),
                PopupMenuItem(
                  value: "Deletar",
                  child: Text("Deletar"),
                ),
                PopupMenuItem(
                  value: "Share",
                  child: Text("Share"),
                ),
              ];
            },
          )
        ],
      ),
      body: _body(),
    );
  }

  _body() {
    return Container(
      padding: EdgeInsets.all(16),
      child: ListView(
        children: <Widget>[
          _foto(),
          _bloco1(),
          Divider(),
          _bloco2(),
        ],
      ),
    );
  }

  Row _bloco1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //Espaçamento entre o texto e os ícones
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            text(widget.carro.nome, fontSize: 20, bold: true),
            text(widget.carro.tipo, fontSize: 16),
          ],
        ),
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.favorite,
                color: color,
                size: 40,
              ),
              onPressed: _onClickFavorite,
            ),
            IconButton(
              icon: Icon(Icons.share, size: 40),
              onPressed: _onClickShare,
            ),
          ],
        )
      ],
    );
  }

  void _onClickMapa() {}

  void _onClickVideo() {}

  _onClickPopupMenu(String value) {
    switch (value) {
      case "Editar":
        push(context, CarroFormPage(carro: carro));
        break;
      case "Deletar":
        deletar();
        break;
      case "Share":
        print("Share!!!");
        break;
    }
  }

  void _onClickFavorite() async {
    bool value = await FavoritoServive.favoritar(carro);
    //Refresh da tela
    setState(() {
      color = value ? Colors.red : Colors.grey;
    });
  }

  void _onClickShare() {}

  _bloco2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        text(widget.carro.descricao, bold: true),
        SizedBox(
          height: 20,
        ),
        StreamBuilder(
          stream: _loripsumBloc.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return text(snapshot.data);
          },
        ),
      ],
    );
  }

  _foto() {
    return widget.carro.urlFoto != null
        ? CachedNetworkImage(
            imageUrl: widget.carro.urlFoto,
            height: 150,
          )
        : Image.asset(
            "assets/images/camera.png",
            height: 150,
          );
  }

  Future<void> deletar() async {
    ApiResponse<bool> response = await CarrosApi.delete(carro);
    if (response.ok) {
      print("ok");
      alert(context, "Carro apagado com sucesso!", callBack: () {
        pop(context);
      });
    } else {
      print("erro");
      alert(context, response.msg);
    }
  }
}
