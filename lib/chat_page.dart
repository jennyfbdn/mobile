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
    
    if (msg.contains('oi') || msg.contains('olá') || msg.contains('ola') || msg.contains('bom dia') || msg.contains('boa tarde')) {
      responses.add(ChatMessage(
        text: "Olá! 😊 Bem-vindo ao Ateliê Pano Fino! Sou a Ana, sua assistente virtual. Como posso te ajudar hoje?",
        isUser: false,
        time: DateTime.now(),
        hasActions: true,
        actions: ['Ver Catálogo', 'Agendar Consulta', 'Sobre Nós'],
      ));
    } else if (msg.contains('produto') || msg.contains('comprar') || msg.contains('loja') || msg.contains('catálogo')) {
      responses.add(ChatMessage(
        text: "🛍️ Temos uma coleção incrível! Materiais de costura, roupas prontas e peças sob medida.",
        isUser: false,
        time: DateTime.now(),
      ));
      responses.add(ChatMessage(
        text: "Nossos destaques:\n• Linhas premium\n• Agulhas profissionais\n• Roupas femininas e masculinas\n• Peças personalizadas",
        isUser: false,
        time: DateTime.now(),
        hasActions: true,
        actions: ['Ver Materiais', 'Ver Roupas'],
      ));
    } else if (msg.contains('preço') || msg.contains('valor') || msg.contains('quanto') || msg.contains('custa')) {
      responses.add(ChatMessage(
        text: "💰 Nossos preços são justos e competitivos:\n\n🧵 Materiais:\n• Linhas: R\$ 2,80 - R\$ 3,50\n• Agulhas: R\$ 12,00\n• Tesouras: R\$ 25,00\n\n👗 Roupas:\n• Blusas: R\$ 45 - R\$ 120\n• Vestidos: R\$ 80 - R\$ 200\n• Conjuntos: R\$ 90 - R\$ 180",
        isUser: false,
        time: DateTime.now(),
        hasActions: true,
        actions: ['Ver Catálogo Completo'],
      ));
    } else if (msg.contains('agend') || msg.contains('consulta') || msg.contains('horário') || msg.contains('marca')) {
      responses.add(ChatMessage(
        text: "📅 Perfeito! Oferecemos consultas para:\n\n• Tirar medidas\n• Escolher tecidos\n• Provas de roupas\n• Consultoria de estilo",
        isUser: false,
        time: DateTime.now(),
      ));
      responses.add(ChatMessage(
        text: "Horários disponíveis:\nSeg-Sex: 9h às 18h\nSábado: 9h às 14h",
        isUser: false,
        time: DateTime.now(),
        hasActions: true,
        actions: ['Agendar Agora'],
      ));
    } else if (msg.contains('personaliz') || msg.contains('sob medida') || msg.contains('exclusiv')) {
      responses.add(ChatMessage(
        text: "✨ Especialidade da casa! Criamos peças únicas e exclusivas para você.",
        isUser: false,
        time: DateTime.now(),
      ));
      responses.add(ChatMessage(
        text: "Processo:\n1️⃣ Consulta e medidas\n2️⃣ Escolha do tecido\n3️⃣ Modelagem\n4️⃣ Confecção\n5️⃣ Prova final",
        isUser: false,
        time: DateTime.now(),
        hasActions: true,
        actions: ['Iniciar Personalização'],
      ));
    } else if (msg.contains('prazo') || msg.contains('entrega') || msg.contains('demora') || msg.contains('tempo')) {
      responses.add(ChatMessage(
        text: "⏰ Nossos prazos de entrega:\n\n🏃‍♀️ Rápido:\n• Materiais: Imediato\n• Ajustes simples: 2-3 dias\n\n🕰️ Personalizado:\n• Roupas sob medida: 7-15 dias\n• Peças complexas: 15-20 dias",
        isUser: false,
        time: DateTime.now(),
      ));
    } else if (msg.contains('localiza') || msg.contains('endereço') || msg.contains('onde') || msg.contains('fica')) {
      responses.add(ChatMessage(
        text: "📍 Estamos localizados no coração da cidade! Você pode nos encontrar facilmente.",
        isUser: false,
        time: DateTime.now(),
        hasActions: true,
        actions: ['Ver Localização'],
      ));
    } else if (msg.contains('obrigad') || msg.contains('valeu') || msg.contains('brigad')) {
      responses.add(ChatMessage(
        text: "😊 Fico muito feliz em ajudar! O Ateliê Pano Fino está sempre à disposição. Volte sempre! 💖",
        isUser: false,
        time: DateTime.now(),
      ));
    } else if (msg.contains('tchau') || msg.contains('até') || msg.contains('bye') || msg.contains('fui')) {
      responses.add(ChatMessage(
        text: "👋 Até logo! Foi um prazer conversar com você. Esperamos te ver em breve no ateliê! ✨",
        isUser: false,
        time: DateTime.now(),
      ));
    } else if (msg.contains('ajuda') || msg.contains('help') || msg.contains('como')) {
      responses.add(ChatMessage(
        text: "🎆 Claro! Estou aqui para te ajudar com tudo sobre o Ateliê Pano Fino. Escolha o que te interessa:",
        isUser: false,
        time: DateTime.now(),
        hasActions: true,
        actions: ['Produtos', 'Serviços', 'Agendamentos', 'Localização'],
      ));
    } else {
      responses.add(ChatMessage(
        text: "🤔 Hmm, não tenho certeza se entendi. Mas posso te ajudar com essas opções:",
        isUser: false,
        time: DateTime.now(),
        hasActions: true,
        actions: ['Catálogo', 'Agendamentos', 'Preços', 'Localização'],
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
      case 'Ver Roupas':
      case 'Ver Catálogo':
      case 'Catálogo':
      case 'Ver Catálogo Completo':
        Navigator.push(context, MaterialPageRoute(builder: (_) => ProdutosPage()));
        break;
      case 'Ver Agendamentos':
      case 'Agendamentos':
        Navigator.push(context, MaterialPageRoute(builder: (_) => AgendamentosPage()));
        break;
      case 'Agendar Consulta':
      case 'Agendar Agora':
      case 'Personalizar Peça':
      case 'Iniciar Personalização':
      case 'Tirar Medidas':
        Navigator.push(context, MaterialPageRoute(builder: (_) => PersonalizacaoPage()));
        break;
      case 'Ver Localização':
      case 'Localização':
        Navigator.pushNamed(context, '/localizacao');
        break;
      case 'Sobre Nós':
        Navigator.pushNamed(context, '/sobre-atelie');
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