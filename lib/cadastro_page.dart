import 'package:flutter/material.dart';
import 'user_service.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmarSenhaController = TextEditingController();
  String? senhaError;

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

              // Campo Telefone
              TextField(
                controller: telefoneController,
                decoration: _inputDecoration('Telefone'),
                keyboardType: TextInputType.phone,
                style: TextStyle(color: Colors.black87),
              ),
              SizedBox(height: 16),

              // Campo Senha
              TextField(
                controller: senhaController,
                decoration: _inputDecoration('Senha'),
                obscureText: true,
                style: TextStyle(color: Colors.black87),
                onChanged: (value) => _validatePasswords(),
              ),
              SizedBox(height: 16),

              // Campo Confirmar Senha
              TextField(
                controller: confirmarSenhaController,
                decoration: _inputDecoration('Confirmar Senha').copyWith(
                  errorText: senhaError,
                ),
                obscureText: true,
                style: TextStyle(color: Colors.black87),
                onChanged: (value) => _validatePasswords(),
              ),

              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isFormValid() ? _cadastrarUsuario : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.black,
                  disabledForegroundColor: Colors.white,
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

  void _validatePasswords() {
    setState(() {
      if (confirmarSenhaController.text.isNotEmpty && 
          senhaController.text != confirmarSenhaController.text) {
        senhaError = 'As senhas não coincidem';
      } else {
        senhaError = null;
      }
    });
  }

  bool _isFormValid() {
    return nomeController.text.isNotEmpty &&
           emailController.text.isNotEmpty &&
           telefoneController.text.isNotEmpty &&
           senhaController.text.isNotEmpty &&
           confirmarSenhaController.text.isNotEmpty &&
           senhaError == null;
  }


  

  Future<void> _cadastrarUsuario() async {
    // Mostrar loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    final userService = UserService();
    
    final result = await userService.cadastrarUsuario(
      nome: nomeController.text,
      email: emailController.text,
      telefone: telefoneController.text,
      senha: senhaController.text,
    );

    // Fechar loading
    Navigator.of(context).pop();

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    }
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
