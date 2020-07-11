import 'package:carros/pages/login/login_page.dart';
import 'package:carros/splash_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //Tira a faixa escrito "Debug"
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light, //Neste ponto pode trocar o tema para escuro .dark
        scaffoldBackgroundColor: Colors.white, //Cor padrão para todos os Scaffold.
      ),
      home: SplashPage(),
    );
  }
}
