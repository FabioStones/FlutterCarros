import 'dart:async';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//Para visualizar o banco de dados do SmartPhone ou do Emulador
//https://sqlitebrowser.org/
//Ao contrário do IPhone, onde é possível acessar o bd de forma on-line, no Android não.
//neste caso é necessárop acessar a máquina virtual. Para isso clique em "Device File Explorer"
//dentro do Android Studio. Com o caminho exposto no console é possível acessar o arquivo .db do
//banco de dados (Ex: /data/user/0/com.lechetaaula.carros/databases/carros.db).
//Caso não apareça clique com o botão direito e selecione "Synchronize".
//Para copiar clique no arquivo com o botão direito e selecione "Save as".
class DatabaseHelper {
  //SingleTon - O nome GetInstance é somente uma convenção. Não é necessário ser esse nome
  static final DatabaseHelper _instance = DatabaseHelper.getInstance();
  DatabaseHelper.getInstance(); //Cria o método do tipo Name de Constructor
  //Construtor da classe que retorna a constante (final) e "imortal" (static)
  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    return _db != null ? _db : _db = await _initDb();
  }

  Future _initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'carros.db');
    print("db $path");

    //Destroi o banco a cada inicialização -- Somente Desenvolvimento.
    //deleteDatabase(path);

    //A versão (Version) é utilizada para indicar uma mudança na estrutura do banco de dados.
    //Neste caso o método onUpgrade será chamado
    return await openDatabase(path, version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  //Método chamado uma única vez quando o banco não existir.
  void _onCreate(Database db, int newVersion) async {
    String s = await rootBundle.loadString("assets/sql/create.sql"); //Lê as informações de um arquivo
    List<String> ddls = s.split(";"); //Converte num Array cada instrução de create table

    //Percorre as instruções de criação.
    for (String ddl in ddls){
      //Verifica se não é uma linha vazia
      if (ddl.trim().isNotEmpty){
        //Cria as tabelas uma a uma no banco.
        await db.execute(ddl);
      }
    }

  }

  Future<FutureOr<void>> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("_onUpgrade: oldVersion: $oldVersion > newVersion: $newVersion");

    if(oldVersion == 1 && newVersion == 2) {
      await db.execute("alter table carro add column NOVA TEXT");
    }
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}