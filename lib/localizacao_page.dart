import 'package:flutter/material.dart';
import 'profile_page.dart';

class LocalizacaoPage extends StatefulWidget {
  @override
  _LocalizacaoPageState createState() => _LocalizacaoPageState();
}

class _LocalizacaoPageState extends State<LocalizacaoPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  int _selectedUnit = 0;
  
  final List<Map<String, dynamic>> unidades = [
    {
      'nome': 'Ateliê Pano Fino - Centro',
      'endereco': 'Rua das Flores, 123\nCentro - São Paulo, SP\nCEP: 01234-567',
      'telefone': '(11) 1234-5678',
      'whatsapp': '(11) 9 8765-4321',
      'horario': 'Segunda a Sexta: 9h às 18h\nSábado: 9h às 14h\nDomingo: Fechado',
      'especialidade': 'Roupas sob medida e ajustes',
      'cor': Colors.grey[600],
    },
    {
      'nome': 'Ateliê Pano Fino - Vila Madalena',
      'endereco': 'Av. Paulista, 456\nVila Madalena - São Paulo, SP\nCEP: 05678-901',
      'telefone': '(11) 2345-6789',
      'whatsapp': '(11) 9 7654-3210',
      'horario': 'Segunda a Sexta: 10h às 19h\nSábado: 10h às 15h\nDomingo: Fechado',
      'especialidade': 'Moda feminina e acessórios',
      'cor': Colors.grey[700],
    },
    {
      'nome': 'Ateliê Pano Fino - Moema',
      'endereco': 'Rua dos Pinheiros, 789\nMoema - São Paulo, SP\nCEP: 04567-890',
      'telefone': '(11) 3456-7890',
      'whatsapp': '(11) 9 6543-2109',
      'horario': 'Segunda a Sexta: 8h às 17h\nSábado: 9h às 13h\nDomingo: Fechado',
      'especialidade': 'Moda masculina e corporativa',
      'cor': Colors.grey[800],
    },
  ];

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Localização',
          style: TextStyle(
            color: Color(0xFF2C2C2C),
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(0xFF2C2C2C)),
        centerTitle: true,
        elevation: 0,
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
        child: Column(
          children: [
            // Seção Sobre Nós
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black87, Colors.black54],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.content_cut, color: Colors.white, size: 24),
                      SizedBox(width: 12),
                      Text(
                        'Sobre o Ateliê Pano Fino',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Há mais de 10 anos criando peças únicas e oferecendo serviços de costura de alta qualidade. Nosso compromisso é com a excelência, atendimento personalizado e a satisfação dos nossos clientes.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/sobre-atelie'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text('Saiba Mais', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
            
            // Seletor de unidades
            Container(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: unidades.length,
                itemBuilder: (context, index) {
                  final unidade = unidades[index];
                  final isSelected = _selectedUnit == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedUnit = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: 280,
                      margin: EdgeInsets.only(right: 16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? unidade['cor'] : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isSelected ? 0.2 : 0.1),
                            blurRadius: isSelected ? 15 : 8,
                            offset: Offset(0, isSelected ? 8 : 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            unidade['nome'].split(' - ')[1],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            unidade['especialidade'],
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected ? Colors.white70 : Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Mapa interativo
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.green[100]!, Colors.blue[100]!],
                          ),
                        ),
                        child: CustomPaint(
                          painter: MapPainter(),
                        ),
                      ),
                      // Marcadores das unidades
                      ...unidades.asMap().entries.map((entry) {
                        int index = entry.key;
                        double left = 60.0 + (index * 100.0);
                        double top = 100.0 + (index * 60.0);
                        bool isSelected = _selectedUnit == index;
                        
                        return Positioned(
                          left: left,
                          top: top,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedUnit = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              padding: EdgeInsets.all(isSelected ? 12 : 8),
                              decoration: BoxDecoration(
                                color: unidades[index]['cor'],
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: isSelected ? 10 : 5,
                                    offset: Offset(0, isSelected ? 4 : 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: isSelected ? 24 : 20,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      // Informações da localização atual
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            unidades[_selectedUnit]['nome'].split(' - ')[1],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Informações da unidade selecionada
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    key: ValueKey(_selectedUnit),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: unidades[_selectedUnit]['cor'],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.store, color: Colors.white, size: 20),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                unidades[_selectedUnit]['nome'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        _buildInfoCard(Icons.location_on, 'Endereço', unidades[_selectedUnit]['endereco']),
                        SizedBox(height: 12),
                        _buildInfoCard(Icons.access_time, 'Horário', unidades[_selectedUnit]['horario']),
                        SizedBox(height: 12),
                        _buildInfoCard(Icons.phone, 'Contato', 'Tel: ${unidades[_selectedUnit]['telefone']}\nWhatsApp: ${unidades[_selectedUnit]['whatsapp']}'),
                        SizedBox(height: 12),
                        _buildInfoCard(Icons.star, 'Especialidade', unidades[_selectedUnit]['especialidade']),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.directions),
                                label: Text('Como Chegar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[700],
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.phone),
                                label: Text('Ligar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[600],
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String content) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: unidades[_selectedUnit]['cor'],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(height: 2),
                Text(content, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final streetPaint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    
    final buildingPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;
    
    // Desenhar ruas principais
    for (int i = 1; i < 4; i++) {
      canvas.drawLine(
        Offset(0, size.height * i / 4),
        Offset(size.width, size.height * i / 4),
        streetPaint,
      );
      canvas.drawLine(
        Offset(size.width * i / 4, 0),
        Offset(size.width * i / 4, size.height),
        streetPaint,
      );
    }
    
    // Desenhar alguns prédios simulados
    final buildings = [
      Rect.fromLTWH(20, 20, 40, 30),
      Rect.fromLTWH(size.width - 80, 30, 50, 40),
      Rect.fromLTWH(30, size.height - 70, 35, 45),
      Rect.fromLTWH(size.width - 60, size.height - 80, 40, 60),
    ];
    
    for (final building in buildings) {
      canvas.drawRect(building, buildingPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

