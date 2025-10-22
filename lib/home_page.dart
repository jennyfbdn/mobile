import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'female_page.dart';
import 'male_page.dart';
import 'order_page.dart';
import 'profile_page.dart';
import 'personalizacao_page.dart';
import 'medidas_page.dart';
import 'services/produto_service.dart';
import 'models/produto_model.dart';
import 'feedbacks_page.dart';
import 'config/colors.dart';
import 'materiais_page.dart';
import 'theme/app_theme.dart';
import 'theme/elegant_components.dart';
import 'services/web_service.dart';
import 'categorias_page.dart';
import 'services/categoria_service.dart';
import 'models/categoria_model.dart';
import 'produtos_page.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentCarouselIndex = 0;
  PageController _pageController = PageController();
  Timer? _timer;
  List<Categoria> categorias = [];
  bool isLoadingCategorias = true;
  List<Produto> produtos = [];
  bool isLoadingProdutos = true;

  final List<Map<String, String>> _carouselItems = [
    {
      'image': 'assets/images/conjunto_jeans.jpg',
      'title': 'Ateliê Pano Fino',
      'subtitle': 'Elegância e qualidade em cada peça'
    },
    {
      'image': 'assets/images/blusa_couro.jpg',
      'title': 'Coleção Premium',
      'subtitle': 'Estilo e sofisticação'
    },
    {
      'image': 'assets/images/blusadecroche.jpg',
      'title': 'Peças Artesanais',
      'subtitle': 'Feitas com amor e dedicação'
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
    _carregarCategorias();
    _carregarProdutos();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (_pageController.hasClients && mounted) {
        int nextPage = (_currentCarouselIndex + 1) % _carouselItems.length;
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _carregarCategorias() async {
    try {
      final categoriasCarregadas = await CategoriaService.getCategorias();
      setState(() {
        categorias = categoriasCarregadas.take(4).toList();
        isLoadingCategorias = false;
      });
    } catch (e) {
      setState(() {
        isLoadingCategorias = false;
      });
    }
  }

  Future<void> _carregarProdutos() async {
    try {
      final produtosCarregados = await ProdutoService().fetchProdutos();
      print('Produtos carregados: ${produtosCarregados.length}');
      for (var produto in produtosCarregados.take(3)) {
        print('Produto: ${produto.nome}, FotoUrl: ${produto.fotoUrl}');
      }
      setState(() {
        produtos = produtosCarregados.take(9).toList();
        isLoadingProdutos = false;
      });
    } catch (e) {
      print('Erro ao carregar produtos: $e');
      setState(() {
        isLoadingProdutos = false;
      });
    }
  }

  Widget _buildCategoriasSection() {
    if (isLoadingCategorias) {
      return Container(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (categorias.isEmpty) {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.category, color: Colors.grey[600], size: 32),
              SizedBox(height: 8),
              Text('Nenhuma categoria encontrada', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categorias',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlack,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CategoriasPage())),
              child: Text('Ver todas'),
            ),
          ],
        ),
        SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
          ),
          itemCount: categorias.length > 4 ? 4 : categorias.length,
          itemBuilder: (context, index) {
            final categoria = categorias[index];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProdutosPage(
                    categoriaId: categoria.id,
                    categoriaNome: categoria.nome,
                  ),
                ),
              ),
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppTheme.accentGold.withOpacity(0.8), AppTheme.accentGold],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Text(
                          categoria.nome,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildImageFromBytes(String imageData) {
    print('=== DEBUG IMAGEM ===');
    print('ImageData length: ${imageData.length}');
    print('ImageData starts with: ${imageData.length > 50 ? imageData.substring(0, 50) : imageData}');
    print('Is data URL: ${imageData.startsWith('data:image')}');
    print('Is base64: ${_isBase64(imageData)}');
    
    if (imageData.isEmpty) {
      print('ERROR: ImageData is empty');
      return Container(
        color: const Color.fromRGBO(224, 224, 224, 1),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_not_supported, size: 40, color: Colors.grey[600]),
              Text('Vazio', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
            ],
          ),
        ),
      );
    }
    
    try {
      Uint8List bytes;
      
      if (imageData.startsWith('data:image')) {
        print('Processing as data URL');
        List<String> parts = imageData.split(',');
        if (parts.length < 2) {
          print('ERROR: Invalid data URL format');
          throw Exception('Invalid data URL format');
        }
        String base64String = parts[1];
        print('Base64 string length: ${base64String.length}');
        bytes = base64Decode(base64String);
      } else if (_isBase64(imageData)) {
        print('Processing as base64');
        bytes = base64Decode(imageData);
      } else {
        print('ERROR: Not a valid image format');
        throw Exception('Not a valid image format');
      }
      
      print('Decoded bytes length: ${bytes.length}');
      
      if (bytes.isEmpty) {
        print('ERROR: Decoded bytes are empty');
        throw Exception('Decoded bytes are empty');
      }
      
      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('ERROR in Image.memory: $error');
          return Container(
            color: const Color.fromRGBO(224, 224, 224, 1),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_not_supported, size: 40, color: Colors.grey[600]),
                  Text('Erro', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      print('EXCEPTION in _buildImageFromBytes: $e');
      return Container(
        color: const Color.fromRGBO(224, 224, 224, 1),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_not_supported, size: 40, color: Colors.grey[600]),
              Text('Falha', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
            ],
          ),
        ),
      );
    }
  }
  
  bool _isBase64(String str) {
    try {
      base64Decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  Widget _buildServiceCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    bool isLight = gradient[0].computeLuminance() > 0.5;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.15),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isLight ? Colors.white.withOpacity(0.8) : Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon, 
                size: 32, 
                color: isLight ? Color(0xFF2C2C2C) : Colors.white
              ),
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: isLight ? Color(0xFF2C2C2C) : Colors.white,
              ),
            ),
            SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: isLight ? Color(0xFF6B6B6B) : Colors.white.withOpacity(0.85),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pureWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.pureWhite,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppTheme.goldGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.diamond, color: AppTheme.pureWhite, size: 20),
            ),
            SizedBox(width: 12),
            Text(
              'Ateliê Pano Fino',
              style: TextStyle(
                color: AppTheme.primaryBlack,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: AppTheme.elegantGray,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(Icons.feedback_outlined, color: AppTheme.primaryBlack, size: 24),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => FeedbacksPage()));
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: AppTheme.elegantGray,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(Icons.person_outline, color: AppTheme.primaryBlack, size: 24),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 280,
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: AppTheme.elegantShadow,
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentCarouselIndex = index;
                        });
                      },
                      itemCount: _carouselItems.length,
                      itemBuilder: (context, index) {
                        final item = _carouselItems[index];
                        return Container(
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                  item['image']!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: AppTheme.gradientContainer,
                                      child: Center(
                                        child: Icon(Icons.image, size: 80, color: AppTheme.textGray),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      AppTheme.primaryBlack.withOpacity(0.8),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 60,
                                left: 24,
                                right: 24,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title']!,
                                      style: TextStyle(
                                        color: AppTheme.pureWhite,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      item['subtitle']!,
                                      style: TextStyle(
                                        color: AppTheme.pureWhite.withOpacity(0.9),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.3,
                                      ),
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
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _carouselItems.asMap().entries.map((entry) {
                        return Container(
                          width: _currentCarouselIndex == entry.key ? 24 : 8,
                          height: 8,
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: _currentCarouselIndex == entry.key
                                ? AppTheme.accentGold
                                : AppTheme.pureWhite.withOpacity(0.5),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElegantComponents.sectionTitle(
                    title: 'Nossos Serviços',
                    subtitle: 'Experiência personalizada para você',
                  ),
                  SizedBox(height: 20),
                  
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElegantComponents.serviceCard(
                              icon: Icons.design_services,
                              title: 'Personalizar',
                              subtitle: 'Crie peças únicas',
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PersonalizacaoPage())),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: ElegantComponents.serviceCard(
                              icon: Icons.construction,
                              title: 'Materiais',
                              subtitle: 'Agende retirada',
                              gradientColors: [AppTheme.accentGold.withOpacity(0.1), AppTheme.accentGold.withOpacity(0.2)],
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MateriaisPage())),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      ElegantComponents.serviceCard(
                        icon: Icons.feedback,
                        title: 'Feedback',
                        subtitle: 'Avalie nosso serviço',
                        gradientColors: [Colors.green.withOpacity(0.1), Colors.green.withOpacity(0.2)],
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FeedbacksPage())),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 32),
                  
                  ElegantComponents.sectionTitle(
                    title: 'Coleções e Categorias',
                    subtitle: 'Descubra nossos estilos exclusivos',
                  ),
                  SizedBox(height: 20),
                  
                  
                  
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FemalePage())),
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                children: [
                                  Image.asset(
                                    'assets/images/blusadecroche.jpg',
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: Center(
                                          child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey[600]),
                                        ),
                                      );
                                    },
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.7),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 16,
                                    left: 16,
                                    child: Text(
                                      'Feminino',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MalePage())),
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                children: [
                                  Image.asset(
                                    'assets/images/blusalistrada_masculino.png',
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: Center(
                                          child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey[600]),
                                        ),
                                      );
                                    },
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.7),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 16,
                                    left: 16,
                                    child: Text(
                                      'Masculino',
                                      style: TextStyle(
                                        color: const Color.fromRGBO(255, 255, 255, 1),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 32),
                  
                  ElegantComponents.sectionTitle(
                    title: 'Peças em Destaque',
                    subtitle: 'Seleção especial da nossa coleção',
                  ),
                  SizedBox(height: 20),
                  
                  isLoadingProdutos
                    ? Container(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : produtos.isEmpty
                        ? Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.shopping_bag, color: Colors.grey[600], size: 32),
                                  SizedBox(height: 8),
                                  Text('Nenhum produto encontrado', style: TextStyle(color: Colors.grey[600])),
                                ],
                              ),
                            ),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: produtos.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.75,
                            ),
                            itemBuilder: (context, index) {
                              final produto = produtos[index];
                              final nome = produto.nome ?? 'Produto sem nome';
                              final preco = produto.preco ?? 0.0;
                              final fotoUrl = produto.fotoUrl ?? '';
                              
                              print('Renderizando produto: $nome, URL: $fotoUrl, isEmpty: ${fotoUrl.isEmpty}');
                              
                              return Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                        child: fotoUrl.isNotEmpty
                                          ? _buildImageFromBytes(fotoUrl)
                                          : Container(
                                              color: const Color.fromRGBO(224, 224, 224, 1),
                                              child: Center(
                                                child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey[600]),
                                              ),
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        children: [
                                          Text(
                                            nome,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'R\$ ${preco.toStringAsFixed(2).replaceAll('.', ',')}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.green[700],
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 8),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (_) => OrderPage(produtos: [{
                                                  'nome': nome,
                                                  'preco': 'R\$ ${preco.toStringAsFixed(2).replaceAll('.', ',')}',
                                                  'imagem': fotoUrl,
                                                }])),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color(0xFF2C2C2C),
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              elevation: 0,
                                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                            ),
                                            child: Text('Encomendar', style: TextStyle(fontSize: 12)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}