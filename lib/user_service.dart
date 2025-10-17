import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'config/api_config.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  String? _nomeUsuario;
  String? _emailUsuario;
  String? _telefoneUsuario;
  String? _enderecoUsuario;
  int? _idUsuario;
  Map<String, String> _medidasUsuario = {};

  String? get nomeUsuario => _nomeUsuario;
  String? get emailUsuario => _emailUsuario;
  String? get telefoneUsuario => _telefoneUsuario;
  String? get enderecoUsuario => _enderecoUsuario;
  int? get idUsuario => _idUsuario;
  Map<String, String> get medidasUsuario => Map.from(_medidasUsuario);

  void setUsuario(String nome, String email, String telefone, [int? id, String? endereco]) {
    _nomeUsuario = nome;
    _emailUsuario = email;
    _telefoneUsuario = telefone;
    _enderecoUsuario = endereco;
    _idUsuario = id;
    _salvarDados();
  }

  Future<void> _salvarDados() async {
    final prefs = await SharedPreferences.getInstance();
    if (_nomeUsuario != null) await prefs.setString('nome', _nomeUsuario!);
    if (_emailUsuario != null) await prefs.setString('email', _emailUsuario!);
    if (_telefoneUsuario != null) await prefs.setString('telefone', _telefoneUsuario!);
    if (_enderecoUsuario != null) await prefs.setString('endereco', _enderecoUsuario!);
    if (_idUsuario != null) await prefs.setInt('id', _idUsuario!);
    await prefs.setString('medidas', jsonEncode(_medidasUsuario));
  }

  Future<void> carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    _nomeUsuario = prefs.getString('nome');
    _emailUsuario = prefs.getString('email');
    _telefoneUsuario = prefs.getString('telefone');
    _enderecoUsuario = prefs.getString('endereco');
    _idUsuario = prefs.getInt('id');
    final medidasJson = prefs.getString('medidas');
    if (medidasJson != null) {
      _medidasUsuario = Map<String, String>.from(jsonDecode(medidasJson));
    }
  }

  void atualizarPerfil({
    String? nome,
    String? email, 
    String? telefone,
    String? endereco,
  }) {
    if (nome != null) _nomeUsuario = nome;
    if (email != null) _emailUsuario = email;
    if (telefone != null) _telefoneUsuario = telefone;
    if (endereco != null) _enderecoUsuario = endereco;
    _salvarDados();
  }

  void salvarMedidas(Map<String, String> medidas) {
    _medidasUsuario = Map.from(medidas);
    _salvarDados();
  }

  bool temMedidas() {
    return _medidasUsuario.isNotEmpty && _medidasUsuario.values.any((v) => v.isNotEmpty);
  }

  bool get temUsuario => _nomeUsuario != null && _nomeUsuario!.isNotEmpty;

  Future<bool> testarConexao() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}'),
      ).timeout(Duration(seconds: 5));
      return response.statusCode == 200 || response.statusCode == 404;
    } catch (e) {
      print('Erro ao testar conexão: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> cadastrarUsuario({
    required String nome,
    required String email,
    required String telefone,
    required String senha,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.usuarioEndpoint}/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nome': nome,
          'email': email,
          'telefone': telefone,
          'senha': senha
        }),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        setUsuario(nome, email, telefone);
        return {'success': true, 'message': 'Usuário cadastrado com sucesso!'};
      } else if (response.statusCode == 409) {
        return {'success': false, 'message': 'E-mail já cadastrado'};
      } else {
        return {'success': false, 'message': 'Erro no servidor. Tente novamente.'};
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Tempo limite excedido. Verifique sua conexão.'};
    } catch (e) {
      return {'success': false, 'message': 'Erro de conexão. Verifique se está conectado à internet.'};
    }
  }

  Future<Map<String, dynamic>> login(String email, String senha) async {
    try {
      print('Tentando login para: $email');
      print('URL: ${ApiConfig.usuarioEndpoint}/login');
      
      final response = await http.post(
        Uri.parse('${ApiConfig.usuarioEndpoint}/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'senha': senha,
        }),
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        setUsuario(userData['nome'], userData['email'], userData['telefone'] ?? '', userData['id']);
        return {'success': true, 'user': userData};
      } else if (response.statusCode == 401) {
        return {'success': false, 'message': 'E-mail ou senha incorretos'};
      } else if (response.statusCode == 404) {
        return {'success': false, 'message': 'Servidor não encontrado. Verifique se o backend está rodando.'};
      } else if (response.statusCode >= 500) {
        return {'success': false, 'message': 'Erro interno do servidor. Tente novamente em alguns minutos.'};
      } else {
        return {'success': false, 'message': 'Erro no servidor (${response.statusCode}). Tente novamente.'};
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Tempo limite excedido. Verifique sua conexão e se o servidor está rodando.'};
    } on SocketException {
      return {'success': false, 'message': 'Erro de conexão. Verifique se o servidor está rodando na porta 8080.'};
    } catch (e) {
      print('Erro no login: $e');
      return {'success': false, 'message': 'Erro de conexão: $e'};
    }
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}