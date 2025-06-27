import 'package:flutter/material.dart';
import 'order_page.dart';
import 'female_page.dart';
import 'male_page.dart';
import 'profile_page.dart';  // Importa a nova página de perfil

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> roupasDestaque = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Ateliê Pano Fino',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 26,
            letterSpacing: 1.5,
            fontFamily: 'Serif',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline, color: Colors.black, size: 28),
            tooltip: 'Perfil',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfilePage()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ListView(
          children: [
            Text(
              'Categorias',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                letterSpacing: 1.2,
              ),
            ),

            SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Botão Feminino
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => FemalePage()));
                  },
                  style: TextButton.styleFrom(
                    side: BorderSide(color: Colors.black, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    backgroundColor: Colors.white,
                  ),
                  icon: Icon(Icons.female, color: Colors.black, size: 22),
                  label: Text(
                    'Feminino',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: 'Serif',
                    ),
                  ),
                ),

                SizedBox(width: 20),

                // Botão Masculino
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => MalePage()));
                  },
                  style: TextButton.styleFrom(
                    side: BorderSide(color: Colors.black, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    backgroundColor: Colors.white,
                  ),
                  icon: Icon(Icons.male, color: Colors.black, size: 22),
                  label: Text(
                    'Masculino',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: 'Serif',
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 32),

            Text(
              'Roupas em Destaque',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                letterSpacing: 1.2,
              ),
            ),

            SizedBox(height: 16),

            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: roupasDestaque.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.65,
              ),
              itemBuilder: (context, index) {
                final roupa = roupasDestaque[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  elevation: 4,
                  shadowColor: Colors.black26,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                          child: Image.asset(
                            roupa['imagem'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        child: Text(
                          roupa['nome'],
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Colors.black87,
                            fontFamily: 'Serif',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OrderPage(produtos: [roupa]),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            'Encomendar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                    ],
                  ),
                );
              },
            ),

            SizedBox(height: 24),

            Center(
              child: Text(
                '© 2025 Ateliê Pano Fino',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
