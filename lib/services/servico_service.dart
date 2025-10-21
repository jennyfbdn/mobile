import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ServicoService {
  static Future<Map<String, dynamic>> getServicos() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/servico/findAll'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> servicos = json.decode(response.body);
        return {'success': true, 'servicos': servicos};
      } else {
        return {'success': false, 'message': 'Erro ao carregar serviços'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão: $e'};
    }
  }

  static Future<Map<String, dynamic>> getServicoById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/servico/findById/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return {'success': true, 'servico': json.decode(response.body)};
      } else {
        return {'success': false, 'message': 'Serviço não encontrado'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão: $e'};
    }
  }
}