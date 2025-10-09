import 'package:flutter/material.dart';

class GuiaMedidasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Guia de Medidas'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 4,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Como Tirar Suas Medidas',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                SizedBox(height: 8),
                Text('Siga este guia para obter medidas precisas',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                SizedBox(height: 24),
                
                // Gráfico do corpo humano
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Stack(
                    children: [
                      // Figura humana simplificada
                      Center(
                        child: CustomPaint(
                          size: Size(200, 350),
                          painter: CorpoHumanoPainter(),
                        ),
                      ),
                      // Indicadores de medidas
                      Positioned(
                        top: 50,
                        right: 20,
                        child: _buildIndicador('Altura', '1', Colors.red),
                      ),
                      Positioned(
                        top: 120,
                        right: 20,
                        child: _buildIndicador('Busto', '2', Colors.green),
                      ),
                      Positioned(
                        top: 200,
                        right: 20,
                        child: _buildIndicador('Cintura', '3', Colors.blue),
                      ),
                      Positioned(
                        top: 280,
                        right: 20,
                        child: _buildIndicador('Quadril', '4', Colors.purple),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Instruções detalhadas
                _buildInstrucao(
                  '1. Altura',
                  'Meça da cabeça até os pés, em pé, encostado na parede',
                  Colors.red,
                  Icons.height,
                ),
                
                SizedBox(height: 16),
                
                _buildInstrucao(
                  '2. Busto',
                  'Meça ao redor da parte mais larga do peito, mantendo a fita na horizontal',
                  Colors.green,
                  Icons.straighten,
                ),
                
                SizedBox(height: 16),
                
                _buildInstrucao(
                  '3. Cintura',
                  'Meça na parte mais estreita do tronco, geralmente acima do umbigo',
                  Colors.blue,
                  Icons.straighten,
                ),
                
                SizedBox(height: 16),
                
                _buildInstrucao(
                  '4. Quadril',
                  'Meça na parte mais larga do quadril, mantendo a fita na horizontal',
                  Colors.purple,
                  Icons.straighten,
                ),
                
                SizedBox(height: 24),
                
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb, color: Colors.orange[700]),
                          SizedBox(width: 8),
                          Text('Dicas Importantes',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange[700])),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text('• Use uma fita métrica flexível', style: TextStyle(color: Colors.grey[700])),
                      Text('• Mantenha a fita justa, mas não apertada', style: TextStyle(color: Colors.grey[700])),
                      Text('• Peça ajuda para medidas mais precisas', style: TextStyle(color: Colors.grey[700])),
                      Text('• Use roupas justas ou íntimas', style: TextStyle(color: Colors.grey[700])),
                    ],
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Tabela de tamanhos de referência
                Text('Tabela de Referência',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                SizedBox(height: 12),
                
                Table(
                  border: TableBorder.all(color: Colors.grey[300]!),
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey[100]),
                      children: [
                        _buildCelula('Tamanho', true),
                        _buildCelula('Busto (cm)', true),
                        _buildCelula('Cintura (cm)', true),
                        _buildCelula('Quadril (cm)', true),
                      ],
                    ),
                    TableRow(children: [_buildCelula('PP'), _buildCelula('80-84'), _buildCelula('60-64'), _buildCelula('86-90')]),
                    TableRow(children: [_buildCelula('P'), _buildCelula('84-88'), _buildCelula('64-68'), _buildCelula('90-94')]),
                    TableRow(children: [_buildCelula('M'), _buildCelula('88-92'), _buildCelula('68-72'), _buildCelula('94-98')]),
                    TableRow(children: [_buildCelula('G'), _buildCelula('92-96'), _buildCelula('72-76'), _buildCelula('98-102')]),
                    TableRow(children: [_buildCelula('GG'), _buildCelula('96-100'), _buildCelula('76-80'), _buildCelula('102-106')]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildIndicador(String texto, String numero, Color cor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(numero, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(width: 4),
          Text(texto, style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
  
  Widget _buildInstrucao(String titulo, String descricao, Color cor, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                SizedBox(height: 4),
                Text(descricao, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCelula(String texto, [bool isHeader = false]) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        texto,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: isHeader ? 14 : 13,
        ),
      ),
    );
  }
}

class CorpoHumanoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue[300]!
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    
    final center = Offset(size.width / 2, 0);
    
    // Cabeça
    canvas.drawCircle(Offset(center.dx, 30), 20, paint);
    
    // Corpo
    canvas.drawLine(Offset(center.dx, 50), Offset(center.dx, 200), paint);
    
    // Braços
    canvas.drawLine(Offset(center.dx, 80), Offset(center.dx - 40, 120), paint);
    canvas.drawLine(Offset(center.dx, 80), Offset(center.dx + 40, 120), paint);
    
    // Pernas
    canvas.drawLine(Offset(center.dx, 200), Offset(center.dx - 30, 300), paint);
    canvas.drawLine(Offset(center.dx, 200), Offset(center.dx + 30, 300), paint);
    
    // Linhas de medida
    final measurePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2;
    
    // Linha altura (1)
    canvas.drawLine(Offset(center.dx + 60, 10), Offset(center.dx + 60, 300), measurePaint);
    
    // Linha busto (2)  
    measurePaint.color = Colors.green;
    canvas.drawLine(Offset(center.dx - 50, 90), Offset(center.dx + 50, 90), measurePaint);
    
    // Linha cintura (3)
    measurePaint.color = Colors.blue;
    canvas.drawLine(Offset(center.dx - 40, 150), Offset(center.dx + 40, 150), measurePaint);
    
    // Linha quadril (4)
    measurePaint.color = Colors.purple;
    canvas.drawLine(Offset(center.dx - 45, 200), Offset(center.dx + 45, 200), measurePaint);
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}