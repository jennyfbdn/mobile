import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config/api_config.dart';
import 'user_service.dart';

class DetalhesAgendamentoPage extends StatefulWidget {
  final Map<String, dynamic> agendamento;

  DetalhesAgendamentoPage({required this.agendamento});

  @override
  _DetalhesAgendamentoPageState createState() => _DetalhesAgendamentoPageState();
}

class _DetalhesAgendamentoPageState extends State<DetalhesAgendamentoPage> {
  final TextEditingController _feedbackController = TextEditingController();
  int _rating = 5;
  bool _enviandoFeedback = false;

  Future<void> _enviarFeedback() async {
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Digite um comentário')),
      );
      return;
    }

    setState(() => _enviandoFeedback = true);

    try {
      final userId = UserService().idUsuario;
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/mensagem/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usuarioId': userId,
          'usuarioNome': UserService().nomeUsuario ?? 'Usuário',
          'mensagem': _feedbackController.text.trim(),
          'avaliacao': _rating,
          'agendamentoId': widget.agendamento['id'],
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Feedback enviado com sucesso!')),
        );
        _feedbackController.clear();
        setState(() => _rating = 5);
      } else {
        throw Exception('Erro no servidor');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar feedback')),
      );
    } finally {
      setState(() => _enviandoFeedback = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Agendamento'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Informações do Agendamento', 
                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    _buildInfoRow('Serviço:', widget.agendamento['servico'] ?? 'N/A'),
                    _buildInfoRow('Data:', widget.agendamento['data'] ?? 'N/A'),
                    _buildInfoRow('Horário:', widget.agendamento['horario'] ?? 'N/A'),
                    _buildInfoRow('Status:', widget.agendamento['status'] ?? 'Agendado'),
                    _buildInfoRow('Preço:', 'R\$ ${widget.agendamento['preco'] ?? '0,00'}'),
                    if (widget.agendamento['observacoes'] != null)
                      _buildInfoRow('Observações:', widget.agendamento['observacoes']),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Deixe seu Feedback', 
                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    
                    Text('Avaliação:'),
                    Row(
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          ),
                          onPressed: () => setState(() => _rating = index + 1),
                        );
                      }),
                    ),
                    
                    SizedBox(height: 16),
                    TextField(
                      controller: _feedbackController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Seu comentário',
                        border: OutlineInputBorder(),
                        hintText: 'Como foi sua experiência?',
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _enviandoFeedback ? null : _enviarFeedback,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _enviandoFeedback
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('Enviar Feedback'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}