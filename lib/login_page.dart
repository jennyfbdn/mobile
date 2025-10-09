import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_service.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    
    String email = emailController.text.trim();
    String senha = senhaController.text;

    final userService = UserService();
    final result = await userService.login(email, senha);

    if (result['success']) {
      final userData = result['user'];
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userEmail', userData['email']);
      await prefs.setInt('userId', userData['id']);
      await prefs.setString('userName', userData['nome']);

      setState(() {
        _errorMessage = null;
      });

      Navigator.pushNamed(context, '/home');
    } else {
      setState(() {
        _errorMessage = result['message'];
      });
    }
  }

  void _loginGoogle() {
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 150,
              ),
              SizedBox(height: 24),
              TextFormField(
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
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'E-mail obrigatório';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) return 'E-mail inválido';
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
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
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Senha obrigatória';
                  if (value!.length < 6) return 'Mínimo 6 caracteres';
                  return null;
                },
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
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
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/forgot-password');
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black54,
                ),
                child: Text('Esqueci minha senha'),
              ),
              SizedBox(height: 8),
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
