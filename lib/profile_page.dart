import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  
  final TextEditingController _nomeController = TextEditingController(text: 'Maria Silva');
  final TextEditingController _emailController = TextEditingController(text: 'maria.silva@email.com');
  final TextEditingController _telefoneController = TextEditingController(text: '(11) 99999-9999');
  final TextEditingController _enderecoController = TextEditingController(text: 'Rua das Flores, 123');

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _salvarPerfil() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Perfil atualizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Meu Perfil', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black87),
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: _toggleEdit,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // Avatar
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey[200],
                    child: Icon(Icons.person, size: 70, color: Colors.grey[600]),
                  ),
                ),
              ),
              SizedBox(height: 32),

              // Campos do perfil
              _buildProfileField(
                'Nome',
                _nomeController,
                Icons.person_outline,
                validator: (value) => value?.isEmpty == true ? 'Nome é obrigatório' : null,
              ),
              SizedBox(height: 16),
              
              _buildProfileField(
                'E-mail',
                _emailController,
                Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty == true) return 'E-mail é obrigatório';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}\$').hasMatch(value!)) {
                    return 'E-mail inválido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              _buildProfileField(
                'Telefone',
                _telefoneController,
                Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) => value?.isEmpty == true ? 'Telefone é obrigatório' : null,
              ),
              SizedBox(height: 16),
              
              _buildProfileField(
                'Endereço',
                _enderecoController,
                Icons.location_on_outlined,
                maxLines: 2,
              ),
              SizedBox(height: 32),

              // Botões
              if (_isEditing)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _toggleEdit,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Cancelar', style: TextStyle(color: Colors.grey[700])),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _salvarPerfil,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Salvar'),
                      ),
                    ),
                  ],
                )
              else
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _toggleEdit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Editar Perfil', style: TextStyle(fontSize: 16)),
                  ),
                ),
              
              SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                },
                child: Text('Sair', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        enabled: _isEditing,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black87, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        style: TextStyle(
          color: _isEditing ? Colors.black87 : Colors.grey[700],
          fontWeight: _isEditing ? FontWeight.normal : FontWeight.w500,
        ),
      ),
    );
  }
}
