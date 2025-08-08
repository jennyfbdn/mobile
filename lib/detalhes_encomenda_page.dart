import 'package:flutter/material.dart';

class DetalhesEncomendaPage extends StatelessWidget {
  final Map<String, dynamic> encomenda;

  const DetalhesEncomendaPage({Key? key, required this.encomenda}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Pedido #${encomenda['id']}', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black87),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: encomenda['cor'],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      encomenda['status'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Data do Pedido: ${encomenda['data']}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Informações do Cliente
            _buildSection(
              'Informações do Cliente',
              [
                _buildInfoRow(Icons.person, 'Nome', encomenda['nome'] ?? 'Sem nome'),
                _buildInfoRow(Icons.phone, 'Telefone', encomenda['telefone'] ?? 'Sem telefone'),
              ],
            ),
            SizedBox(height: 24),

            // Produto
            _buildSection(
              'Produto',
              [
                _buildInfoRow(Icons.shopping_bag, 'Item', encomenda['produto']),
                if (encomenda['quantidade'] != null)
                  _buildInfoRow(Icons.numbers, 'Quantidade', encomenda['quantidade'].toString()),
              ],
            ),
            SizedBox(height: 24),

            // Medidas
            if (encomenda['altura'] != null || encomenda['largura'] != null || encomenda['busto'] != null)
              _buildSection(
                'Medidas (cm)',
                [
                  if (encomenda['altura'] != null)
                    _buildInfoRow(Icons.height, 'Altura', encomenda['altura']),
                  if (encomenda['largura'] != null)
                    _buildInfoRow(Icons.straighten, 'Largura', encomenda['largura']),
                  if (encomenda['busto'] != null)
                    _buildInfoRow(Icons.accessibility, 'Busto', encomenda['busto']),
                ],
              ),
            
            if (encomenda['altura'] != null || encomenda['largura'] != null || encomenda['busto'] != null)
              SizedBox(height: 24),

            // Personalização
            _buildSection(
              'Personalização',
              [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    encomenda['personalizacao'] ?? 'Sem personalização',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Data e Hora de Retirada
            if (encomenda['dataRetirada'] != null && encomenda['dataRetirada'].toString().isNotEmpty)
              _buildSection(
                'Retirada',
                [
                  _buildInfoRow(Icons.calendar_today, 'Data', encomenda['dataRetirada']),
                  if (encomenda['horaRetirada'] != null && encomenda['horaRetirada'].toString().isNotEmpty)
                    _buildInfoRow(Icons.access_time, 'Hora', encomenda['horaRetirada']),
                ],
              ),

            SizedBox(height: 32),

            // Botão Voltar
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Voltar', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          SizedBox(width: 12),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}