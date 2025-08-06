import 'package:flutter/material.dart';

class FeedbacksPage extends StatelessWidget {
  final List<Map<String, dynamic>> feedbacks = [
    {
      'cliente': 'Maria Silva',
      'produto': 'Vestido Floral',
      'avaliacao': 5,
      'comentario': 'Perfeito! Ficou exatamente como eu queria. Qualidade excelente.',
      'data': '2h',
      'imagem': 'assets/images/vestido_floral.jpg',
      'avatar': 'M',
    },
    {
      'cliente': 'João Santos',
      'produto': 'Camisa Social',
      'avaliacao': 4,
      'comentario': 'Boa qualidade, mas demorou um pouco para ficar pronta.',
      'data': '5h',
      'imagem': 'assets/images/vestido_floral.jpg',
      'avatar': 'J',
    },
    {
      'cliente': 'Ana Costa',
      'produto': 'Linha de Algodão',
      'avaliacao': 5,
      'comentario': 'Linha de ótima qualidade, recomendo!',
      'data': '1d',
      'imagem': 'assets/images/vestido_floral.jpg',
      'avatar': 'A',
    },
    {
      'cliente': 'Pedro Lima',
      'produto': 'Calça Jeans',
      'avaliacao': 3,
      'comentario': 'Ficou boa, mas o caimento poderia ser melhor.',
      'data': '2d',
      'imagem': 'assets/images/vestido_floral.jpg',
      'avatar': 'P',
    },
    {
      'cliente': 'Carla Mendes',
      'produto': 'Tesoura de Costura',
      'avaliacao': 5,
      'comentario': 'Excelente produto! Muito afiada e resistente.',
      'data': '3d',
      'imagem': 'assets/images/vestido_floral.jpg',
      'avatar': 'C',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Feedbacks',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: false,
      ),
      body: ListView.builder(
        itemCount: feedbacks.length,
        itemBuilder: (context, index) {
          final feedback = feedbacks[index];
          return Container(
            margin: EdgeInsets.only(bottom: 8),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header do post
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[300],
                        child: Text(
                          feedback['avatar'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              feedback['cliente'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              feedback['produto'],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        feedback['data'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Imagem do produto
                Container(
                  width: double.infinity,
                  height: 300,
                  child: Image.asset(
                    feedback['imagem'],
                    fit: BoxFit.cover,
                  ),
                ),
                // Ações (like, comment, share)
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Row(
                        children: List.generate(5, (starIndex) {
                          return Icon(
                            starIndex < feedback['avaliacao']
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.black,
                            size: 20,
                          );
                        }),
                      ),
                      Spacer(),
                      Icon(Icons.favorite_border, size: 24),
                      SizedBox(width: 16),
                      Icon(Icons.chat_bubble_outline, size: 24),
                      SizedBox(width: 16),
                      Icon(Icons.send, size: 24),
                    ],
                  ),
                ),
                // Comentário
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      children: [
                        TextSpan(
                          text: feedback['cliente'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' ${feedback['comentario']}'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
          );
        },
      ),
    );
  }
}