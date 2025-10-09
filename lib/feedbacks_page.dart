import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'profile_page.dart';
import 'config/api_config.dart';

class FeedbacksPage extends StatefulWidget {
  @override
  _FeedbacksPageState createState() => _FeedbacksPageState();
}

class _FeedbacksPageState extends State<FeedbacksPage> {
  List<Map<String, dynamic>> feedbacks = [];
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _carregarFeedbacks();
  }
  
  Future<void> _carregarFeedbacks() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/mensagem/findAll'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          feedbacks = data.map((item) => {
            'usuario': item['emissor'] ?? 'Usuário',
            'descricao': item['texto'] ?? '',
            'avaliacao': 5, // Valor padrão já que não tem avaliação na estrutura atual
            'tempo': _formatarTempo(item['dataMensagem']),
          }).toList().cast<Map<String, dynamic>>();
          isLoading = false;
        });
        return;
      }
    } catch (e) {
      print('Erro ao carregar feedbacks: $e');
    }
    
    // Fallback para dados de exemplo
    setState(() {
      feedbacks = [
        {
          'usuario': 'Maria Silva',
          'descricao': 'Serviço excelente! Muito satisfeita com o resultado.',
          'avaliacao': 5,
          'tempo': '2h',
        },
        {
          'usuario': 'João Pedro',
          'descricao': 'Qualidade excepcional! Recomendo muito.',
          'avaliacao': 5,
          'tempo': '5h',
        },
      ];
      isLoading = false;
    });
  }
  
  String _formatarTempo(String? dataEnvio) {
    if (dataEnvio == null) return 'agora';
    try {
      final data = DateTime.parse(dataEnvio);
      final agora = DateTime.now();
      final diferenca = agora.difference(data);
      
      if (diferenca.inMinutes < 60) {
        return '${diferenca.inMinutes}m';
      } else if (diferenca.inHours < 24) {
        return '${diferenca.inHours}h';
      } else {
        return '${diferenca.inDays}d';
      }
    } catch (e) {
      return 'agora';
    }
  }

  Widget _buildStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Feedbacks'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        centerTitle: true,
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : feedbacks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.feedback_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Nenhum feedback encontrado'),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: feedbacks.length,
              itemBuilder: (context, index) {
                final feedback = feedbacks[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey[300],
                              child: Text(
                                feedback['usuario'][0],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    feedback['usuario'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      _buildStars(feedback['avaliacao']),
                                      SizedBox(width: 8),
                                      Text(
                                        feedback['tempo'],
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          feedback['descricao'],
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}