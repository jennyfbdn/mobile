import 'package:flutter/material.dart';
import 'encomenda_service.dart';

class ProdutosPage extends StatelessWidget {
  final List<Map<String, dynamic>> produtos = [
    {
      'nome': 'Linha de Algodão',
      'preco': 'R\$ 3,50',
      'descricao': 'Linha 100% algodão, ideal para costuras delicadas',
      'cor': Colors.blue[100],
    },
    {
      'nome': 'Linha de Poliéster',
      'preco': 'R\$ 2,80',
      'descricao': 'Linha resistente para costuras pesadas',
      'cor': Colors.green[100],
    },
    {
      'nome': 'Agulhas Sortidas',
      'preco': 'R\$ 12,00',
      'descricao': 'Kit com 20 agulhas de diversos tamanhos',
      'cor': Colors.orange[100],
    },
    {
      'nome': 'Tesoura de Costura',
      'preco': 'R\$ 25,00',
      'descricao': 'Tesoura profissional afiada',
      'cor': Colors.purple[100],
    },
    {
      'nome': 'Fita Métrica',
      'preco': 'R\$ 8,50',
      'descricao': 'Fita métrica flexível 150cm',
      'cor': Colors.pink[100],
    },
    {
      'nome': 'Botões Variados',
      'preco': 'R\$ 15,00',
      'descricao': 'Conjunto com 50 botões diversos',
      'cor': Colors.cyan[100],
    },
  ];

  void _adicionarProdutoEncomenda(BuildContext context, Map<String, dynamic> produto) {
    final encomenda = {
      'produto': produto['nome'],
      'nome': 'Cliente',
      'telefone': '',
      'quantidade': 1,
      'altura': '',
      'largura': '',
      'busto': '',
      'personalizacao': 'Produto de costura',
      'preco': produto['preco'],
    };
    
    EncomendaService().adicionarEncomenda(encomenda);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${produto['nome']} adicionado às encomendas!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Produtos de Costura',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: produtos.length,
        itemBuilder: (context, index) {
          final produto = produtos[index];
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: produto['cor'],
                child: Icon(Icons.shopping_bag, color: Colors.white),
              ),
              title: Text(
                produto['nome'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(produto['descricao']),
              trailing: Text(
                produto['preco'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              onTap: () {
                _adicionarProdutoEncomenda(context, produto);
              },
            ),
          );
        },
      ),
    );
  }
}