import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config/api_config.dart';

class ServicoService {
  static final ServicoService _instance = ServicoService._internal();
  factory ServicoService() => _instance;
  ServicoService._internal();

  Future<Map<String, dynamic>> listarServicos() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/servico/findAll'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> servicos = jsonDecode(response.body);
        return {'success': true, 'servicos': servicos};
      } else {
        return {'success': false, 'message': 'Erro ao carregar serviços'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão: $e'};
    }
  }

  Future<Map<String, dynamic>> buscarServicoPorId(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/servico/findById/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final servico = jsonDecode(response.body);
        return {'success': true, 'servico': servico};
      } else {
        return {'success': false, 'message': 'Serviço não encontrado'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão: $e'};
    }
  }
}