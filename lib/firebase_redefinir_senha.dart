import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TelaRedefinirSenha extends StatefulWidget {
  @override
  _TelaRedefinirSenhaState createState() => _TelaRedefinirSenhaState();
}

class _TelaRedefinirSenhaState extends State<TelaRedefinirSenha> {
  final TextEditingController _emailController = TextEditingController();
  String mensagem = "";

  Future<void> _enviarEmailRedefinicao() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      setState(() {
        mensagem = "E-mail de redefinição enviado com sucesso!";
      });
    } catch (e) {
      setState(() {
        mensagem = "Erro: ${e.toString()}";
      });
    }
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