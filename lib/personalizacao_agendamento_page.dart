import 'package:flutter/material.dart';
import 'personalizacao_page.dart';

class PersonalizacaoAgendamentoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Redireciona diretamente para PersonalizacaoPage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => PersonalizacaoPage()),
      );
    });
    
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}