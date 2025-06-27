import 'package:flutter/material.dart';
import 'female_page.dart';
import 'male_page.dart';
import 'order_page.dart';
import 'profile_page.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> roupasDestaque = [
    {
      'nome': 'Vestido Floral',
      'imagem': 'assets/images/vestido_floral.jpg',
    },
    {
      'nome': 'Camisa Social',
      'imagem': 'assets/images/camisa_social.jpg',
    },
    {
      'nome': 'Calça Jeans',
      'imagem': 'assets/images/calca_jeans.jpg',
    },
    {
      'nome': 'Blusa de Seda',
      'imagem': 'assets/images/blusa_seda.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 3,
        centerTitle: true,
        title: Text(
          'Ateliê Pano Fino',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            fontFamily: 'Georgia', // Fonte serifada elegante
            letterSpacing: 1.2,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline, color: Colors.black87, size: 28),
            tooltip: 'Perfil',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22, vertical: 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Categorias',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 28,
                color: Colors.black87,
                letterSpacing: 1.1,
              ),
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _categoryButton(context, 'Feminino', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => FemalePage()));
                }),
                SizedBox(width: 18),
                _categoryButton(context, 'Masculino', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => MalePage()));
                }),
              ],
            ),
            SizedBox(height: 38),
            Text(
              'Roupas em destaque',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 24,
                color: Colors.black87,
                letterSpacing: 1.05,
              ),
            ),
            SizedBox(height: 22),
            Expanded(
              child: GridView.builder(
                itemCount: roupasDestaque.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 22,
                  mainAxisSpacing: 22,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  final roupa = roupasDestaque[index];
                  return _ropaCard(context, roupa);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryButton(BuildContext context, String title, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black87,
          minimumSize: Size(110, 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: 6,
          shadowColor: Colors.black54,
          padding: EdgeInsets.symmetric(horizontal: 26),
          textStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _ropaCard(BuildContext context, Map<String, dynamic> roupa) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => OrderPage(produtos: [roupa])));
      },
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 1, end: 1),
        duration: Duration(milliseconds: 300),
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: Card(
          elevation: 8,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Image.asset(
                  roupa['imagem'],
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                child: Column(
                  children: [
                    Text(
                      roupa['nome'],
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => OrderPage(produtos: [roupa])),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                          elevation: 6,
                          shadowColor: Colors.black54,
                          // Gradiente preto -> cinza escuro
                          backgroundColor: Colors.transparent,
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black87, Colors.grey[850]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              'Encomendar',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
