import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config/api_config.dart';
import 'user_service.dart';

class AgendamentoService {
  static final AgendamentoService _instance = AgendamentoService._internal();
  factory AgendamentoService() => _instance;
  AgendamentoService._internal();

  final List<Map<String, dynamic>> _agendamentos = [];

  List<Map<String, dynamic>> obterAgendamentos() => List.from(_agendamentos);

  Future<Map<String, dynamic>> adicionarAgendamento(Map<String, dynamic> agendamento) async {
    try {
      final userService = UserService();
      final userId = userService.idUsuario;
      
      // Calcular orçamento baseado no tipo de personalização, peça e tamanho
      double orcamento = _calcularOrcamento(
        agendamento['tipoPersonalizacao'] ?? 'Ajuste de tamanho',
        agendamento['tipoPeca'],
        agendamento['tamanho']
      );
      
      final agendamentoData = {
        'usuarioId': userId ?? 1,
        'usuarioNome': userService.nomeUsuario ?? agendamento['nome'] ?? 'Cliente',
        'servico': agendamento['tipoPeca'] ?? 'Personalização',
        'descricao': agendamento['descricao'] ?? agendamento['tipoPersonalizacao'] ?? 'Sem descrição',
        'dataAgendamento': agendamento['data'] ?? '',
        'horaAgendamento': agendamento['hora'] ?? '09:00',
        'orcamento': orcamento,
        'status': 'PENDENTE'
      };

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/agendamento/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(agendamentoData),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        _adicionarAgendamentoLocal(agendamento);
        return {'success': true, 'message': 'Agendamento salvo no banco!'};
      } else {
        _adicionarAgendamentoLocal(agendamento);
        return {'success': false, 'message': 'Erro ${response.statusCode}'};
      }
    } catch (e) {
      _adicionarAgendamentoLocal(agendamento);
      return {'success': false, 'message': 'Backend offline, salvo localmente'};
    }
  }

  void _adicionarAgendamentoLocal(Map<String, dynamic> agendamento) {
    _agendamentos.add(agendamento);
  }
  
  double _calcularOrcamento(String tipoPersonalizacao, [String? tipoPeca, String? tamanho]) {
    final precosPeca = {
      'Vestido': 80.0,
      'Blusa': 60.0,
      'Saia': 50.0,
      'Calça': 70.0,
      'Outro': 65.0,
    };
    
    final multiplicadorTamanho = {
      'PP': 0.9,
      'P': 0.95,
      'M': 1.0,
      'G': 1.1,
      'GG': 1.2,
    };
    
    final precosServico = {
      'Ajuste de tamanho': 25.0,
      'Bordado': 50.0,
      'Aplicação': 40.0,
      'Reforma': 60.0,
      'Outro': 35.0,
    };
    
    double precoPeca = precosPeca[tipoPeca] ?? 65.0;
    double multiplicador = multiplicadorTamanho[tamanho] ?? 1.0;
    double precoServico = precosServico[tipoPersonalizacao] ?? 35.0;
    
    return (precoPeca * multiplicador) + precoServico;
  }
}