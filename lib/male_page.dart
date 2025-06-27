import 'package:flutter/material.dart';
import 'order_page.dart';

class MalePage extends StatelessWidget {
  final List<Map<String, dynamic>> produtosMasculinos = [
    {
      'nome': 'Camisa Social',
      'preco': 99.90,
      'imagem': 'assets/images/camisa_social.jpg',
    },
    {
      'nome': 'Calça Jeans',
      'preco': 120.00,
      'imagem': 'assets/images/calca_jeans.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moda Masculina'),
        backgroundColor: Colors.blueGrey[700],
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(12),
        itemCount: produtosMasculinos.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) {
          final produto = produtosMasculinos[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.asset(produto['imagem'], fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(produto['nome'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 4),
                      Text('R\$ ${produto['preco'].toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.blueGrey[700], fontWeight: FontWeight.w600)),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => OrderPage(produtos: [produto])),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey[700],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text('Adicionar ao Carrinho'),
                      ),
                    ],
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
