import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;

  void _login() {
    String email = emailController.text.trim();
    String senha = senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      setState(() {
        _errorMessage = 'Preencha todos os campos.';
      });
      return;
    }

    // Login fixo para exemplo
    if (email == 'panofino@atelie.com' && senha == '123456') {
      // Limpa mensagem de erro e navega
      setState(() {
        _errorMessage = null;
      });
      Navigator.pushNamed(context, '/home');
    } else {
      setState(() {
        _errorMessage = 'E-mail ou senha incorretos.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Cor de fundo da tela
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Centraliza o conteúdo na tela
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/images/logo.png',
                height: 150,
              ),
              SizedBox(height: 24),

              // Campo de E-mail
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  labelStyle: TextStyle(color: Colors.black54),  // Cor da label
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.pink),  // Cor da borda focada
                  ),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],  // Cor de fundo do campo de texto
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),

              // Campo de Senha
              TextField(
                controller: senhaController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle: TextStyle(color: Colors.black54),  // Cor da label
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.pink),  // Cor da borda focada
                  ),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],  // Cor de fundo do campo de texto
                ),
                obscureText: true,
              ),

              // Mensagem de erro, caso exista
              if (_errorMessage != null) ...[
                SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),  // Cor da mensagem de erro
                ),
              ],

              // Botão Entrar
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,  // Cor de fundo preta para o botão
                  foregroundColor: Colors.white,  // Cor do texto do botão
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),  // Bordas arredondadas
                  ),
                ),
                child: Text('Entrar'),
              ),

              // Link para criar conta
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/cadastro');
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,  // Cor do texto do link (anterior 'primary')
                ),
                child: Text('Criar conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
