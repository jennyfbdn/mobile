import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'profile_page.dart';
import 'config/api_config.dart';
import 'enviar_feedback_page.dart';

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
  
  Future<void> _navegarParaEnviarFeedback() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EnviarFeedbackPage()),
    );
    
    if (resultado == true) {
      _carregarFeedbacks(); // Recarrega os feedbacks após enviar
    }
  }

  Future<void> _carregarFeedbacks() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      print('Carregando feedbacks de: ${ApiConfig.baseUrl}/mensagem/findAll');
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/mensagem/findAll'),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('Status da resposta: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('Dados recebidos: $data');
        
        setState(() {
          feedbacks = data.map((item) => {
            'usuario': item['emissor'] ?? 'Usuário',
            'descricao': item['texto'] ?? '',
            'avaliacao': 5,
            'tempo': _formatarTempo(item['dataMensagem']),
          }).toList().cast<Map<String, dynamic>>();
          isLoading = false;
        });
        return;
      }
    } catch (e) {
      print('Erro ao carregar feedbacks: $e');
    }
    
    setState(() {
      isLoading = false;
    });
  }
  
  String _formatarTempo(String? dataEnvio) {
    if (dataEnvio == null) return 'agora';
    try {
      // Tentar diferentes formatos de data
      DateTime data;
      if (dataEnvio.contains('T')) {
        data = DateTime.parse(dataEnvio);
      } else {
        // Formato alternativo se necessário
        data = DateTime.parse(dataEnvio);
      }
      
      final agora = DateTime.now();
      final diferenca = agora.difference(data);
      
      if (diferenca.inMinutes < 1) {
        return 'agora';
      } else if (diferenca.inMinutes < 60) {
        return '${diferenca.inMinutes}m';
      } else if (diferenca.inHours < 24) {
        return '${diferenca.inHours}h';
      } else {
        return '${diferenca.inDays}d';
      }
    } catch (e) {
      print('Erro ao formatar tempo: $e para data: $dataEnvio');
      return 'agora';
    }
  }

  Widget _buildStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Padding(
          padding: EdgeInsets.only(right: 2),
          child: Icon(
            index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
            color: Color(0xFFFFB800),
            size: 18,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Avaliações',
          style: TextStyle(
            color: Color(0xFF2C2C2C),
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF2C2C2C),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Color(0xFF2C2C2C)),
            onPressed: () {
              _carregarFeedbacks();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : feedbacks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Color(0xFFFCE8E1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.star_outline,
                            size: 48,
                            color: Color(0xFF2C2C2C),
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Nenhuma avaliação ainda',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2C2C2C),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Seja o primeiro a compartilhar sua experiência',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B6B6B),
                          ),
                        ),
                        SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () => _navegarParaEnviarFeedback(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2C2C2C),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Enviar Avaliação',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _carregarFeedbacks,
                    child: ListView.builder(
                      padding: EdgeInsets.all(20),
                      itemCount: feedbacks.length,
                      itemBuilder: (context, index) {
                        final feedback = feedbacks[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 20,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFCE8E1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          feedback['usuario'][0].toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF2C2C2C),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            feedback['usuario'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: Color(0xFF2C2C2C),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              _buildStars(feedback['avaliacao']),
                                              SizedBox(width: 12),
                                              Text(
                                                feedback['tempo'],
                                                style: TextStyle(
                                                  color: Color(0xFF9E9E9E),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Text(
                                  feedback['descricao'],
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF2C2C2C),
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => _navegarParaEnviarFeedback(),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}