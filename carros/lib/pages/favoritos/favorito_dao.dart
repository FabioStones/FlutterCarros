import 'file:///C:/Users/fabio/AndroidStudioProjects/carros/lib/utils/sql/base_dao.dart';

import 'favorito.dart';

class FavoritoDAO extends BaseDAO<Favorito>{
  @override
  Favorito fromMap(Map<String, dynamic> map) {
    return Favorito.fromMap(map);
  }

  @override
  // TODO: implement tableName
  String get tableName => "favorito";

}