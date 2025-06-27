import 'package:flutter/material.dart';
import 'login_page.dart';
import 'cadastro_page.dart';
import 'home_page.dart';

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
        '/home': (context) => HomePage(),
      },
      debugShowCheckedModeBanner: false,  // Remove a faixa de debug
    );
  }
}
