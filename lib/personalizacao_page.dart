import 'package:flutter/material.dart';

class PersonalizacaoPage extends StatefulWidget {
  @override
  _PersonalizacaoPageState createState() => _PersonalizacaoPageState();
}

class _PersonalizacaoPageState extends State<PersonalizacaoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  String _tipoPeca = 'Vestido';
  String _tipoPersonalizacao = 'Ajuste de tamanho';
  DateTime? _dataAgendamento;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Personalização no Ateliê'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 4,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(24),
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Agende sua visita',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                  SizedBox(height: 8),
                  Text('Personalize sua peça com nossos especialistas',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                  SizedBox(height: 24),
            
                  _buildTextField(_nomeController, 'Nome completo', Icons.person_outline),
                  SizedBox(height: 16),
                  _buildTextField(_telefoneController, 'Telefone', Icons.phone_outlined, TextInputType.phone),
                  SizedBox(height: 16),
                  _buildDropdown('Tipo da peça', _tipoPeca, ['Vestido', 'Blusa', 'Saia', 'Calça', 'Outro'], (v) => setState(() => _tipoPeca = v!)),
                  SizedBox(height: 16),
                  _buildDropdown('Tipo de personalização', _tipoPersonalizacao, ['Ajuste de tamanho', 'Bordado', 'Aplicação', 'Reforma', 'Outro'], (v) => setState(() => _tipoPersonalizacao = v!)),
                  SizedBox(height: 16),
                  _buildDateSelector(),
                  SizedBox(height: 32),
            
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _agendar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                      child: Text('Agendar Visita', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, [TextInputType? keyboardType]) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.black)),
      ),
      validator: (v) => v?.isEmpty == true ? 'Campo obrigatório' : null,
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.category_outlined, color: Colors.grey[600]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.black)),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDateSelector() {
    return InkWell(
      onTap: () async {
        final data = await showDatePicker(
          context: context,
          initialDate: DateTime.now().add(Duration(days: 1)),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 30)),
        );
        if (data != null) setState(() => _dataAgendamento = data);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[400]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined, color: Colors.grey[600]),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Data do agendamento', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  Text(_dataAgendamento?.toString().split(' ')[0] ?? 'Selecionar data', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _agendar() {
    if (_formKey.currentState!.validate() && _dataAgendamento != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Agendamento Confirmado', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text('Sua visita foi agendada para ${_dataAgendamento!.day}/${_dataAgendamento!.month}/${_dataAgendamento!.year}.\n\nEntraremos em contato em breve para confirmar os detalhes.'),
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
    } else if (_dataAgendamento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selecione uma data')),
      );
    }
  }
}