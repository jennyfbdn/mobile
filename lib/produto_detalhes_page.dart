import 'package:flutter/material.dart';
import 'encomenda_service.dart';

class ProdutoDetalhesPage extends StatefulWidget {
  final Map<String, dynamic> produto;

  const ProdutoDetalhesPage({Key? key, required this.produto}) : super(key: key);

  @override
  State<ProdutoDetalhesPage> createState() => _ProdutoDetalhesPageState();
}

class _ProdutoDetalhesPageState extends State<ProdutoDetalhesPage> {
  final _formKey = GlobalKey<FormState>();
  String? nome;
  String? telefone;
  int quantidade = 1;
  DateTime? dataRetirada;
  TimeOfDay? horaRetirada;

  void _selecionarData() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        dataRetirada = picked;
      });
    }
  }

  void _selecionarHora() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      setState(() {
        horaRetirada = picked;
      });
    }
  }

  void _confirmarEncomenda() {
    if (_formKey.currentState?.validate() ?? false) {
      if (dataRetirada == null || horaRetirada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selecione data e hora para retirada'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      _formKey.currentState?.save();

      final encomenda = {
        'produto': widget.produto['nome'],
        'nome': nome ?? '',
        'telefone': telefone ?? '',
        'quantidade': quantidade,
        'dataRetirada': '${dataRetirada!.day}/${dataRetirada!.month}/${dataRetirada!.year}',
        'horaRetirada': '${horaRetirada!.hour.toString().padLeft(2, '0')}:${horaRetirada!.minute.toString().padLeft(2, '0')}',
        'preco': widget.produto['preco'],
      };

      EncomendaService().adicionarEncomenda(encomenda);
      Navigator.pushNamed(context, '/agradecimento');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Detalhes do Produto',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black87),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: widget.produto['cor'] ?? Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.shopping_bag,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 24),
              
              Text(
                widget.produto['nome'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                widget.produto['descricao'] ?? '',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 16),
              Text(
                widget.produto['preco'],
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              SizedBox(height: 32),

              Text(
                'Informações da Encomenda',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Informe o nome' : null,
                onSaved: (value) => nome = value,
              ),
              SizedBox(height: 16),

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Telefone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => (value == null || value.isEmpty) ? 'Informe o telefone' : null,
                onSaved: (value) => telefone = value,
              ),
              SizedBox(height: 16),

              Row(
                children: [
                  Text(
                    'Quantidade: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    onPressed: () {
                      if (quantidade > 1) {
                        setState(() {
                          quantidade--;
                        });
                      }
                    },
                    icon: Icon(Icons.remove_circle_outline),
                  ),
                  Text(
                    '$quantidade',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        quantidade++;
                      });
                    },
                    icon: Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
              SizedBox(height: 24),

              Text(
                'Data e Hora para Retirada',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _selecionarData,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.grey[600]),
                            SizedBox(width: 12),
                            Text(
                              dataRetirada != null
                                  ? '${dataRetirada!.day}/${dataRetirada!.month}/${dataRetirada!.year}'
                                  : 'Selecionar data',
                              style: TextStyle(
                                fontSize: 16,
                                color: dataRetirada != null ? Colors.black87 : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: _selecionarHora,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.grey[600]),
                            SizedBox(width: 12),
                            Text(
                              horaRetirada != null
                                  ? '${horaRetirada!.hour.toString().padLeft(2, '0')}:${horaRetirada!.minute.toString().padLeft(2, '0')}'
                                  : 'Selecionar hora',
                              style: TextStyle(
                                fontSize: 16,
                                color: horaRetirada != null ? Colors.black87 : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _confirmarEncomenda,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Confirmar Encomenda',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}