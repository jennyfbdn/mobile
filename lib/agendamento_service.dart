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
      await userService.carregarDados();
      final userId = userService.idUsuario;
      
      double orcamento = _calcularOrcamento(
        agendamento['tipoPersonalizacao'] ?? 'Ajuste de tamanho',
        agendamento['tipoPeca'],
        agendamento['tamanho']
      );
      
      // Formatar data no padrão ISO (yyyy-MM-dd)
      String dataFormatada = '';
      if (agendamento['data'] != null && agendamento['data'].toString().isNotEmpty) {
        try {
          // Se a data está no formato dd/MM/yyyy, converter para yyyy-MM-dd
          final dataParts = agendamento['data'].toString().split('/');
          if (dataParts.length == 3) {
            dataFormatada = '${dataParts[2]}-${dataParts[1].padLeft(2, '0')}-${dataParts[0].padLeft(2, '0')}';
          } else {
            dataFormatada = agendamento['data'].toString();
          }
        } catch (e) {
          dataFormatada = DateTime.now().toIso8601String().split('T')[0];
        }
      } else {
        dataFormatada = DateTime.now().toIso8601String().split('T')[0];
      }
      
      final agendamentoData = {
        'usuarioId': userId ?? 1,
        'usuarioNome': userService.nomeUsuario ?? agendamento['nome'] ?? 'Cliente',
        'servico': agendamento['tipoPeca'] ?? 'Personalização',
        'descricao': agendamento['descricao'] ?? agendamento['tipoPersonalizacao'] ?? 'Sem descrição',
        'dataAgendamento': dataFormatada,
        'horaAgendamento': agendamento['hora'] ?? '09:00',
        'orcamento': orcamento,
        'status': 'PENDENTE'
      };

      print('=== ENVIANDO AGENDAMENTO ===');
      print('URL: ${ApiConfig.baseUrl}/agendamentos');
      print('Dados: ${jsonEncode(agendamentoData)}');

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/agendamentos'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(agendamentoData),
      ).timeout(Duration(seconds: 10));

      print('Status: ${response.statusCode}');
      print('Response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        _adicionarAgendamentoLocal(agendamento);
        return {'success': true, 'message': 'Agendamento salvo no banco!'};
      } else {
        _adicionarAgendamentoLocal(agendamento);
        return {'success': false, 'message': 'Erro ${response.statusCode}: ${response.body}'};
      }
    } catch (e) {
      print('Erro ao enviar agendamento: $e');
      _adicionarAgendamentoLocal(agendamento);
      return {'success': false, 'message': 'Erro: $e'};
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