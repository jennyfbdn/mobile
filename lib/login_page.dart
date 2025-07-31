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

  void _loginGoogle() {
    // Simulando login com Google
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Login Google'),
        content: Text('Entrando com Google...'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/home');
            },
            child: Text('Entrar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _loginFacebook() {
    // Simulando login com Facebook
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Login Facebook'),
        content: Text('Entrando com Facebook...'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/home');
            },
            child: Text('Entrar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  Widget _socialButton({
    required String text,
    required Color backgroundColor,
    required Color textColor,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: textColor),
      label: Text(text, style: TextStyle(color: textColor)),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // fundo branco
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/images/logo.png',
                height: 150,
              ),
              SizedBox(height: 24),

              // E-mail
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  labelStyle: TextStyle(color: Colors.black54),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.black87),
              ),
              SizedBox(height: 16),

              // Senha
              TextField(
                controller: senhaController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle: TextStyle(color: Colors.black54),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                obscureText: true,
                style: TextStyle(color: Colors.black87),
              ),

              if (_errorMessage != null) ...[
                SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ],

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Entrar'),
              ),

              SizedBox(height: 16),
              Text(
                'Ou entre com',
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _socialButton(
                      text: 'Google',
                      backgroundColor: Colors.white,
                      textColor: Colors.black87,
                      icon: Icons.g_mobiledata,
                      onPressed: _loginGoogle,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _socialButton(
                      text: 'Facebook',
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      icon: Icons.facebook,
                      onPressed: _loginFacebook,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/cadastro');
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
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
