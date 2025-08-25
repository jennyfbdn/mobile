import 'package:flutter/material.dart';
import 'profile_page.dart';

class SobreAteliePage extends StatefulWidget {
  @override
  _SobreAteliePageState createState() => _SobreAteliePageState();
}

class _SobreAteliePageState extends State<SobreAteliePage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

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
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Sobre o Ateliê',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
        centerTitle: true,
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline, color: Colors.black87),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header com logo
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black87, Colors.black54],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.content_cut,
                      size: 60,
                      color: Colors.white,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Ateliê Pano Fino',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Elegância e qualidade em cada peça',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sobre nós
                    Text(
                      'Nossa História',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        'O Ateliê Pano Fino nasceu da paixão pela costura e pelo desejo de criar peças únicas e personalizadas. Com anos de experiência, oferecemos serviços de alta qualidade, sempre priorizando o atendimento personalizado e a satisfação dos nossos clientes.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ),

                    SizedBox(height: 32),

                    // Nossos Serviços
                    Text(
                      'Nossos Serviços',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16),

                    _buildServiceCard(
                      'Costura Personalizada',
                      'Criamos peças únicas sob medida, do conceito à confecção final.',
                      Icons.design_services,
                      Colors.blue[100]!,
                    ),
                    SizedBox(height: 12),
                    _buildServiceCard(
                      'Ajustes e Reformas',
                      'Ajustamos e reformamos suas peças favoritas com precisão.',
                      Icons.build,
                      Colors.green[100]!,
                    ),
                    SizedBox(height: 12),
                    _buildServiceCard(
                      'Materiais de Qualidade',
                      'Fornecemos os melhores materiais para seus projetos de costura.',
                      Icons.shopping_bag,
                      Colors.orange[100]!,
                    ),

                    SizedBox(height: 32),

                    // Nossos Produtos
                    Text(
                      'Nossos Produtos',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _buildProductCard(
                            'Coleção Feminina',
                            'Vestidos, blusas, saias e muito mais',
                            Icons.favorite,
                            Colors.pink[100]!,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildProductCard(
                            'Coleção Masculina',
                            'Camisas, calças e conjuntos sociais',
                            Icons.person,
                            Colors.blue[100]!,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 32),

                    // Feedbacks dos Clientes
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/feedbacks'),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.star,
                              size: 40,
                              color: Colors.white,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Feedbacks dos Clientes',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Veja o que nossos clientes estão falando sobre nosso trabalho!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Contato
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.contact_phone,
                            size: 40,
                            color: Colors.white,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Entre em Contato',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Estamos prontos para atender você e criar a peça dos seus sonhos!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(String title, String description, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.black87, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(String title, String description, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.black87, size: 32),
          ),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}