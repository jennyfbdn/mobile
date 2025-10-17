import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'config/api_config.dart';

class EnviarFeedbackPage extends StatefulWidget {
  @override
  _EnviarFeedbackPageState createState() => _EnviarFeedbackPageState();
}

class _EnviarFeedbackPageState extends State<EnviarFeedbackPage> with TickerProviderStateMixin {
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  int _avaliacao = 0;
  bool _isLoading = false;
  String? _nomeUsuario;
  String? _emailUsuario;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  final List<String> _categorias = [
    'Atendimento',
    'Qualidade do Produto', 
    'Entrega',
    'Preço',
    'Experiência Geral'
  ];
  String? _categoriaSelecionada;

  @override
  void initState() {
    super.initState();
    _carregarDadosUsuario();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  Future<void> _carregarDadosUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nomeUsuario = prefs.getString('userName') ?? '';
      _emailUsuario = prefs.getString('userEmail') ?? '';
      _nomeController.text = _nomeUsuario ?? '';
      _emailController.text = _emailUsuario ?? '';
    });
  }

  Future<void> _enviarFeedback() async {
    if (_feedbackController.text.trim().isEmpty) {
      _mostrarErro('Por favor, escreva seu feedback');
      return;
    }
    
    if (_avaliacao == 0) {
      _mostrarErro('Por favor, selecione uma avaliação');
      return;
    }
    
    if (_nomeController.text.trim().isEmpty) {
      _mostrarErro('Por favor, informe seu nome');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/mensagem/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'emissor': _nomeController.text.trim(),
          'email': _emailController.text.trim(),
          'texto': '${_categoriaSelecionada ?? 'Geral'}: ${_feedbackController.text.trim()} (Avaliação: $_avaliacao/5 estrelas)',
          'telefone': '',
        }),
      );

      if (response.statusCode == 200) {
        _mostrarSucesso();
      } else {
        throw Exception('Erro no servidor');
      }
    } catch (e) {
      _mostrarErro('Erro ao enviar feedback. Tente novamente.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(mensagem)),
          ],
        ),
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
  
  void _mostrarSucesso() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFFFB6C1).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_circle, size: 60, color: Color(0xFFFFB6C1)),
            ),
            SizedBox(height: 16),
            Text(
              'Obrigado!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Seu feedback foi enviado com sucesso. Agradecemos sua opinião!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, true);
            },
            child: Text('OK', style: TextStyle(color: Color(0xFFFFB6C1))),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _avaliacao = index + 1;
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.all(4),
                child: Icon(
                  index < _avaliacao ? Icons.star : Icons.star_border,
                  color: index < _avaliacao ? Color(0xFFFFB6C1) : Colors.grey[400],
                  size: 36,
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 8),
        Text(
          _avaliacao == 0 ? 'Toque nas estrelas para avaliar' : _getAvaliacaoTexto(_avaliacao),
          style: TextStyle(
            color: _avaliacao == 0 ? Colors.grey[500] : Color(0xFFFFB6C1),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
  
  String _getAvaliacaoTexto(int avaliacao) {
    switch (avaliacao) {
      case 1: return 'Muito insatisfeito';
      case 2: return 'Insatisfeito';
      case 3: return 'Neutro';
      case 4: return 'Satisfeito';
      case 5: return 'Muito satisfeito';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Sua Opinião'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        centerTitle: true,
        elevation: 4,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFB6C1), Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(Icons.favorite, size: 40, color: Colors.white),
                    SizedBox(height: 8),
                    Text(
                      'Conte-nos sua experiência',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Sua opinião é muito importante para nós',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              
              // Dados pessoais
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seus dados',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: _nomeController,
                        decoration: InputDecoration(
                          labelText: 'Nome',
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              
              // Categoria
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Categoria',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _categoriaSelecionada,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        hint: Text('Selecione uma categoria'),
                        items: _categorias.map((categoria) {
                          return DropdownMenuItem(
                            value: categoria,
                            child: Text(categoria),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _categoriaSelecionada = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              
              // Avaliação
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Como você avalia nossa experiência?',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      _buildStarRating(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              
              // Comentário
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Comentários',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: _feedbackController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Conte-nos mais detalhes sobre sua experiência...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              
              // Botão enviar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _enviarFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFB6C1),
                    foregroundColor: Colors.black87,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.black87, strokeWidth: 2),
                            ),
                            SizedBox(width: 12),
                            Text('Enviando...'),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send),
                            SizedBox(width: 8),
                            Text('Enviar Feedback', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _nomeController.dispose();
    _emailController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}