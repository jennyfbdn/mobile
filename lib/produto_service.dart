import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config/api_config.dart';

class ProdutoService {
  static final ProdutoService _instance = ProdutoService._internal();
  factory ProdutoService() => _instance;
  ProdutoService._internal();

  Future<Map<String, dynamic>> listarProdutos() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/produto/findAll'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> produtos = jsonDecode(response.body);
        return {'success': true, 'produtos': produtos};
      } else {
        return {'success': false, 'message': 'Erro ao carregar produtos'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão: $e'};
    }
  }

  Future<Map<String, dynamic>> listarProdutosPorTipo(String tipo) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/produto/findByTipo/$tipo'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> produtos = jsonDecode(response.body);
        return {'success': true, 'produtos': produtos};
      } else {
        return {'success': false, 'message': 'Erro ao carregar produtos'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão: $e'};
    }
  }

  Future<Map<String, dynamic>> buscarProdutoPorId(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/produto/findById/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final produto = jsonDecode(response.body);
        return {'success': true, 'produto': produto};
      } else {
        return {'success': false, 'message': 'Produto não encontrado'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão: $e'};
    }
  }
}