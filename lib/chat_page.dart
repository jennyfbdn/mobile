import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'produtos_page.dart';
import 'agendamentos_page.dart';
import 'personalizacao_page.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isTyping = false;
  
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "👋 Olá! Sou a assistente virtual do Ateliê Pano Fino! Como posso ajudar você hoje?",
      isUser: false,
      time: DateTime.now().subtract(Duration(minutes: 2)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    String userMessage = _messageController.text;
    setState(() {
      _messages.add(ChatMessage(
        text: userMessage,
        isUser: true,
        time: DateTime.now(),
      ));
      _isTyping = true;
    });

    _messageController.clear();

    // Simular digitação e resposta
    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        _isTyping = false;
        _messages.addAll(_getSmartResponse(userMessage));
      });
    });
  }

  List<ChatMessage> _getSmartResponse(String message) {
    String msg = message.toLowerCase();
    List<ChatMessage> responses = [];
    
    if (msg.contains('oi') || msg.contains('olá') || msg.contains('ola')) {
      responses.add(ChatMessage(
        text: "Oi! 😊 Que bom te ver aqui! Em que posso ajudar?",
        isUser: false,
        time: DateTime.now(),
        hasActions: true,
        actions: ['Ver Materiais', 'Fazer Pedido', 'Agendamentos'],
      ));
    } else if (msg.contains('produto') || msg.contains('comprar') || msg.contains('loja')) {
      responses.add(ChatMessage(
        text: "🛍️ Temos uma variedade incrível de materiais! Linhas, agulhas, tesouras e muito mais.",
        isUser: false,
        time: DateTime.now(),
      ));
      responses.add(ChatMessage(
        text: "Quer dar uma olhada na nossa loja?",
        isUser: false,
        time: DateTime.now(),
        hasActions: true,
        actions: ['Ver Materiais'],
      ));
    } else if (msg.contains('preço') || msg.contains('valor') || msg.contains('quanto custa')) {
      responses.add(ChatMessage(
        text: "💰 Nossos preços são super acessíveis:\n\n• Linhas: R\$ 2,80 - R\$ 3,50\n• Agulhas: R\$ 12,00\n• Tesouras: R\$ 25,00\n• Fita Métrica: R\$ 8,50",
        isUser: false,
        time: DateTime.now(),
        hasActions: true,
        actions: ['Ver Todos os Preços'],
      ));
    } else if (msg.contains('agendamento') || msg.contains('agendar') || msg.contains('horário')) {
      responses.add(ChatMessage(
        text: "📅 Posso te ajudar com agendamentos! Você pode agendar consultas para medidas ou retirada de peças.",
        isUser: false,
        time: DateTime.now(),
        hasActions: true,
        actions: ['Ver Agendamentos'],
      ));
    } else if (msg.contains('personalizar') || msg.contains('customizar') || msg.contains('sob medida')) {
      responses.add(ChatMessage(
        text: "✨ Adoramos criar peças únicas! Fazemos roupas totalmente personalizadas do seu jeito.",
        isUser: false,
        time: DateTime.now(),
        hasActions: true,
        actions: ['Personalizar Peça'],
      ));
    } else if (msg.contains('prazo') || msg.contains('entrega') || msg.contains('demora')) {
      responses.add(ChatMessage(
        text: "⏰ Nossos prazos são:\n\n• Materiais: Entrega imediata\n• Roupas sob medida: 7-15 dias\n• Ajustes: 3-5 dias",
        isUser: false,
        time: DateTime.now(),
      ));
    } else if (msg.contains('tamanho') || msg.contains('medida') || msg.contains('tam')) {
      responses.add(ChatMessage(
        text: "📏 Trabalhamos com todos os tamanhos! Do PP ao GG, e também fazemos sob medida.",
        isUser: false,
        time: DateTime.now(),
        hasActions: true,
        actions: ['Tirar Medidas'],
      ));
    } else if (msg.contains('obrigad') || msg.contains('valeu') || msg.contains('brigad')) {
      responses.add(ChatMessage(
        text: "😊 Por nada! Fico feliz em ajudar! Se precisar de mais alguma coisa, é só chamar!",
        isUser: false,
        time: DateTime.now(),
      ));
    } else if (msg.contains('tchau') || msg.contains('até') || msg.contains('bye')) {
      responses.add(ChatMessage(
        text: "👋 Até logo! Volte sempre que precisar! O Ateliê Pano Fino está sempre aqui para você!",
        isUser: false,
        time: DateTime.now(),
      ));
    } else {
      responses.add(ChatMessage(
        text: "🤔 Interessante! Deixe-me te ajudar com isso. O que você gostaria de saber sobre:",
        isUser: false,
        time: DateTime.now(),
        hasActions: true,
        actions: ['Materiais', 'Preços', 'Agendamentos', 'Personalização'],
      ));
    }
    
    return responses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Assistente Virtual',
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
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isTyping) {
                    return _buildTypingIndicator();
                  }
                  return _buildMessageBubble(_messages[index]);
                },
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Align(
            alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  padding: EdgeInsets.all(16),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                  decoration: BoxDecoration(
                    color: message.isUser ? Colors.black87 : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.text,
                        style: TextStyle(
                          color: message.isUser ? Colors.white : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${message.time.hour.toString().padLeft(2, '0')}:${message.time.minute.toString().padLeft(2, '0')}",
                        style: TextStyle(
                          color: message.isUser ? Colors.white70 : Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (message.hasActions && message.actions != null)
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Wrap(
                      spacing: 8,
                      children: message.actions!.map((action) {
                        return ElevatedButton(
                          onPressed: () => _handleAction(action),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[50],
                            foregroundColor: Colors.blue[700],
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(action, style: TextStyle(fontSize: 12)),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Digitando', style: TextStyle(color: Colors.grey[600])),
            SizedBox(width: 8),
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAction(String action) {
    switch (action) {
      case 'Ver Materiais':
      case 'Ver Todos os Preços':
        Navigator.push(context, MaterialPageRoute(builder: (_) => ProdutosPage()));
        break;
      case 'Ver Agendamentos':
        Navigator.push(context, MaterialPageRoute(builder: (_) => AgendamentosPage()));
        break;
      case 'Personalizar Peça':
      case 'Tirar Medidas':
        Navigator.push(context, MaterialPageRoute(builder: (_) => PersonalizacaoPage()));
        break;
      default:
        _sendQuickMessage(action);
    }
  }

  void _sendQuickMessage(String message) {
    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: true,
        time: DateTime.now(),
      ));
      _isTyping = true;
    });

    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        _isTyping = false;
        _messages.addAll(_getSmartResponse(message));
      });
    });
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Digite sua mensagem...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          SizedBox(width: 8),
          FloatingActionButton(
            mini: true,
            onPressed: _sendMessage,
            backgroundColor: Colors.black,
            child: Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;
  final bool hasActions;
  final List<String>? actions;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
    this.hasActions = false,
    this.actions,
  });
}