import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config/api_config.dart';
import 'theme/app_theme.dart';
import 'theme/elegant_components.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<Map<String, dynamic>> _encomendas = [];
  List<Map<String, dynamic>> _agendamentos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() {
      _isLoading = true;
    });

    await Future.wait([
      _carregarEncomendas(),
      _carregarAgendamentos(),
    ]);

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _carregarEncomendas() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/encomenda/findAll'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _encomendas = data.map((item) => Map<String, dynamic>.from(item)).toList();
        });
      }
    } catch (e) {
      print('Erro ao carregar encomendas: $e');
    }
  }

  Future<void> _carregarAgendamentos() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/agendamento/findAll'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _agendamentos = data.map((item) => Map<String, dynamic>.from(item)).toList();
        });
      }
    } catch (e) {
      print('Erro ao carregar agendamentos: $e');
    }
  }

  Future<void> _marcarEncomendaPronta(int encomendaId) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/encomenda/$encomendaId/pronta'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Encomenda marcada como pronta e cliente notificado!'),
            backgroundColor: Colors.green,
          ),
        );
        _carregarEncomendas();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao marcar encomenda como pronta: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _enviarNotificacaoTeste() async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/notificacao/enviar'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usuarioId': 1, // ID do usuário de teste
          'titulo': 'Notificação de Teste 🧪',
          'mensagem': 'Esta é uma notificação de teste enviada pelo administrador.',
          'tipo': 'GERAL',
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notificação de teste enviada!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao enviar notificação: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.elegantGray,
      appBar: ElegantComponents.elegantAppBar(
        title: 'Painel Administrativo',
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: AppTheme.accentGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(Icons.refresh, color: AppTheme.accentGold),
              onPressed: _carregarDados,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.pureWhite,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: AppTheme.subtleShadow,
                    ),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentGold),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Carregando dados...',
                    style: TextStyle(
                      color: AppTheme.textGray,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header do painel
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: AppTheme.darkGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppTheme.elegantShadow,
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.dashboard, size: 48, color: AppTheme.pureWhite),
                        SizedBox(height: 16),
                        Text(
                          'Painel Administrativo',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.pureWhite,
                          ),
                        ),
                        Text(
                          'Gerencie encomendas e agendamentos',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.pureWhite.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
                  // Painel de controle elegante
                  Container(
                    decoration: AppTheme.elegantContainer,
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: AppTheme.goldGradient,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.admin_panel_settings, color: AppTheme.pureWhite, size: 24),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Painel de Controle',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.primaryBlack,
                                    ),
                                  ),
                                  Text(
                                    'Gerencie notificações e testes do sistema',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.textGray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        ElegantComponents.primaryButton(
                          text: 'Enviar Notificação de Teste',
                          onPressed: _enviarNotificacaoTeste,
                          icon: Icons.notifications_active,
                          width: double.infinity,
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Seção de Encomendas
                  ElegantComponents.sectionTitle(
                    title: 'Encomendas',
                    subtitle: '${_encomendas.length} encomendas encontradas',
                  ),
                  SizedBox(height: 16),
                  
                  if (_encomendas.isEmpty)
                    Container(
                      decoration: AppTheme.elegantContainer,
                      padding: EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(Icons.shopping_bag_outlined, size: 48, color: AppTheme.textGray),
                          SizedBox(height: 16),
                          Text(
                            'Nenhuma encomenda encontrada',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.textGray,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ..._encomendas.map((encomenda) {
                      final isPronta = encomenda['statusEncomenda'] == 'PRONTA';
                      return Container(
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: AppTheme.elegantContainer,
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
                                      color: isPronta ? Colors.green.withOpacity(0.1) : AppTheme.accentGold.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      isPronta ? Icons.check_circle : Icons.schedule,
                                      color: isPronta ? Colors.green : AppTheme.accentGold,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          encomenda['usuarioNome'] ?? 'Cliente não identificado',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: AppTheme.primaryBlack,
                                          ),
                                        ),
                                        Text(
                                          encomenda['produto'] ?? 'Produto não especificado',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.textGray,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: isPronta ? Colors.green : AppTheme.accentGold,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      encomenda['statusEncomenda'] ?? 'N/A',
                                      style: TextStyle(
                                        color: AppTheme.pureWhite,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (!isPronta) ..[
                                SizedBox(height: 16),
                                ElegantComponents.primaryButton(
                                  text: 'Marcar como Pronta',
                                  onPressed: () => _marcarEncomendaPronta(encomenda['id']),
                                  icon: Icons.check_circle,
                                  width: double.infinity,
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  
                  SizedBox(height: 24),
                  
                  // Seção de Agendamentos
                  ElegantComponents.sectionTitle(
                    title: 'Agendamentos',
                    subtitle: '${_agendamentos.length} agendamentos encontrados',
                  ),
                  SizedBox(height: 16),
                  
                  if (_agendamentos.isEmpty)
                    Container(
                      decoration: AppTheme.elegantContainer,
                      padding: EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 48, color: AppTheme.textGray),
                          SizedBox(height: 16),
                          Text(
                            'Nenhum agendamento encontrado',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.textGray,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ..._agendamentos.map((agendamento) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: AppTheme.elegantContainer,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: AppTheme.primaryGradient,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.event, color: AppTheme.primaryBlack, size: 20),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      agendamento['usuarioNome'] ?? 'Cliente não identificado',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: AppTheme.primaryBlack,
                                      ),
                                    ),
                                    Text(
                                      agendamento['tipoServico'] ?? 'Serviço não especificado',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppTheme.textGray,
                                      ),
                                    ),
                                    if (agendamento['dataAgendamento'] != null)
                                      Text(
                                        'Data: ${agendamento['dataAgendamento']}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.textGray,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryBlack,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  agendamento['statusAgendamento'] ?? 'N/A',
                                  style: TextStyle(
                                    color: AppTheme.pureWhite,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}