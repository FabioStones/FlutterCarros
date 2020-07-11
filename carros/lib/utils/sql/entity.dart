//Classe mãe para que a classe base_dao possa chamar o método ToJson
abstract class Entity {
  Map<String, dynamic> toMap();
}