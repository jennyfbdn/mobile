import 'package:flutter/material.dart';
import 'profile_page.dart';

class FeedbacksPage extends StatefulWidget {
  @override
  _FeedbacksPageState createState() => _FeedbacksPageState();
}

class _FeedbacksPageState extends State<FeedbacksPage> {
  final List<Map<String, dynamic>> feedbacks = [
    {
      'usuario': 'Maria Silva',
      'imagem': 'assets/images/vestido_floral.jpg',
      'descricao': 'Vestido floral maravilhoso! Ficou perfeito para o casamento da minha irmã 💕',
      'curtidas': 127,
      'curtido': false,
      'comentarios': [
        {'nome': 'Ana Costa', 'texto': 'Que lindo! Onde posso encomendar?'},
        {'nome': 'Julia Santos', 'texto': 'Perfeito! 😍'},
      ],
      'tempo': '2h',
    },
    {
      'usuario': 'João Pedro',
      'imagem': 'assets/images/conjunto_jeans.jpg',
      'descricao': 'Conjunto jeans sob medida. Qualidade excepcional! Recomendo muito 👌',
      'curtidas': 89,
      'curtido': true,
      'comentarios': [
        {'nome': 'Carlos Lima', 'texto': 'Ficou show! Quanto custou?'},
        {'nome': 'Pedro Alves', 'texto': 'Top demais!'},
        {'nome': 'Lucas Rocha', 'texto': 'Quero fazer um igual'},
      ],
      'tempo': '5h',
    },
    {
      'usuario': 'Carla Mendes',
      'imagem': 'assets/images/blusa_couro.jpg',
      'descricao': 'Blusa de couro personalizada. Amei o resultado! Ateliê Pano Fino é o melhor ✨',
      'curtidas': 203,
      'curtido': false,
      'comentarios': [
        {'nome': 'Fernanda Luz', 'texto': 'Que estilo! Adorei'},
        {'nome': 'Beatriz Nunes', 'texto': 'Ficou incrível!'},
      ],
      'tempo': '1d',
    },
    {
      'usuario': 'Roberto Costa',
      'imagem': 'assets/images/conjunto_social.jpg',
      'descricao': 'Terno sob medida para formatura. Ficou impecável! Obrigado pela dedicação 🎓',
      'curtidas': 156,
      'curtido': true,
      'comentarios': [
        {'nome': 'Marcos Silva', 'texto': 'Parabéns pela formatura!'},
        {'nome': 'André Souza', 'texto': 'Terno perfeito!'},
      ],
      'tempo': '2d',
    },
  ];

  void _toggleCurtida(int index) {
    setState(() {
      feedbacks[index]['curtido'] = !feedbacks[index]['curtido'];
      if (feedbacks[index]['curtido']) {
        feedbacks[index]['curtidas']++;
      } else {
        feedbacks[index]['curtidas']--;
      }
    });
  }

  void _mostrarComentarios(BuildContext context, Map<String, dynamic> feedback) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Comentários',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: feedback['comentarios'].length,
                itemBuilder: (context, index) {
                  final comentario = feedback['comentarios'][index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.grey[300],
                          child: Text(
                            comentario['nome'][0],
                            style: TextStyle(
                              fontSize: 12,
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
                                comentario['nome'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                comentario['texto'],
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Feedbacks',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
        centerTitle: true,
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline, color: Colors.black87),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: feedbacks.length,
        itemBuilder: (context, index) {
          final feedback = feedbacks[index];
          return Container(
            margin: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!, width: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header do post
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
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
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              feedback['tempo'],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.more_vert, color: Colors.grey[600]),
                    ],
                  ),
                ),
                
                // Imagem do post
                Container(
                  width: double.infinity,
                  height: 300,
                  child: Image.asset(
                    feedback['imagem'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey[400],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Ações (curtir, comentar, compartilhar)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => _toggleCurtida(index),
                        child: Icon(
                          feedback['curtido'] ? Icons.favorite : Icons.favorite_border,
                          color: feedback['curtido'] ? Colors.red : Colors.black87,
                          size: 28,
                        ),
                      ),
                      SizedBox(width: 16),
                      GestureDetector(
                        onTap: () => _mostrarComentarios(context, feedback),
                        child: Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.black87,
                          size: 26,
                        ),
                      ),
                      SizedBox(width: 16),
                      Icon(
                        Icons.send_outlined,
                        color: Colors.black87,
                        size: 26,
                      ),
                      Spacer(),
                      Icon(
                        Icons.bookmark_border,
                        color: Colors.black87,
                        size: 26,
                      ),
                    ],
                  ),
                ),
                
                // Número de curtidas
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '${feedback['curtidas']} curtidas',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                
                // Descrição
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                      children: [
                        TextSpan(
                          text: feedback['usuario'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' '),
                        TextSpan(text: feedback['descricao']),
                      ],
                    ),
                  ),
                ),
                
                // Ver comentários
                if (feedback['comentarios'].length > 0)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: () => _mostrarComentarios(context, feedback),
                      child: Text(
                        'Ver todos os ${feedback['comentarios'].length} comentários',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                
                SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}