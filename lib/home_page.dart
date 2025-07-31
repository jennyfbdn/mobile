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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
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
            icon: Icon(Icons.list_alt, color: Colors.black87),
            onPressed: () {
              Navigator.pushNamed(context, '/encomendas');
            },
          ),
          IconButton(
            icon: Icon(Icons.person_outline, color: Colors.black87),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              'Categorias',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
              
            Row(
              children: [
                Expanded(
                  child: _categoryButton(context, 'Feminino', () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => FemalePage()));
                  }),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _categoryButton(context, 'Masculino', () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => MalePage()));
                  }),
                ),
              ],
            ),
            
            SizedBox(height: 32),
            
            Text(
              'Roupas em destaque',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            
            Expanded(
              child: GridView.builder(
                itemCount: roupasDestaque.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
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
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16),
        minimumSize: Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(title, style: TextStyle(fontSize: 16)),
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
