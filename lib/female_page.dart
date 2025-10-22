import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'order_page.dart';
import 'profile_page.dart';
import 'theme/app_theme.dart';
import 'theme/elegant_components.dart';
import 'config/api_config.dart';

class FemalePage extends StatefulWidget {
  @override
  _FemalePageState createState() => _FemalePageState();
}

class _FemalePageState extends State<FemalePage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  List<Map<String, dynamic>> produtosFemininos = [];
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
    if (imageData == null) return 'assets/images/femcroppedpreto.png';
    
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
    
    return 'assets/images/femcroppedpreto.png';
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
          produto['categoria']?['nome']?.toLowerCase().contains('feminino') == true ||
          produto['tipo']?.toLowerCase().contains('feminino') == true
        ).map((produto) => {
          'nome': produto['nome'] ?? 'Produto',
          'imagem': produto['foto'] != null ? _convertImageToBase64(produto['foto']) : 'assets/images/femcroppedpreto.png',
          'preco': 'R\$ ${produto['preco']?.toStringAsFixed(2) ?? '0,00'}',
          'id': produto['id'],
        }).toList();

        // Se não há produtos femininos da API, usar produtos padrão
        if (produtosApi.isEmpty) {
          produtosFemininos = [
            {'nome': 'Cropped Elegance Black', 'imagem': 'assets/images/femcroppedpreto.png', 'preco': 'R\$ 189,90'},
            {'nome': 'Saia Midi Clássica', 'imagem': 'assets/images/femsaiabranca.png', 'preco': 'R\$ 249,90'},
            {'nome': 'Blusa Sofisticada Azul', 'imagem': 'assets/images/femblusaazul.png', 'preco': 'R\$ 219,90'},
            {'nome': 'Calça Premium com Laço', 'imagem': 'assets/images/femcalcalaco.png', 'preco': 'R\$ 329,90'},
            {'nome': 'Saia Couture Roxa', 'imagem': 'assets/images/femsaiaroxa.png', 'preco': 'R\$ 279,90'},
            {'nome': 'Vestido Evening Black', 'imagem': 'assets/images/femvestidopreto.png', 'preco': 'R\$ 459,90'},
          ];
        } else {
          produtosFemininos = List<Map<String, dynamic>>.from(produtosApi);
        }
      }
    } catch (e) {
      print('Erro ao carregar produtos: $e');
      // Usar produtos padrão em caso de erro
      produtosFemininos = [
        {'nome': 'Cropped Elegance Black', 'imagem': 'assets/images/femcroppedpreto.png', 'preco': 'R\$ 189,90'},
        {'nome': 'Saia Midi Clássica', 'imagem': 'assets/images/femsaiabranca.png', 'preco': 'R\$ 249,90'},
        {'nome': 'Blusa Sofisticada Azul', 'imagem': 'assets/images/femblusaazul.png', 'preco': 'R\$ 219,90'},
        {'nome': 'Calça Premium com Laço', 'imagem': 'assets/images/femcalcalaco.png', 'preco': 'R\$ 329,90'},
        {'nome': 'Saia Couture Roxa', 'imagem': 'assets/images/femsaiaroxa.png', 'preco': 'R\$ 279,90'},
        {'nome': 'Vestido Evening Black', 'imagem': 'assets/images/femvestidopreto.png', 'preco': 'R\$ 459,90'},
      ];
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pureWhite,
      appBar: ElegantComponents.elegantAppBar(
        title: 'Coleção Feminina',
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline, color: AppTheme.primaryBlack),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentGold)))
          : FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Header elegante
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                boxShadow: AppTheme.subtleShadow,
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
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.pureWhite,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: AppTheme.elegantShadow,
                          ),
                          child: Icon(
                            Icons.favorite,
                            size: 32,
                            color: AppTheme.accentGold,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Coleção Feminina',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryBlack,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Elegância e sofisticação em cada peça',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textGray,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: Container(
                padding: EdgeInsets.all(24),
                child: GridView.builder(
                  itemCount: produtosFemininos.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final produto = produtosFemininos[index];
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
                              Icons.favorite_border,
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
