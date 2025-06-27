import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        centerTitle: true,
      ),
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
            _profileItem('Nome', 'Maria Silva'),
            _profileItem('Email', 'maria.silva@email.com'),
            _profileItem('Telefone', '(11) 99999-9999'),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Editar Perfil'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileItem(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)),
          Text(value, style: TextStyle(fontSize: 16, color: Colors.black87)),
        ],
      ),
    );
  }
}
