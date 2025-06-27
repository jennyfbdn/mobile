import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Lista completa de produtos
  final List<Map<String, dynamic>> produtos = [
    {
      'nome': 'Vestido Floral',
      'preco': 149.90,
      'imagem': 'assets/images/vestido_floral.jpg',
    },
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
    {
      'nome': 'Blusa de Seda',
      'preco': 180.00,
      'imagem': 'assets/images/blusa_seda.jpg',
    },
  ];

  List<Map<String, dynamic>> produtosFiltrados = [];

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    produtosFiltrados = produtos;
    searchController.addListener(_filtrarProdutos);
  }

  void _filtrarProdutos() {
    String query = searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        produtosFiltrados = produtos;
      } else {
        produtosFiltrados = produtos
            .where((p) => p['nome'].toLowerCase().contains(query))
            .toList();
      }
    });
  }

  final List<String> banners = [
    'assets/images/banner1.jpg',
    'assets/images/banner2.jpg',
    'assets/images/banner3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,  // Cor de fundo branca para a AppBar
        title: Text(
          'Ateliê Pano Fino',
          style: TextStyle(
            color: Colors.black,  // Cor do título da AppBar em preto
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,  // Cor de fundo branca para o corpo da tela
      body: Column(
        children: [
          SizedBox(height: 12),

          // BARRA DE PESQUISA
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Pesquisar produtos...',
                hintStyle: TextStyle(color: Colors.black54),  // Cor do texto de dica
                prefixIcon: Icon(Icons.search, color: Colors.black),  // Ícone de pesquisa preto
                filled: true,
                fillColor: Colors.grey[200],  // Cor de fundo da barra de pesquisa
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,  // Remove a borda
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            ),
          ),

          SizedBox(height: 12),

          // LISTA DE PRODUTOS (expandida)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: produtosFiltrados.isEmpty
                  ? Center(child: Text('Nenhum produto encontrado', style: TextStyle(color: Colors.black)))
                  : GridView.builder(
                      itemCount: produtosFiltrados.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (context, index) {
                        final produto = produtosFiltrados[index];
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                  child: Image.asset(
                                    produto['imagem'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      produto['nome'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black,  // Cor do nome do produto
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'R\$ ${produto['preco'].toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: Colors.pink[700],
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    // Botão Preto
                                    SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Ação do botão
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,  // Cor de fundo preta
                                        foregroundColor: Colors.white,  // Cor do texto do botão branco
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
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
            ),
          ),
        ],
      ),
    );
  }
}
