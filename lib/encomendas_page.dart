import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'encomenda_service.dart';
import 'detalhes_encomenda_page.dart';
import 'profile_page.dart';
import 'config/api_config.dart';

class EncomendasPage extends StatefulWidget {
  @override
  _EncomendasPageState createState() => _EncomendasPageState();
}

class _EncomendasPageState extends State<EncomendasPage> {
  final EncomendaService _service = EncomendaService();
  List<Map<String, dynamic>> _encomendasApi = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarEncomendas();
  }

  Future<void> _carregarEncomendas() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      
      if (userId == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/encomenda/findById/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _encomendasApi = data.map((item) => {
    'id': item['id'],
    'produto': item['produto']?['nome'] ?? 'Produto',
    'nome': item['usuario']?['nome'] ?? 'Cliente',
    'telefone': item['usuario']?['telefone'] ?? 'N/A',
    'quantidade': item['quantidade'] ?? 1,
    'personalizacao': item['observacoes'] ?? 'Nenhuma',
    'status': item['status'] ?? 'Pendente',
    'data': item['dataEncomenda'] ?? DateTime.now().toString().split(' ')[0],
    'preco': 'R\$ ${item['precoTotal']?.toStringAsFixed(2) ?? '0,00'}',
    'cor': _getStatusColor(item['status']),
  }).toList();

          _isLoading = false;
        });
      }
    } catch (e) {
      print('Erro ao carregar encomendas: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }



  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'PRONTA':
        return Colors.green;
      case 'EM_PRODUCAO':
        return Colors.orange;
      case 'CANCELADA':
        return Colors.red;
      default:
        return Colors.blue;
    }
  } 

  @override
  Widget build(BuildContext context) {
    final encomendasLocal = _service.encomendas;
    final todasEncomendas = [..._encomendasApi, ...encomendasLocal];
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Minhas Encomendas', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black87),
        foregroundColor: Colors.black87,
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline, color: Colors.black87),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : todasEncomendas.isEmpty
              ? _emptyState()
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: todasEncomendas.length,
                    itemBuilder: (context, index) {
                      final encomenda = todasEncomendas[index];
                      return _encomendaCard(encomenda);
                    },
                  ),
                ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'Nenhuma encomenda ainda',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Suas encomendas aparecerão aqui',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }



  Widget _encomendaCard(Map<String, dynamic> encomenda) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetalhesEncomendaPage(encomenda: encomenda),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pedido #${encomenda['id']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: encomenda['cor'],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    encomenda['status'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              encomenda['data'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _infoRow(Icons.shopping_bag, 'Produto', encomenda['produto']),
                  if (encomenda['preco'] != null) ...[
                    SizedBox(height: 8),
                    _infoRow(Icons.attach_money, 'Preço', encomenda['preco']),
                  ],
                  SizedBox(height: 8),
                  _infoRow(Icons.person, 'Cliente', encomenda['nome'] ?? 'Sem nome'),
                  SizedBox(height: 8),
                  _infoRow(Icons.phone, 'Telefone', encomenda['telefone'] ?? 'Sem telefone'),
                  if (encomenda['quantidade'] != null) ...[
                    SizedBox(height: 8),
                    _infoRow(Icons.numbers, 'Quantidade', encomenda['quantidade'].toString()),
                  ],
                  if (encomenda['personalizacao'] != null && encomenda['personalizacao'].toString().isNotEmpty) ...[
                    SizedBox(height: 8),
                    _infoRow(Icons.design_services, 'Personalização', encomenda['personalizacao']),
                  ],
                ],
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Ver detalhes',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}