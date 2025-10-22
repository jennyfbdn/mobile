import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'order_page.dart';
import 'profile_page.dart';
import 'config/api_config.dart';

class MalePage extends StatefulWidget {
  @override
  _MalePageState createState() => _MalePageState();
}

class _MalePageState extends State<MalePage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  List<Map<String, dynamic>> produtosMasculinos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
    _carregarProdutos();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  String _convertImageToBase64(dynamic imageData) {
    if (imageData == null) return 'assets/images/mascbermuda.jpg';
    
    try {
      if (imageData is String) {
        return 'base64:$imageData';
      } else if (imageData is List) {
        final bytes = List<int>.from(imageData);
        final base64String = base64Encode(bytes);
        return 'base64:$base64String';
      }
    } catch (e) {
      print('Erro ao converter imagem: $e');
    }
    
    return 'assets/images/mascbermuda.jpg';
  }

  Future<void> _carregarProdutos() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/produto/findAll'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final produtosApi = data.where((produto) => 
          produto['categoria']?['nome']?.toLowerCase().contains('masculino') == true ||
          produto['tipo']?.toLowerCase().contains('masculino') == true
        ).map((produto) => {
          'nome': produto['nome'] ?? 'Produto',
          'imagem': produto['foto'] != null ? _convertImageToBase64(produto['foto']) : 'assets/images/mascbermuda.jpg',
          'preco': 'R\$ ${produto['preco']?.toStringAsFixed(2) ?? '0,00'}',
          'id': produto['id'],
        }).toList();

        if (produtosApi.isEmpty) {
          produtosMasculinos = [
            {'nome': 'Bermuda Executive', 'imagem': 'assets/images/mascbermuda.jpg', 'preco': 'R\$ 179,90'},
            {'nome': 'Camisa Polo Verde', 'imagem': 'assets/images/masccamisaverde.png', 'preco': 'R\$ 199,90'},
            {'nome': 'Calça Slim Fit Preta', 'imagem': 'assets/images/masccalcapreta.jpg', 'preco': 'R\$ 259,90'},
            {'nome': 'Camisa Social Branca', 'imagem': 'assets/images/masccamisabranca.png', 'preco': 'R\$ 229,90'},
            {'nome': 'Polo Listrada Premium', 'imagem': 'assets/images/blusalistrada_masculino.png', 'preco': 'R\$ 189,90'},
          ];
        } else {
          produtosMasculinos = List<Map<String, dynamic>>.from(produtosApi);
        }
      }
    } catch (e) {
      print('Erro ao carregar produtos: $e');
      produtosMasculinos = [
        {'nome': 'Bermuda Executive', 'imagem': 'assets/images/mascbermuda.jpg', 'preco': 'R\$ 179,90'},
        {'nome': 'Camisa Polo Verde', 'imagem': 'assets/images/masccamisaverde.png', 'preco': 'R\$ 199,90'},
        {'nome': 'Calça Slim Fit Preta', 'imagem': 'assets/images/masccalcapreta.jpg', 'preco': 'R\$ 259,90'},
        {'nome': 'Camisa Social Branca', 'imagem': 'assets/images/masccamisabranca.png', 'preco': 'R\$ 229,90'},
        {'nome': 'Polo Listrada Premium', 'imagem': 'assets/images/blusalistrada_masculino.png', 'preco': 'R\$ 189,90'},
      ];
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Coleção Masculina',
          style: TextStyle(
            color: Color(0xFF2C2C2C),
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(0xFF2C2C2C)),
        centerTitle: true,
        elevation: 0,
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
          : FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Header animado
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Color(0xFFD1D1D1),
              ),
              child: Column(
                children: [
                  TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 1000),
                    tween: Tween(begin: 0.0, end: 1.0),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Color(0xFF2C2C2C),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Coleção Masculina',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                  Text(
                    'Estilo e modernidade',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B6B6B),
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: GridView.builder(
                  itemCount: produtosMasculinos.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    final produto = produtosMasculinos[index];
                    return _buildAnimatedProductCard(context, produto, index);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(String imagePath) {
    if (imagePath.startsWith('base64:')) {
      try {
        final base64String = imagePath.substring(7);
        return Image.memory(
          base64Decode(base64String),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[100],
              child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey[400]),
            );
          },
        );
      } catch (e) {
        return Container(
          color: Colors.grey[100],
          child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey[400]),
        );
      }
    } else {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[100],
            child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey[400]),
          );
        },
      );
    }
  }

  Widget _buildAnimatedProductCard(BuildContext context, Map<String, dynamic> produto, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 150)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    child: Stack(
                      children: [
                        _buildProductImage(produto['imagem']),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.star_border,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        produto['nome'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        produto['preco'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 32,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OrderPage(produtos: [produto]),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2C2C2C),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'Encomendar',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
