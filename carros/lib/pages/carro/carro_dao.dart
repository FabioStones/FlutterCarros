import 'dart:async';

import 'package:carros/pages/carro/carro.dart';
import 'package:carros/utils/sql/base_dao.dart';

// Data Access Object
class CarroDAO extends BaseDAO<Carro>{
  @override
  // TODO: implement tableName
  String get tableName => "carro";

  @override
  Carro fromMap(Map<String, dynamic> map) {
    return Carro.fromMap(map);
  }

  Future<List<Carro>> findAllByTipo(String tipo) {
    return query('select * from $tableName where tipo =? ',[tipo]);
  }
}
