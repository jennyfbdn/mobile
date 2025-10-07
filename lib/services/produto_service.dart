import 'dart:convert';
import 'package:app_atelie/models/produto_model.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ProdutoService {
  final String baseUrl = "${ApiConfig.baseUrl}/produto";

  Future<List<Produto>> fetchProdutos() async {
    final response = await http.get(Uri.parse('$baseUrl/findAll'));

    if (response.statusCode == 200) {
      // Parse a resposta JSON e mapeie para uma lista de Produto
      List<dynamic> data = jsonDecode(response.body);
      return data.map((produtoJson) {
        return Produto.fromJson({
          'id': produtoJson['id'],
          'nome': produtoJson['nome'],
          'tipo': produtoJson['tipo'],
          'descricao': produtoJson['descricao'],
          'codigoBarras': produtoJson['codigoBarras'],
          'fotoUrl': produtoJson['fotoUrl'] ?? '', // Fallback para string vazia
          'preco': produtoJson['preco'],
          'statusProduto': produtoJson['statusProduto'],
        });
      }).toList();
    } else {
      throw Exception('Falha ao carregar produtos');
    }
  }
}
