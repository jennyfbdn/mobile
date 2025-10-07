import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config/api_config.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  String? _nomeUsuario;
  String? _telefoneUsuario;
  int? _idUsuario;

  String? get nomeUsuario => _nomeUsuario;
  String? get telefoneUsuario => _telefoneUsuario;
  int? get idUsuario => _idUsuario;

  void setUsuario(String nome, String telefone, [int? id]) {
    _nomeUsuario = nome;
    _telefoneUsuario = telefone;
    _idUsuario = id;
  }

  bool get temUsuario => _nomeUsuario != null && _nomeUsuario!.isNotEmpty;

  Future<Map<String, dynamic>> cadastrarUsuario({
    required String nome,
    required String email,
    required String senha,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.usuarioEndpoint}/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nome': nome,
          'email': email,
          'senha': senha,
          'nivelAcesso': 'USER',
          'statusUsuario': 'ATIVO',
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Usuário cadastrado com sucesso!'};
      } else {
        return {'success': false, 'message': 'Erro ao cadastrar usuário'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão: $e'};
    }
  }

  Future<Map<String, dynamic>> login(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.usuarioEndpoint}/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'senha': senha,
        }),
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        setUsuario(userData['nome'], userData['telefone'] ?? '', userData['id']);
        return {'success': true, 'user': userData};
      } else {
        return {'success': false, 'message': 'Email ou senha incorretos'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão: $e'};
    }
  }
}