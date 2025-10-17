import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config/api_config.dart';

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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Painel Administrativo'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        centerTitle: true,
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _carregarDados,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Botão de teste
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ações de Teste',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _enviarNotificacaoTeste,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            child: Text('Enviar Notificação de Teste'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Encomendas
                  Text(
                    'Encomendas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  if (_encomendas.isEmpty)
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Nenhuma encomenda encontrada'),
                      ),
                    )
                  else
                    ..._encomendas.map((encomenda) {
                      return Card(
                        margin: EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cliente: ${encomenda['usuarioNome'] ?? 'N/A'}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Produto: ${encomenda['produto'] ?? 'N/A'}'),
                              Text('Status: ${encomenda['statusEncomenda'] ?? 'N/A'}'),
                              SizedBox(height: 8),
                              if (encomenda['statusEncomenda'] != 'PRONTA')
                                ElevatedButton(
                                  onPressed: () => _marcarEncomendaPronta(encomenda['id']),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text('Marcar como Pronta'),
                                )
                              else
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'PRONTA',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  
                  SizedBox(height: 24),
                  
                  // Agendamentos
                  Text(
                    'Agendamentos',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  if (_agendamentos.isEmpty)
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Nenhum agendamento encontrado'),
                      ),
                    )
                  else
                    ..._agendamentos.map((agendamento) {
                      return Card(
                        margin: EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cliente: ${agendamento['usuarioNome'] ?? 'N/A'}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Serviço: ${agendamento['tipoServico'] ?? 'N/A'}'),
                              Text('Status: ${agendamento['statusAgendamento'] ?? 'N/A'}'),
                              if (agendamento['dataAgendamento'] != null)
                                Text('Data: ${agendamento['dataAgendamento']}'),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
    );
  }
}