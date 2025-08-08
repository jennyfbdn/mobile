import 'package:flutter/material.dart';
import 'female_page.dart';
import 'male_page.dart';
import 'order_page.dart';
import 'profile_page.dart';
import 'personalizacao_page.dart';
import 'medidas_page.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> roupasDestaque = [
    {
      'nome': 'Conjunto Bege',
      'imagem': 'assets/images/conjunto_bege.jpg',
      'preco': 'R\$ 120,00',
    },
    {
      'nome': 'Saia Jeans',
      'imagem': 'assets/images/blusa_bege.jpg',
      'preco': 'R\$ 90,00',
    },
    {
      'nome': 'Vestido Estampado',
      'imagem': 'assets/images/vestido_roxoestampado.jpg',
      'preco': 'R\$ 110,00',
    },
    {
      'nome': 'Blusa de Couro',
      'imagem': 'assets/images/blusa_couro.jpg',
      'preco': 'R\$ 75,00',
    },
    {
      'nome': 'Conjunto Social',
      'imagem': 'assets/images/conjunto_social.jpg',
      'preco': 'R\$ 75,00',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Ateliê Pano Fino',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline, color: Colors.black87),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.black87, Colors.black54],
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/vestido_floral.jpg',
                      fit: BoxFit.cover,
                      color: Colors.black.withOpacity(0.4),
                      colorBlendMode: BlendMode.darken,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[600],
                          child: Icon(
                            Icons.image_not_supported,
                            size: 60,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ateliê Pano Fino',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Elegância e qualidade em cada peça',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
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
                  // Services Section
                  Text(
                    'Nossos Serviços',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black87,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _serviceCard(
                          context,
                          'Personalizar',
                          Icons.design_services,
                          'Crie peças únicas',
                          () => Navigator.push(context, MaterialPageRoute(builder: (_) => PersonalizacaoPage())),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _serviceCard(
                          context,
                          'Produtos',
                          Icons.shopping_bag,
                          'Materiais de qualidade',
                          () => Navigator.pushNamed(context, '/produtos'),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _serviceCard(
                          context,
                          'Feedbacks',
                          Icons.star,
                          'Avaliações dos clientes',
                          () => Navigator.pushNamed(context, '/feedbacks'),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 32),
                  
                  // Categories Section
                  Text(
                    'Coleções',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black87,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _categoryCard(context, 'Feminino', 'assets/images/vestido_floral.jpg', () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => FemalePage()));
                        }),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _categoryCard(context, 'Masculino', 'assets/images/vestido_floral.jpg', () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => MalePage()));
                        }),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 32),
                  
                  // Featured Products
                  Text(
                    'Peças em Destaque',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black87,
                      letterSpacing: 0.5,
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
                      return _ropaCard(context, roupa);
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

  Widget _serviceCard(BuildContext context, String title, IconData icon, String description, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 24,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 11,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryCard(BuildContext context, String title, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Image.asset(
                imagePath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[400],
                    child: Icon(
                      Icons.image_not_supported,
                      size: 40,
                      color: Colors.white,
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
                  title,
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
  }

  Widget _ropaCard(BuildContext context, Map<String, dynamic> roupa) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                roupa['imagem'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey[600],
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
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  roupa['preco'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => OrderPage(produtos: [roupa])),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Encomendar', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
