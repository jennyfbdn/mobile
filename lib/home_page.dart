import 'package:flutter/material.dart';
import 'dart:async';
import 'female_page.dart';
import 'male_page.dart';
import 'order_page.dart';
import 'profile_page.dart';
import 'personalizacao_page.dart';
import 'medidas_page.dart';
import 'services/produto_service.dart';
import 'models/produto_model.dart';
import 'notificacoes_page.dart';
import 'notification_service.dart';
import 'config/colors.dart';
import 'materiais_page.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotificationService _notificationService = NotificationService();
  int _notificacoesNaoLidas = 0;
  int _currentCarouselIndex = 0;
  PageController _pageController = PageController();
  Timer? _timer;

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
    _carregarContadorNotificacoes();
    _startAutoPlay();
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

  Future<void> _carregarContadorNotificacoes() async {
    final count = await _notificationService.contarNaoLidas();
    if (mounted) {
      setState(() {
        _notificacoesNaoLidas = count;
      });
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

  final List<Map<String, dynamic>> roupasDestaque = [
    {
      'nome': 'Vestido Rosé Elegance',
      'imagem': 'assets/images/vestidorosa.png',
      'preco': 'R\$ 389,90',
    },
    {
      'nome': 'Camisa Sunset Premium',
      'imagem': 'assets/images/camisa_degrade.jpg',
      'preco': 'R\$ 279,90',
    },
    {
      'nome': 'Blusa Midnight Couture',
      'imagem': 'assets/images/blusa_preta.png',
      'preco': 'R\$ 219,90',
    },
    {
      'nome': 'Saia Executive Black',
      'imagem': 'assets/images/saiapreta.jpg',
      'preco': 'R\$ 189,90',
    },
    {
      'nome': 'Calça Artisan Bordada',
      'imagem': 'assets/images/calça_bordada.jpg',
      'preco': 'R\$ 349,90',
    },
    {
      'nome': 'Top Jeans Boho Premium',
      'imagem': 'assets/images/Conjuntotopjeans.png',
      'preco': 'R\$ 259,90',
    },
    {
      'nome': 'Blusa Rose Delicate',
      'imagem': 'assets/images/blusarosa.png',
      'preco': 'R\$ 199,90',
    },
    {
      'nome': 'Calça Designer Print',
      'imagem': 'assets/images/calçadesenho.png',
      'preco': 'R\$ 329,90',
    },
    {
      'nome': 'Conjunto Urban Denim',
      'imagem': 'assets/images/conjunto_jeans.jpg',
      'preco': 'R\$ 459,90',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Ateliê Pano Fino',
          style: TextStyle(
            color: Color(0xFF2C2C2C),
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_outlined, color: Color(0xFF2C2C2C), size: 24),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => NotificacoesPage()),
                  );
                  _carregarContadorNotificacoes();
                },
              ),
              if (_notificacoesNaoLidas > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$_notificacoesNaoLidas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.person_outline, color: Color(0xFF2C2C2C), size: 24),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 250,
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
                                    color: Colors.grey[400],
                                    child: Center(
                                      child: Icon(Icons.image, size: 60, color: Colors.white),
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
                                    Colors.black.withOpacity(0.7),
                                  ],
                                ),
                              ),
                            ),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item['title']!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    item['subtitle']!,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    textAlign: TextAlign.center,
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
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _carouselItems.asMap().entries.map((entry) {
                      return Container(
                        width: 8,
                        height: 8,
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentCarouselIndex == entry.key
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nossos Serviços',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 26,
                      color: Color(0xFF2C2C2C),
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildServiceCard(
                          icon: Icons.design_services,
                          title: 'Personalizar',
                          subtitle: 'Crie peças únicas',
                          gradient: [Color(0xFFFCE8E1), Color(0xFFFCE8E1)],
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PersonalizacaoPage())),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildServiceCard(
                          icon: Icons.construction,
                          title: 'Materiais',
                          subtitle: 'Agende retirada',
                          gradient: [Color(0xFFFCE8E1), Color(0xFFFCE8E1)],
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MateriaisPage())),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildServiceCard(
                          icon: Icons.star,
                          title: 'Avaliações',
                          subtitle: 'Feedback dos clientes',
                          gradient: [Color(0xFFFCE8E1), Color(0xFFFCE8E1)],
                          onTap: () => Navigator.pushNamed(context, '/feedbacks'),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 32),
                  
                  Text(
                    'Coleções',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 26,
                      color: Color(0xFF2C2C2C),
                      letterSpacing: -0.5,
                    ),
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
                  
                  Text(
                    'Peças em Destaque',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 26,
                      color: Color(0xFF2C2C2C),
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: roupasDestaque.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) {
                      final roupa = roupasDestaque[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                child: Image.asset(
                                  roupa['imagem'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: const Color.fromRGBO(224, 224, 224, 1),
                                      child: Center(
                                        child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey[600]),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Text(
                                    roupa['nome'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    roupa['preco'],
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
                                        MaterialPageRoute(builder: (_) => OrderPage(produtos: [roupa])),
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