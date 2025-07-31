import 'package:flutter/material.dart';
import 'login_page.dart';
import 'cadastro_page.dart';
import 'home_page.dart';
import 'localizacao_page.dart';
import 'agradecimento_page.dart';
import 'encomendas_page.dart';
import 'bottom_navigation.dart';

void main() {
  runApp(AteliePanoFinoApp());
}

class AteliePanoFinoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ateliê Pano Fino',  // Título do app
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/cadastro': (context) => CadastroPage(),
        '/home': (context) => MainNavigation(initialIndex: 0),
        '/localizacao': (context) => MainNavigation(initialIndex: 2),
        '/agradecimento': (context) => AgradecimentoPage(),
        '/encomendas': (context) => MainNavigation(initialIndex: 1),
      },
      debugShowCheckedModeBanner: false,  // Remove a faixa de debug
    );
  }
}
