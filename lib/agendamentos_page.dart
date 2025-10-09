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
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Nenhum agendamento encontrado'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => PersonalizacaoAgendamentoPage()),
                      );
                    },
                    child: Text('Agendar Personalização'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: encomendas.length,
              itemBuilder: (context, index) {
                final agendamento = encomendas[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    title: Text(agendamento['servico'] ?? agendamento['produto'] ?? 'Serviço'),
                    subtitle: Text(agendamento['data'] ?? 'Data não informada'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetalhesAgendamentoPage(agendamento: agendamento),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}