import 'package:flutter/material.dart';
import 'notification_service.dart';

class NotificacoesPage extends StatefulWidget {
  @override
  _NotificacoesPageState createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  final NotificationService _notificationService = NotificationService();
  List<Map<String, dynamic>> _notificacoes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarNotificacoes();
  }

  Future<void> _carregarNotificacoes() async {
    setState(() {
      _isLoading = true;
    });

    final notificacoes = await _notificationService.buscarNotificacoes();
    
    setState(() {
      _notificacoes = notificacoes;
      _isLoading = false;
    });
  }

  Future<void> _marcarComoLida(int notificacaoId, int index) async {
    final sucesso = await _notificationService.marcarComoLida(notificacaoId);
    
    if (sucesso) {
      setState(() {
        _notificacoes[index]['lida'] = true;
      });
    }
  }

  String _formatarTempo(String? dataEnvio) {
    if (dataEnvio == null) return 'agora';
    
    try {
      final data = DateTime.parse(dataEnvio);
      final agora = DateTime.now();
      final diferenca = agora.difference(data);
      
      if (diferenca.inMinutes < 60) {
        return '${diferenca.inMinutes}m atrás';
      } else if (diferenca.inHours < 24) {
        return '${diferenca.inHours}h atrás';
      } else {
        return '${diferenca.inDays}d atrás';
      }
    } catch (e) {
      return 'agora';
    }
  }

  IconData _getIconePorTipo(String tipo) {
    switch (tipo) {
      case 'ENCOMENDA':
        return Icons.shopping_bag;
      case 'AGENDAMENTO':
        return Icons.calendar_today;
      default:
        return Icons.notifications;
    }
  }

  Color _getCorPorTipo(String tipo) {
    switch (tipo) {
      case 'ENCOMENDA':
        return Color(0xFFFFB6C1);
      case 'AGENDAMENTO':
        return Colors.black87;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Notificações'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        centerTitle: true,
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _carregarNotificacoes,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _notificacoes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Nenhuma notificação',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Você será notificado quando houver novidades',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _carregarNotificacoes,
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: _notificacoes.length,
                itemBuilder: (context, index) {
                  final notificacao = _notificacoes[index];
                  final isLida = notificacao['lida'] ?? false;
                  
                  return Card(
                    margin: EdgeInsets.only(bottom: 12),
                    elevation: isLida ? 1 : 3,
                    child: InkWell(
                      onTap: () {
                        if (!isLida) {
                          _marcarComoLida(notificacao['id'], index);
                        }
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: isLida ? Colors.white : Color(0xFFFFB6C1).withOpacity(0.1),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _getCorPorTipo(notificacao['tipo']),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                _getIconePorTipo(notificacao['tipo']),
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          notificacao['titulo'] ?? 'Notificação',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: isLida ? Colors.grey[700] : Colors.black87,
                                          ),
                                        ),
                                      ),
                                      if (!isLida)
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFFFB6C1),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    notificacao['mensagem'] ?? '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isLida ? Colors.grey[600] : Colors.grey[800],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    _formatarTempo(notificacao['dataEnvio']),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}