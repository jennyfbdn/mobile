import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/produto_model.dart';

class ProdutoService {
  final String baseUrl = "${ApiConfig.baseUrl}/produto";

  Future<List<Produto>> fetchProdutos() async {
    final response = await http.get(Uri.parse('$baseUrl/findAll'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      print('=== DEBUG API RESPONSE ===');
      if (data.isNotEmpty) {
        print('Primeiro produto completo: ${data[0]}');
        print('Campos disponíveis: ${data[0].keys.toList()}');
      }
      return data.map((produtoJson) {
        // Tenta diferentes nomes de campos para imagem
        String? imagemData = produtoJson['fotoUrl'] ?? 
                           produtoJson['foto'] ?? 
                           produtoJson['imagem'] ?? 
                           produtoJson['image'] ?? 
                           produtoJson['fotoBase64'] ?? '';
        
        print('Produto: ${produtoJson['nome']}, ImagemData: ${imagemData?.length ?? 0} chars');
        
        return Produto.fromJson({
          'id': produtoJson['id'],
          'nome': produtoJson['nome'],
          'tipo': produtoJson['tipo'],
          'descricao': produtoJson['descricao'],
          'codigoBarras': produtoJson['codigoBarras'],
          'fotoUrl': imagemData ?? '',
          'preco': produtoJson['preco'],
          'statusProduto': produtoJson['statusProduto'],
        });
      }).toList();
    } else {
      throw Exception('Falha ao carregar produtos');
    }
  }

  Future<Map<String, dynamic>> listarProdutosPorTipo(String tipo) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/findByTipo/$tipo'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> produtos = json.decode(response.body);
        return {'success': true, 'produtos': produtos};
      } else {
        return {'success': false, 'message': 'Erro ao carregar produtos'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão: $e'};
    }
  }
}
