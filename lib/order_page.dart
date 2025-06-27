import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  final List<Map<String, dynamic>> produtos;

  const OrderPage({Key? key, required this.produtos}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _formKey = GlobalKey<FormState>();

  String? nome;
  String? telefone;
  String? endereco;
  String? personalizacao;
  String? altura;
  String? largura;
  String? busto;
  Map<String, dynamic>? produtoSelecionado;
  int quantidade = 1;

  @override
  void initState() {
    super.initState();
    produtoSelecionado = widget.produtos.isNotEmpty ? widget.produtos[0] : null;
  }

  void _enviarEncomenda() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Encomenda enviada!', style: TextStyle(color: Colors.black)),
          content: Text(
            'Nome: $nome\n'
            'Telefone: $telefone\n'
            'Endereço: $endereco\n'
            'Produto: ${produtoSelecionado?['nome']}\n'
            'Quantidade: $quantidade\n'
            'Medidas (cm):\n'
            'Altura: $altura\n'
            'Largura: $largura\n'
            'Busto: $busto\n'
            'Personalização: ${personalizacao ?? "Nenhuma"}',
            style: TextStyle(color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Ok', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      );
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.black87),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black87),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Fazer Encomenda', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (produtoSelecionado != null)
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 6,
                  clipBehavior: Clip.hardEdge,
                  child: Image.asset(
                    produtoSelecionado!['imagem'],
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 20),

              TextFormField(
                decoration: _inputDecoration('Nome'),
                style: TextStyle(color: Colors.black87),
                validator: (value) => (value == null || value.isEmpty) ? 'Informe o nome' : null,
                onSaved: (value) => nome = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: _inputDecoration('Telefone'),
                style: TextStyle(color: Colors.black87),
                keyboardType: TextInputType.phone,
                validator: (value) => (value == null || value.isEmpty) ? 'Informe o telefone' : null,
                onSaved: (value) => telefone = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: _inputDecoration('Endereço'),
                style: TextStyle(color: Colors.black87),
                maxLines: 2,
                validator: (value) => (value == null || value.isEmpty) ? 'Informe o endereço' : null,
                onSaved: (value) => endereco = value,
              ),
              SizedBox(height: 16),

              Text(
                'Medidas (cm)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
              ),
              SizedBox(height: 12),

              TextFormField(
                decoration: _inputDecoration('Altura'),
                style: TextStyle(color: Colors.black87),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Informe a altura';
                  if (double.tryParse(v) == null) return 'Informe um número válido';
                  return null;
                },
                onSaved: (v) => altura = v,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: _inputDecoration('Largura'),
                style: TextStyle(color: Colors.black87),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Informe a largura';
                  if (double.tryParse(v) == null) return 'Informe um número válido';
                  return null;
                },
                onSaved: (v) => largura = v,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: _inputDecoration('Busto'),
                style: TextStyle(color: Colors.black87),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Informe o busto';
                  if (double.tryParse(v) == null) return 'Informe um número válido';
                  return null;
                },
                onSaved: (v) => busto = v,
              ),

              SizedBox(height: 16),
              TextFormField(
                decoration: _inputDecoration('Personalização (opcional)'),
                style: TextStyle(color: Colors.black87),
                maxLines: 3,
                onSaved: (value) => personalizacao = value,
              ),
              SizedBox(height: 16),

              DropdownButtonFormField<Map<String, dynamic>>(
                decoration: _inputDecoration('Produto'),
                value: produtoSelecionado,
                items: widget.produtos.map((produto) {
                  return DropdownMenuItem(value: produto, child: Text(produto['nome']));
                }).toList(),
                onChanged: (value) => setState(() => produtoSelecionado = value),
                validator: (value) => value == null ? 'Selecione um produto' : null,
                style: TextStyle(color: Colors.black87),
              ),

              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: Text('Quantidade:', style: TextStyle(fontSize: 16, color: Colors.black87))),
                  IconButton(
                    onPressed: () {
                      if (quantidade > 1) setState(() => quantidade--);
                    },
                    icon: Icon(Icons.remove_circle_outline, color: Colors.black87),
                  ),
                  Text(quantidade.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  IconButton(
                    onPressed: () => setState(() => quantidade++),
                    icon: Icon(Icons.add_circle_outline, color: Colors.black87),
                  ),
                ],
              ),

              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _enviarEncomenda,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Enviar Encomenda', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

