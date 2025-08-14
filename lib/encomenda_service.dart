import 'package:flutter/material.dart';

class EncomendaService {
  static final EncomendaService _instance = EncomendaService._internal();
  factory EncomendaService() => _instance;
  EncomendaService._internal();

  List<Map<String, dynamic>> _encomendas = [];

  List<Map<String, dynamic>> get encomendas => _encomendas;

  void adicionarEncomenda(Map<String, dynamic> encomenda) {
    final novaEncomenda = {
      'id': (_encomendas.length + 1).toString().padLeft(3, '0'),
      'data': _formatarData(DateTime.now()),
      'status': 'Aguardando',
      'cor': Colors.grey,
      'produto': encomenda['produto'] ?? 'Produto',
      'nome': encomenda['nome'] ?? 'Cliente',
      'telefone': encomenda['telefone'] ?? '',
      'quantidade': encomenda['quantidade'] ?? 1,
      'altura': encomenda['altura'] ?? '',
      'largura': encomenda['largura'] ?? '',
      'busto': encomenda['busto'] ?? '',
      'personalizacao': encomenda['personalizacao'] ?? 'Sem personalização',
      'dataRetirada': encomenda['dataRetirada'] ?? '',
      'horaRetirada': encomenda['horaRetirada'] ?? '',
      'preco': encomenda['preco'] ?? 'R\$ 0,00',
    };
    _encomendas.insert(0, novaEncomenda);
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }
}