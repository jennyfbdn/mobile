import 'package:flutter/material.dart';
// Firebase removido temporariamente

class TelaRedefinirSenha extends StatefulWidget {
  @override
  _TelaRedefinirSenhaState createState() => _TelaRedefinirSenhaState();
}

class _TelaRedefinirSenhaState extends State<TelaRedefinirSenha> {
  final TextEditingController _emailController = TextEditingController();
  String mensagem = "";

  Future<void> _enviarEmailRedefinicao() async {
    // TODO: Implementar redefinição de senha
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      mensagem = "E-mail de redefinição enviado com sucesso!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Redefinir Senha')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Informe seu e-mail para redefinir a senha."),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'E-mail'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _enviarEmailRedefinicao,
              child: Text("Enviar e-mail"),
            ),
            SizedBox(height: 20),
            Text(mensagem, style: TextStyle(color: Colors.green)),
          ],
        ),
      ),
    );
  }
}