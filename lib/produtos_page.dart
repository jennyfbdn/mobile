import 'package:flutter/material.dart';
import 'encomenda_service.dart';
import 'profile_page.dart';
import 'produto_detalhes_page.dart';

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

  void _adicionarEncomenda(BuildContext context, Map<String, dynamic> produto) {
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Produtos de Costura',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
        centerTitle: true,
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline, color: Colors.black87),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: produtos.length,
        itemBuilder: (context, index) {
          final produto = produtos[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: produto['cor'],
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Icon(
                    Icons.shopping_bag,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          produto['nome'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          produto['descricao'],
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              produto['preco'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProdutoDetalhesPage(produto: produto),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.visibility,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}