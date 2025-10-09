import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'config/api_config.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal() {
    // Configurar para ignorar certificados SSL em desenvolvimento
    if (ApiConfig.allowSelfSignedCertificates) {
      HttpOverrides.global = MyHttpOverrides();
    }
  }

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
      print('=== CADASTRANDO USUÁRIO ===');
      print('URL: ${ApiConfig.usuarioEndpoint}/create');
      print('Nome: $nome, Email: $email, Telefone: $telefone');
      
      final response = await http.post(
        Uri.parse('${ApiConfig.usuarioEndpoint}/testCreate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nome': nome,
          'email': email,
          'telefone': telefone,
          'senha': senha
        }),
      ).timeout(Duration(seconds: 30));
      
      print('Status Code: ${response.statusCode}');
      print('Response: ${response.body}');
      print('Response Headers: ${response.headers}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        setUsuario(nome, email, telefone);
        return {'success': true, 'message': 'Usuário cadastrado com sucesso!'};
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        return {'success': false, 'message': errorData['message'] ?? 'Dados inválidos'};
      } else if (response.statusCode == 409) {
        return {'success': false, 'message': 'Email já cadastrado'};
      } else {
        return {'success': false, 'message': 'Erro no servidor: ${response.statusCode}'};
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Timeout: Verifique sua conexão'};
    } on SocketException {
      return {'success': false, 'message': 'Erro de rede: Verifique se o servidor está rodando'};
    } catch (e) {
      print('Erro detalhado: $e');
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
        setUsuario(userData['nome'], userData['email'], userData['telefone'] ?? '', userData['id']);
        return {'success': true, 'user': userData};
      } else {
        return {'success': false, 'message': 'Email ou senha incorretos'};
      }
    } catch (e) {
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