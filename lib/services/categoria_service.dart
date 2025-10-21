import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/categoria_model.dart';
import '../config/api_config.dart';

class CategoriaService {
  static Future<List<Categoria>> getCategorias() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/categoria'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Categoria.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao carregar categorias: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  static Future<Categoria> getCategoriaById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/categoria/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Categoria.fromJson(json.decode(response.body));
      } else {
        throw Exception('Categoria não encontrada');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}