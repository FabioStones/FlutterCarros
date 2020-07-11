import 'package:carros/pages/carro/carro.dart';
import 'package:carros/pages/carro/carro_dao.dart';
import 'package:carros/pages/favoritos/favorito.dart';
import 'package:carros/pages/favoritos/favorito_dao.dart';

class FavoritoServive{
  static Future<bool> favoritar(Carro c) async{
    final dao = FavoritoDAO();
    //Verifica se existe
    if (await dao.exists(c.id)){
      //Apaga
      dao.delete(c.id);
      return false;
    } else {
      //Insere
      dao.save(Favorito.fromCarro(c));
      return true;
    }
  }

  static Future<List<Carro>> getCarros() async {
    return await CarroDAO().query("select * from carro c, favorito f where c.id = f.id");
  }

  static Future<bool> isFavorito(Carro c) async {
    return await FavoritoDAO().exists(c.id);
  }

}