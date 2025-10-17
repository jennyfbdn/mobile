import 'package:flutter/material.dart';
import 'user_service.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmarSenhaController = TextEditingController();
  String? senhaError;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
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
              TextFormField(
                controller: nomeController,
                decoration: _inputDecoration('Nome'),
                style: TextStyle(color: Colors.black87),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Nome é obrigatório';
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Campo Email
              TextFormField(
                controller: emailController,
                decoration: _inputDecoration('E-mail'),
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.black87),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'E-mail é obrigatório';
                  if (!value!.contains('@')) return 'E-mail deve conter @';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'E-mail inválido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Campo Telefone
              TextFormField(
                controller: telefoneController,
                decoration: _inputDecoration('Telefone'),
                keyboardType: TextInputType.phone,
                style: TextStyle(color: Colors.black87),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Telefone é obrigatório';
                  String cleanPhone = value!.replaceAll(RegExp(r'[^0-9]'), '');
                  if (cleanPhone.length < 10) return 'Telefone deve ter pelo menos 10 dígitos';
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Campo Senha
              TextFormField(
                controller: senhaController,
                decoration: _inputDecoration('Senha'),
                obscureText: true,
                style: TextStyle(color: Colors.black87),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Senha é obrigatória';
                  return _validateStrongPassword(value!);
                },
                onChanged: (value) => _validatePasswords(),
              ),
              if (senhaController.text.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('A senha deve conter:', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      _buildPasswordRequirement('Pelo menos 8 caracteres', senhaController.text.length >= 8),
                      _buildPasswordRequirement('Pelo menos 1 letra maiúscula', RegExp(r'[A-Z]').hasMatch(senhaController.text)),
                      _buildPasswordRequirement('Pelo menos 1 letra minúscula', RegExp(r'[a-z]').hasMatch(senhaController.text)),
                      _buildPasswordRequirement('Pelo menos 1 número', RegExp(r'[0-9]').hasMatch(senhaController.text)),
                      _buildPasswordRequirement('Pelo menos 1 caractere especial', RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(senhaController.text)),
                    ],
                  ),
                ),
              SizedBox(height: 16),

              // Campo Confirmar Senha
              TextFormField(
                controller: confirmarSenhaController,
                decoration: _inputDecoration('Confirmar Senha').copyWith(
                  errorText: senhaError,
                ),
                obscureText: true,
                style: TextStyle(color: Colors.black87),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Confirmação de senha é obrigatória';
                  if (value != senhaController.text) return 'Senhas não coincidem';
                  return null;
                },
                onChanged: (value) => _validatePasswords(),
              ),

              SizedBox(height: 32),
              ElevatedButton(
                onPressed: (_isFormValid() && !_isLoading) ? _cadastrarUsuario : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[400],
                  disabledForegroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  minimumSize: Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isLoading 
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text('Cadastrar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
      ),
    );
  }

  void _validatePasswords() {
    if (mounted) {
      setState(() {
        if (confirmarSenhaController.text.isNotEmpty && 
            senhaController.text != confirmarSenhaController.text) {
          senhaError = 'As senhas não coincidem';
        } else {
          senhaError = null;
        }
      });
    }
  }

  bool _isFormValid() {
    return nomeController.text.isNotEmpty &&
           emailController.text.isNotEmpty &&
           telefoneController.text.isNotEmpty &&
           _isStrongPassword(senhaController.text) &&
           confirmarSenhaController.text.isNotEmpty &&
           senhaController.text == confirmarSenhaController.text &&
           senhaError == null;
  }

  String? _validateStrongPassword(String password) {
    if (password.length < 8) return 'Senha deve ter pelo menos 8 caracteres';
    if (!RegExp(r'[A-Z]').hasMatch(password)) return 'Senha deve conter pelo menos 1 letra maiúscula';
    if (!RegExp(r'[a-z]').hasMatch(password)) return 'Senha deve conter pelo menos 1 letra minúscula';
    if (!RegExp(r'[0-9]').hasMatch(password)) return 'Senha deve conter pelo menos 1 número';
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) return 'Senha deve conter pelo menos 1 caractere especial';
    return null;
  }

  bool _isStrongPassword(String password) {
    return password.length >= 8 &&
           RegExp(r'[A-Z]').hasMatch(password) &&
           RegExp(r'[a-z]').hasMatch(password) &&
           RegExp(r'[0-9]').hasMatch(password) &&
           RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
  }

  Widget _buildPasswordRequirement(String text, bool isValid) {
    return Padding(
      padding: EdgeInsets.only(left: 8, top: 2),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: isValid ? Colors.green : Colors.grey,
          ),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: isValid ? Colors.green : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    telefoneController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    super.dispose();
  }


  

  Future<void> _cadastrarUsuario() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });

    final userService = UserService();
    
    final result = await userService.cadastrarUsuario(
      nome: nomeController.text,
      email: emailController.text,
      telefone: telefoneController.text,
      senha: senhaController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (mounted && result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${result['message']} Faça login para continuar.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 4),
        ),
      );
      Navigator.pop(context); // Volta para a tela de login
    } else if (mounted) {
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
      labelStyle: TextStyle(color: Color(0xFF616161)),
      filled: true,
      fillColor: Color(0xFFFAFAFA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.black, width: 2),
      ),
    );
  }
}
