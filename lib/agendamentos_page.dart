import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'agendamento_service.dart';
import 'profile_page.dart';
import 'produtos_page.dart';
import 'encomenda_service.dart';
import 'user_service.dart';
import 'personalizacao_agendamento_page.dart';
import 'config/api_config.dart';
import 'detalhes_agendamento_page.dart';

class AgendamentosPage extends StatefulWidget {
  @override
  _AgendamentosPageState createState() => _AgendamentosPageState();
}

class _AgendamentosPageState extends State<AgendamentosPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  List<Map<String, dynamic>> encomendas = [];
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
    _carregarEncomendas();
  }
  
  Future<void> _carregarEncomendas() async {
    try {
      final userId = UserService().idUsuario;
      if (userId != null) {
        final response = await http.get(
          Uri.parse('${ApiConfig.baseUrl}/agendamento/usuario/$userId'),
          headers: {'Content-Type': 'application/json'},
        );
        
        if (response.statusCode == 200) {
          final List<dynamic> agendamentosBackend = jsonDecode(response.body);
          setState(() {
            encomendas = agendamentosBackend.map((e) => Map<String, dynamic>.from(e)).toList();
            isLoading = false;
          });
          return;
        }
      }
    } catch (e) {
      print('Erro ao carregar agendamentos: $e');
    }
    
    final agendamentosLocais = AgendamentoService().obterAgendamentos();
    setState(() {
      encomendas = agendamentosLocais;
      isLoading = false;
    });
  }

  Widget _buildEmptyState() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey[400]),
            ),
            SizedBox(height: 24),
            Text(
              'Nenhum agendamento',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Você ainda não possui agendamentos.\nQue tal agendar uma personalização?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PersonalizacaoAgendamentoPage()),
                );
              },
              icon: Icon(Icons.add),
              label: Text('Agendar Personalização'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFB6C1),
                foregroundColor: Colors.black87,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgendamentoCard(Map<String, dynamic> agendamento, int index) {
    final status = agendamento['statusAgendamento'] ?? agendamento['status'] ?? 'PENDENTE';
    final servico = agendamento['tipoServico'] ?? agendamento['servico'] ?? agendamento['produto'] ?? 'Serviço';
    final data = agendamento['dataAgendamento'] ?? agendamento['data'] ?? 'Data não informada';
    final observacoes = agendamento['observacoes'] ?? '';
    
    Color statusColor = _getStatusColor(status);
    IconData statusIcon = _getStatusIcon(status);
    
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetalhesAgendamentoPage(agendamento: agendamento),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(statusIcon, color: statusColor, size: 20),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  servico,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _getStatusText(status),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
                        ],
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.grey[600], size: 16),
                            SizedBox(width: 8),
                            Text(
                              _formatarData(data),
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (observacoes.isNotEmpty) ...[
                        SizedBox(height: 12),
                        Text(
                          'Observações:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          observacoes,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'CONFIRMADO':
        return Color(0xFFFFB6C1);
      case 'PENDENTE':
        return Colors.black54;
      case 'CANCELADO':
        return Colors.black87;
      case 'CONCLUIDO':
        return Color(0xFFFFB6C1);
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'CONFIRMADO':
        return Icons.check_circle;
      case 'PENDENTE':
        return Icons.schedule;
      case 'CANCELADO':
        return Icons.cancel;
      case 'CONCLUIDO':
        return Icons.done_all;
      default:
        return Icons.help;
    }
  }

  String _getStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'CONFIRMADO':
        return 'Confirmado';
      case 'PENDENTE':
        return 'Pendente';
      case 'CANCELADO':
        return 'Cancelado';
      case 'CONCLUIDO':
        return 'Concluído';
      default:
        return status;
    }
  }

  String _formatarData(String data) {
    try {
      if (data.contains('T')) {
        final dateTime = DateTime.parse(data);
        return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} às ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      }
      return data;
    } catch (e) {
      return data;
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Agendamentos de Personalização'),
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
          : encomendas.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: _carregarEncomendas,
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: encomendas.length,
                itemBuilder: (context, index) {
                  final agendamento = encomendas[index];
                  return _buildAgendamentoCard(agendamento, index);
                },
              ),
            ),
    );
  }
}