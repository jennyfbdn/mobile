import 'package:flutter/material.dart';
import 'medidas_service.dart';

class MedidasPage extends StatefulWidget {
  @override
  _MedidasPageState createState() => _MedidasPageState();
}

class _MedidasPageState extends State<MedidasPage> {
  String _genero = 'Feminino';
  final Map<String, TextEditingController> _controllers = {
    'busto': TextEditingController(),
    'cintura': TextEditingController(),
    'quadril': TextEditingController(),
    'altura': TextEditingController(),
    'ombro': TextEditingController(),
    'braco': TextEditingController(),
  };
  
  @override
  void initState() {
    super.initState();
    _carregarMedidas();
  }
  
  void _carregarMedidas() {
    final medidas = MedidasService().obterMedidas();
    medidas.forEach((key, value) {
      if (_controllers.containsKey(key)) {
        _controllers[key]!.text = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Tabela de Medidas'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
              ),
              child: Column(
                children: [
                  Text('Manequim Ajustável', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Informe suas medidas para o ajuste perfeito', style: TextStyle(color: Colors.grey[600])),
                  SizedBox(height: 24),
                  
                  Row(
                    children: [
                      Expanded(child: _buildGenderButton('Feminino')),
                      SizedBox(width: 16),
                      Expanded(child: _buildGenderButton('Masculino')),
                    ],
                  ),
                  SizedBox(height: 24),
                  
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: CustomPaint(
                            painter: ManequimPainter(_genero, _controllers),
                            size: Size.infinite,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          children: [
                            _buildMedidaField('Busto/Peito', 'busto', 'cm'),
                            SizedBox(height: 12),
                            _buildMedidaField('Cintura', 'cintura', 'cm'),
                            SizedBox(height: 12),
                            _buildMedidaField('Quadril', 'quadril', 'cm'),
                            SizedBox(height: 12),
                            _buildMedidaField('Altura', 'altura', 'cm'),
                            SizedBox(height: 12),
                            _buildMedidaField('Ombro', 'ombro', 'cm'),
                            SizedBox(height: 12),
                            _buildMedidaField('Braço', 'braco', 'cm'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _salvarMedidas,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Salvar Medidas', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderButton(String gender) {
    bool isSelected = _genero == gender;
    return GestureDetector(
      onTap: () => setState(() => _genero = gender),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          gender,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildMedidaField(String label, String key, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        SizedBox(height: 4),
        TextField(
          controller: _controllers[key],
          keyboardType: TextInputType.number,
          onChanged: (value) => setState(() {}),
          decoration: InputDecoration(
            suffixText: unit,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  void _salvarMedidas() {
    Map<String, String> medidas = {
      'busto': _controllers['busto']!.text,
      'cintura': _controllers['cintura']!.text,
      'quadril': _controllers['quadril']!.text,
      'altura': _controllers['altura']!.text,
      'ombro': _controllers['ombro']!.text,
      'braco': _controllers['braco']!.text,
    };
    
    MedidasService().salvarMedidas(medidas);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Medidas Salvas'),
        content: Text('Suas medidas foram salvas com sucesso!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

class ManequimPainter extends CustomPainter {
  final String genero;
  final Map<String, TextEditingController> controllers;

  ManequimPainter(this.genero, this.controllers);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[700]!
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final baseWidth = 60.0;
    final baseHeight = 120.0;

    // Get measurements or use defaults
    double busto = double.tryParse(controllers['busto']?.text ?? '') ?? 90;
    double cintura = double.tryParse(controllers['cintura']?.text ?? '') ?? 70;
    double quadril = double.tryParse(controllers['quadril']?.text ?? '') ?? 95;
    double altura = double.tryParse(controllers['altura']?.text ?? '') ?? 170;

    // Scale factors based on measurements
    double bustoScale = (busto / 90) * 0.8 + 0.2;
    double cinturaScale = (cintura / 70) * 0.8 + 0.2;
    double quadrilScale = (quadril / 95) * 0.8 + 0.2;
    double alturaScale = (altura / 170) * 0.8 + 0.2;

    // Head
    canvas.drawCircle(
      Offset(center.dx, center.dy - baseHeight * alturaScale * 0.4),
      15,
      paint,
    );

    // Body outline
    final path = Path();
    
    // Shoulders
    path.moveTo(center.dx - baseWidth * bustoScale * 0.4, center.dy - baseHeight * alturaScale * 0.25);
    path.lineTo(center.dx + baseWidth * bustoScale * 0.4, center.dy - baseHeight * alturaScale * 0.25);
    
    // Bust/Chest
    path.moveTo(center.dx - baseWidth * bustoScale * 0.35, center.dy - baseHeight * alturaScale * 0.1);
    path.lineTo(center.dx + baseWidth * bustoScale * 0.35, center.dy - baseHeight * alturaScale * 0.1);
    
    // Waist
    path.moveTo(center.dx - baseWidth * cinturaScale * 0.25, center.dy);
    path.lineTo(center.dx + baseWidth * cinturaScale * 0.25, center.dy);
    
    // Hips
    path.moveTo(center.dx - baseWidth * quadrilScale * 0.35, center.dy + baseHeight * alturaScale * 0.15);
    path.lineTo(center.dx + baseWidth * quadrilScale * 0.35, center.dy + baseHeight * alturaScale * 0.15);

    // Body sides
    path.moveTo(center.dx - baseWidth * bustoScale * 0.35, center.dy - baseHeight * alturaScale * 0.1);
    path.lineTo(center.dx - baseWidth * cinturaScale * 0.25, center.dy);
    path.lineTo(center.dx - baseWidth * quadrilScale * 0.35, center.dy + baseHeight * alturaScale * 0.15);
    
    path.moveTo(center.dx + baseWidth * bustoScale * 0.35, center.dy - baseHeight * alturaScale * 0.1);
    path.lineTo(center.dx + baseWidth * cinturaScale * 0.25, center.dy);
    path.lineTo(center.dx + baseWidth * quadrilScale * 0.35, center.dy + baseHeight * alturaScale * 0.15);

    canvas.drawPath(path, paint);

    // Arms
    canvas.drawLine(
      Offset(center.dx - baseWidth * bustoScale * 0.4, center.dy - baseHeight * alturaScale * 0.25),
      Offset(center.dx - baseWidth * bustoScale * 0.6, center.dy + baseHeight * alturaScale * 0.1),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + baseWidth * bustoScale * 0.4, center.dy - baseHeight * alturaScale * 0.25),
      Offset(center.dx + baseWidth * bustoScale * 0.6, center.dy + baseHeight * alturaScale * 0.1),
      paint,
    );

    // Legs
    canvas.drawLine(
      Offset(center.dx - baseWidth * quadrilScale * 0.15, center.dy + baseHeight * alturaScale * 0.15),
      Offset(center.dx - baseWidth * quadrilScale * 0.15, center.dy + baseHeight * alturaScale * 0.45),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + baseWidth * quadrilScale * 0.15, center.dy + baseHeight * alturaScale * 0.15),
      Offset(center.dx + baseWidth * quadrilScale * 0.15, center.dy + baseHeight * alturaScale * 0.45),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}