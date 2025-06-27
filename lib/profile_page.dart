import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  // Você pode adaptar para dados reais, aqui um exemplo simples
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 60, color: Colors.black54),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Nome:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text('Maria Silva', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text(
              'Email:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text('maria.silva@email.com', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text(
              'Telefone:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text('(11) 99999-9999', style: TextStyle(fontSize: 16)),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Aqui pode implementar logout ou editar perfil
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Editar Perfil',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
