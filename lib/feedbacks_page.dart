import 'package:flutter/material.dart';

class FeedbacksPage extends StatelessWidget {
  final List<Map<String, dynamic>> feedbacks = [
    {
      'cliente': 'Maria Silva',
      'produto': 'Vestido Sob Medida',
      'avaliacao': 5,
      'comentario': 'Trabalho impecável! O acabamento é perfeito e o caimento ficou exatamente como desejava. Recomendo o ateliê.',
      'data': '2h',
      'categoria': 'Costura',
      'avatar': 'M',
    },
    {
      'cliente': 'João Santos',
      'produto': 'Ajuste de Terno',
      'avaliacao': 5,
      'comentario': 'Serviço de alta qualidade. A costureira tem excelente técnica e atenção aos detalhes. Muito satisfeito.',
      'data': '5h',
      'categoria': 'Ajuste',
      'avatar': 'J',
    },
    {
      'cliente': 'Ana Costa',
      'produto': 'Reforma de Vestido',
      'avaliacao': 5,
      'comentario': 'Transformou completamente a peça! Profissionalismo exemplar e resultado além das expectativas.',
      'data': '1d',
      'categoria': 'Reforma',
      'avatar': 'A',
    },
    {
      'cliente': 'Pedro Lima',
      'produto': 'Calça Social',
      'avaliacao': 4,
      'comentario': 'Ótimo trabalho, tecido de qualidade e acabamento profissional. Prazo cumprido conforme combinado.',
      'data': '2d',
      'categoria': 'Costura',
      'avatar': 'P',
    },
    {
      'cliente': 'Carla Mendes',
      'produto': 'Bordado Personalizado',
      'avaliacao': 5,
      'comentario': 'Arte incrível! O bordado ficou perfeito, com detalhes únicos. Trabalho artesanal de primeira qualidade.',
      'data': '3d',
      'categoria': 'Bordado',
      'avatar': 'C',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Avaliações dos Clientes',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
        elevation: 2,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[50],
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 16),
          itemCount: feedbacks.length,
          itemBuilder: (context, index) {
          final feedback = feedbacks[index];
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.black87,
                        child: Text(
                          feedback['avatar'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              feedback['cliente'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 2),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                feedback['categoria'],
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        feedback['data'],
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    feedback['produto'],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: List.generate(5, (starIndex) {
                      return Icon(
                        starIndex < feedback['avaliacao']
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber[600],
                        size: 18,
                      );
                    }),
                  ),
                  SizedBox(height: 12),
                  Text(
                    feedback['comentario'],
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          );
          },
        ),
      ),
    );
  }
}