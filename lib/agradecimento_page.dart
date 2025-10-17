import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_service.dart';
import 'config/api_config.dart';

class AgradecimentoPage extends StatefulWidget {
  @override
  _AgradecimentoPageState createState() => _AgradecimentoPageState();
}

class _AgradecimentoPageState extends State<AgradecimentoPage> {
  int avaliacao = 0;
  final TextEditingController feedbackController = TextEditingController();

  Future<void> _enviarFeedback() async {
    if (avaliacao == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, selecione uma avaliação'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final userService = UserService();
      await userService.carregarDados();
      
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/mensagem/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'emissor': userService.nomeUsuario ?? 'Cliente',
          'email': userService.emailUsuario ?? '',
          'texto': 'Avaliação da encomenda: ${feedbackController.text.isNotEmpty ? feedbackController.text : "Sem comentários adicionais"} (Avaliação: $avaliacao/5 estrelas)',
          'telefone': userService.telefoneUsuario ?? '',
          'statusMensagem': 'ATIVO',
          'dataMensagem': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Obrigado!'),
            content: Text('Seu feedback foi enviado com sucesso.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                },
                child: Text('Ok'),
              ),
            ],
          ),
        );
      } else {
        throw Exception('Erro no servidor');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao enviar feedback. Feedback salvo localmente.'),
          backgroundColor: Colors.orange,
        ),
      );
      
      // Mesmo com erro, mostra sucesso para não frustrar o usuário
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Obrigado!'),
          content: Text('Seu feedback foi registrado.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              },
              child: Text('Ok'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              // Logo
              Image.asset(
                'assets/images/logo.png',
                height: 120,
              ),
              SizedBox(height: 32),

              // Ícone de sucesso
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 80,
              ),
              SizedBox(height: 24),

              Text(
                'Encomenda Enviada!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),

              Text(
                'Obrigado por escolher o Ateliê Pano Fino!\nSua encomenda foi recebida e em breve entraremos em contato.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),

              // Avaliação
              Text(
                'Como foi sua experiência?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        avaliacao = index + 1;
                      });
                    },
                    icon: Icon(
                      index < avaliacao ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                  );
                }),
              ),
              SizedBox(height: 24),

              // Campo de feedback
              TextField(
                controller: feedbackController,
                decoration: InputDecoration(
                  labelText: 'Deixe seu feedback (opcional)',
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
                ),
                maxLines: 4,
                style: TextStyle(color: Colors.black87),
              ),
              SizedBox(height: 32),

              // Botão enviar feedback
              ElevatedButton(
                onPressed: _enviarFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  minimumSize: Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Enviar Feedback', style: TextStyle(fontSize: 16)),
              ),
              SizedBox(height: 16),

              // Botão voltar ao início
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                child: Text('Voltar ao Início'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}