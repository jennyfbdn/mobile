import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ValidarCodigoPage extends StatefulWidget {
  final String email;
  
  const ValidarCodigoPage({Key? key, required this.email}) : super(key: key);

  @override
  _ValidarCodigoPageState createState() => _ValidarCodigoPageState();
}

class _ValidarCodigoPageState extends State<ValidarCodigoPage> {
  final _codigoController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _codigoValidado = false;

  Future<void> _validarCodigo() async {
    if (_codigoController.text.length != 6) {
      _mostrarErro('Código deve ter 6 dígitos');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/usuario/validarCodigo'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'codigo': _codigoController.text,
        }),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        setState(() => _codigoValidado = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Código válido! Defina sua nova senha.'), backgroundColor: Colors.green),
        );
      } else {
        _mostrarErro('Código inválido ou expirado');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _mostrarErro('Erro de conexão');
    }
  }

  Future<void> _redefinirSenha() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/usuario/resetSenha'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'codigo': _codigoController.text,
          'novaSenha': _novaSenhaController.text,
        }),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        _mostrarSucesso();
      } else {
        _mostrarErro('Erro ao redefinir senha');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _mostrarErro('Erro de conexão');
    }
  }

  void _mostrarSucesso() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Senha Redefinida'),
        content: Text('Sua senha foi alterada com sucesso!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('Fazer Login'),
          ),
        ],
      ),
    );
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Validar Código'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text('Digite o código enviado para ${widget.email}'),
              SizedBox(height: 16),
              TextFormField(
                controller: _codigoController,
                decoration: InputDecoration(
                  labelText: 'Código (6 dígitos)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.number,
                maxLength: 6,
                enabled: !_codigoValidado,
              ),
              SizedBox(height: 16),
              if (!_codigoValidado)
                ElevatedButton(
                  onPressed: _isLoading ? null : _validarCodigo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Validar Código', style: TextStyle(color: Colors.white)),
                ),
              if (_codigoValidado) ...[
                TextFormField(
                  controller: _novaSenhaController,
                  decoration: InputDecoration(
                    labelText: 'Nova Senha',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Digite a nova senha';
                    if (value!.length < 6) return 'Mínimo 6 caracteres';
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _confirmarSenhaController,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Nova Senha',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value != _novaSenhaController.text) return 'Senhas não coincidem';
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _redefinirSenha,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Redefinir Senha', style: TextStyle(color: Colors.white)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}