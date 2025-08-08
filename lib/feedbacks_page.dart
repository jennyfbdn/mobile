import 'package:flutter/material.dart';
import 'user_service.dart';

class FeedbacksPage extends StatefulWidget {
  @override
  _FeedbacksPageState createState() => _FeedbacksPageState();
}

class _FeedbacksPageState extends State<FeedbacksPage> {
  List<Map<String, dynamic>> feedbacks = [
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

  void _adicionarFeedback() {
    showDialog(
      context: context,
      builder: (context) => _FeedbackDialog(
        onSubmit: (feedback) {
          setState(() {
            feedbacks.insert(0, feedback);
          });
        },
      ),
    );
  }

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
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _adicionarFeedback,
          ),
        ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarFeedback,
        backgroundColor: Colors.black87,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _FeedbackDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  _FeedbackDialog({required this.onSubmit});

  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<_FeedbackDialog> {
  final _nomeController = TextEditingController();
  final _produtoController = TextEditingController();
  final _comentarioController = TextEditingController();
  int _avaliacao = 5;

  @override
  void initState() {
    super.initState();
    // Preencher automaticamente com dados do usuário se disponível
    if (UserService().temUsuario) {
      _nomeController.text = UserService().nomeUsuario ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Adicionar Feedback'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Seu Nome'),
            ),
            TextField(
              controller: _produtoController,
              decoration: InputDecoration(labelText: 'Produto/Serviço'),
            ),
            SizedBox(height: 16),
            Text('Avaliação:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _avaliacao ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () => setState(() => _avaliacao = index + 1),
                );
              }),
            ),
            TextField(
              controller: _comentarioController,
              decoration: InputDecoration(labelText: 'Comentário'),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nomeController.text.isNotEmpty && _comentarioController.text.isNotEmpty) {
              // Salvar dados do usuário se não existir
              if (!UserService().temUsuario) {
                UserService().setUsuario(_nomeController.text, '');
              }
              
              widget.onSubmit({
                'cliente': _nomeController.text,
                'produto': _produtoController.text.isEmpty ? 'Serviço Geral' : _produtoController.text,
                'avaliacao': _avaliacao,
                'comentario': _comentarioController.text,
                'data': 'agora',
                'categoria': 'Meu Feedback',
                'avatar': _nomeController.text[0].toUpperCase(),
              });
              Navigator.pop(context);
            }
          },
          child: Text('Enviar'),
        ),
      ],
    );
  }
}