import 'package:flutter/material.dart';

class CadastroPage extends StatelessWidget {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/images/logo.png',
                height: 120,
              ),
              SizedBox(height: 32),

              // Campo Nome
              TextField(
                controller: nomeController,
                decoration: _inputDecoration('Nome'),
                style: TextStyle(color: Colors.black87),
              ),
              SizedBox(height: 16),

              // Campo Email
              TextField(
                controller: emailController,
                decoration: _inputDecoration('E-mail'),
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.black87),
              ),
              SizedBox(height: 16),

              // Campo Senha
              TextField(
                controller: senhaController,
                decoration: _inputDecoration('Senha'),
                obscureText: true,
                style: TextStyle(color: Colors.black87),
              ),

              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  minimumSize: Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Cadastrar', style: TextStyle(fontSize: 16)),
              ),

              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                child: Text('Voltar para login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.black54),
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.black87),
      ),
    );
  }
}
