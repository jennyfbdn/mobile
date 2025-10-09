import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config/api_config.dart';
import 'user_service.dart';

class EncomendaService {
  static final EncomendaService _instance = EncomendaService._internal();
  factory EncomendaService() => _instance;
  EncomendaService._internal();

  List<Map<String, dynamic>> _encomendas = [];

  List<Map<String, dynamic>> get encomendas => _encomendas;

  Future<Map<String, dynamic>> adicionarEncomenda(Map<String, dynamic> encomenda) async {
    try {
      final userService = UserService();
      final userId = userService.idUsuario;
      final medidas = userService.medidasUsuario;
      
      String precoLimpo = (encomenda['preco'] ?? 'R\$ 0,00')
          .toString()
          .replaceAll('R\$ ', '')
          .replaceAll(',', '.');
      
      final encomendaData = {
        'usuarioId': userId ?? 1,
        'usuarioNome': userService.nomeUsuario ?? encomenda['nome'] ?? 'Cliente',
        'produto': encomenda['produto'] ?? 'Produto',
        'quantidade': encomenda['quantidade'] ?? 1,
        // Usar medidas salvas do usuário ou valores da encomenda
        'altura': medidas['altura']?.isNotEmpty == true ? medidas['altura'] : (encomenda['altura'] ?? ''),
        'largura': medidas['cintura']?.isNotEmpty == true ? medidas['cintura'] : (encomenda['largura'] ?? ''),
        'busto': medidas['busto']?.isNotEmpty == true ? medidas['busto'] : (encomenda['busto'] ?? ''),
        'personalizacao': encomenda['personalizacao'] ?? 'Sem personalização',
        'dataRetirada': encomenda['dataRetirada'] ?? '',
        'horaRetirada': encomenda['horaRetirada'] ?? '',
        'localizacao': encomenda['localizacao'] ?? 'Não informado',
        'preco': double.tryParse(precoLimpo) ?? 0.0,
        'status': 'PENDENTE'
      };

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/encomenda/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(encomendaData),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        _adicionarEncomendaLocal(encomenda);
        return {'success': true, 'message': 'Encomenda salva no banco!'};
      } else {
        _adicionarEncomendaLocal(encomenda);
        return {'success': false, 'message': 'Erro ${response.statusCode}'};
      }
    } catch (e) {
      _adicionarEncomendaLocal(encomenda);
      return {'success': false, 'message': 'Backend offline, salvo localmente'};
    }
  }

  void _adicionarEncomendaLocal(Map<String, dynamic> encomenda) {
    final userService = UserService();
    final medidas = userService.medidasUsuario;
    
    final novaEncomenda = {
      'id': (_encomendas.length + 1).toString().padLeft(3, '0'),
      'data': _formatarData(DateTime.now()),
      'status': 'Aguardando',
      'cor': Colors.grey,
      'produto': encomenda['produto'] ?? 'Produto',
      'nome': userService.nomeUsuario ?? encomenda['nome'] ?? 'Cliente',
      'telefone': userService.telefoneUsuario ?? encomenda['telefone'] ?? '',
      'endereco': userService.enderecoUsuario ?? '',
      'quantidade': encomenda['quantidade'] ?? 1,
      // Usar medidas salvas do usuário
      'altura': medidas['altura']?.isNotEmpty == true ? medidas['altura'] : (encomenda['altura'] ?? ''),
      'largura': medidas['cintura']?.isNotEmpty == true ? medidas['cintura'] : (encomenda['largura'] ?? ''),
      'busto': medidas['busto']?.isNotEmpty == true ? medidas['busto'] : (encomenda['busto'] ?? ''),
      'personalizacao': encomenda['personalizacao'] ?? 'Sem personalização',
      'dataRetirada': encomenda['dataRetirada'] ?? '',
      'horaRetirada': encomenda['horaRetirada'] ?? '',
      'localizacao': encomenda['localizacao'] ?? 'Não informado',
      'preco': encomenda['preco'] ?? 'R\$ 0,00',
    };
    _encomendas.insert(0, novaEncomenda);
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }
}