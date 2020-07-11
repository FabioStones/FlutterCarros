import 'package:carros/drawer_list.dart';
import 'package:carros/pages/carro/carro_form_page.dart';
import 'package:carros/pages/carro/carros_api.dart';
import 'package:carros/pages/carro/carros_page.dart';
import 'package:carros/pages/favoritos/favoritos_page.dart';
import 'package:carros/utils/nav.dart';
import 'package:carros/utils/prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'carro.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

//Para evitar acesso desnecessário a cada troca de aba, é necessário converter para StatefulWidget a home_page.dart
//e a carros_listview.dart. Além disso é necessário adicionar a classe SingleTickerProviderStateMixin. Em cada
//chamada da TabBarView (no caso é a CarrosListView, mas se fosse uma diferente da outra deveria se aplicado a todas)
//deve ser adicionado a classe AutomaticKeepAliveClientMixin. O Getter wantKeepAlive deve ser definido como TRUE.
class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin<HomePage> {
  //Propriedades
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /*Essa é uma forma de trabalhar com Future sem usar async ... await
    _tabController = TabController(length: 3, vsync: this);

    //Programação Assincrona - Como o Prefs retorna um Future, pois não sabemos o tempo que levará para buscar as informações do arquivo.
    Future<int> future = Prefs.getInt("tabIdx");
    future.then((int value) => _tabController.index = value);

    _tabController.addListener(() {Prefs.setInt("tabIdx", _tabController.index);});*/

    //Dessa forma o método InitState fica mais limpo e as inicializações ficam "categorizadas"
    _initTabs();
  }

  void _initTabs() async {
    // Primeiro busca o índice nas prefs.
    int tabIdx = await Prefs.getInt("tabIdx");

    // Depois cria o TabController
    // No método build na primeira vez ele poderá estar nulo
    _tabController = TabController(length: 4, vsync: this);

    // Agora que temos o TabController e o índice da tab,
    // chama o setState para redesenhar a tela
    setState(() {
      _tabController.index = tabIdx;
    });

    _tabController.addListener(() {
      Prefs.setInt("tabIdx", _tabController.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carros"),
        bottom: _tabController == null
            ? null
            : TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    text: "Clássicos",
                  ),
                  Tab(
                    text: "Esportivos",
                  ),
                  Tab(
                    text: "Luxo",
                  ),
                  Tab(
                    text: "Favoritos",
                  )
                ],
              ),
      ),
      body: _tabController == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                CarrosPage(TipoCarro.classicos),
                CarrosPage(TipoCarro.esportivos),
                CarrosPage(TipoCarro.luxo),
                FavoritosPage()
              ],
            ),
      drawer: DrawerList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _onClickAdicionarCarro,
      ),
    );
  }

  void _onClickAdicionarCarro() {
    push(context, CarroFormPage());
  }
}
