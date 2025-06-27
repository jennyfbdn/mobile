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
  double? altura;
  double? largura;
  double? profundidade;
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

      String medidasTexto = (altura != null || largura != null || profundidade != null)
          ? 'Medidas (cm): Altura: ${altura?.toStringAsFixed(1) ?? "-"}, '
              'Largura: ${largura?.toStringAsFixed(1) ?? "-"}, '
              'Profundidade: ${profundidade?.toStringAsFixed(1) ?? "-"}\n'
          : '';

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Encomenda enviada!'),
          content: Text(
            'Nome: $nome\n'
            'Telefone: $telefone\n'
            'Endereço: $endereco\n'
            '${medidasTexto}'
            'Produto: ${produtoSelecionado?['nome']}\n'
            'Quantidade: $quantidade\n'
            'Total: R\$ ${(produtoSelecionado?['preco'] * quantidade).toStringAsFixed(2)}\n'
            'Personalização: ${personalizacao ?? "Nenhuma"}',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Ok')),
          ],
        ),
      );
    }
  }

  String? _validarDoubleOpcional(String? value) {
    if (value == null || value.isEmpty) return null;
    final v = double.tryParse(value.replaceAll(',', '.'));
    if (v == null) return 'Informe um número válido';
    if (v <= 0) return 'Deve ser maior que zero';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12);
    final inputBorder = OutlineInputBorder(borderRadius: borderRadius);

    return Scaffold(
      appBar: AppBar(
        title: Text('Fazer Encomenda', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      prefixIcon: Icon(Icons.person),
                      border: inputBorder,
                    ),
                    validator: (value) => (value == null || value.isEmpty) ? 'Informe o nome' : null,
                    onSaved: (value) => nome = value,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Telefone',
                      prefixIcon: Icon(Icons.phone),
                      border: inputBorder,
                    ),
                    validator: (value) => (value == null || value.isEmpty) ? 'Informe o telefone' : null,
                    onSaved: (value) => telefone = value,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Endereço',
                      prefixIcon: Icon(Icons.location_on),
                      border: inputBorder,
                    ),
                    validator: (value) => (value == null || value.isEmpty) ? 'Informe o endereço' : null,
                    onSaved: (value) => endereco = value,
                    maxLines: 2,
                  ),
                  SizedBox(height: 16),

                  // Medidas
                  Text(
                    'Medidas (cm) - opcional',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            labelText: 'Altura',
                            suffixText: 'cm',
                            border: inputBorder,
                          ),
                          validator: _validarDoubleOpcional,
                          onSaved: (value) => altura = (value != null && value.isNotEmpty)
                              ? double.parse(value.replaceAll(',', '.'))
                              : null,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            labelText: 'Largura',
                            suffixText: 'cm',
                            border: inputBorder,
                          ),
                          validator: _validarDoubleOpcional,
                          onSaved: (value) => largura = (value != null && value.isNotEmpty)
                              ? double.parse(value.replaceAll(',', '.'))
                              : null,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            labelText: 'Profundidade',
                            suffixText: 'cm',
                            border: inputBorder,
                          ),
                          validator: _validarDoubleOpcional,
                          onSaved: (value) => profundidade = (value != null && value.isNotEmpty)
                              ? double.parse(value.replaceAll(',', '.'))
                              : null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Personalização (opcional)',
                      border: inputBorder,
                      hintText: 'Ex: Incluir fita vermelha, bordado com nome...',
                      prefixIcon: Icon(Icons.edit),
                    ),
                    onSaved: (value) => personalizacao = value,
                    maxLines: 3,
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<Map<String, dynamic>>(
                    decoration: InputDecoration(
                      labelText: 'Produto',
                      border: inputBorder,
                      prefixIcon: Icon(Icons.shopping_bag),
                    ),
                    value: produtoSelecionado,
                    items: widget.produtos.map((produto) {
                      return DropdownMenuItem(value: produto, child: Text(produto['nome']));
                    }).toList(),
                    onChanged: (value) => setState(() => produtoSelecionado = value),
                    validator: (value) => value == null ? 'Selecione um produto' : null,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: Text('Quantidade:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                      IconButton(
                        onPressed: () {
                          if (quantidade > 1) setState(() => quantidade--);
                        },
                        icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                      ),
                      Text(quantidade.toString(),
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: () => setState(() => quantidade++),
                        icon: Icon(Icons.add_circle_outline, color: Colors.green),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _enviarEncomenda,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                    ),
                    child: Text('Enviar Encomenda', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
