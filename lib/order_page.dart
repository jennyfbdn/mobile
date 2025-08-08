import 'package:flutter/material.dart';
import 'localizacao_page.dart';
import 'encomenda_service.dart';
import 'medidas_page.dart';
import 'medidas_service.dart';
import 'user_service.dart';

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
  String? personalizacao;
  final TextEditingController _alturaController = TextEditingController();
  final TextEditingController _larguraController = TextEditingController();
  final TextEditingController _bustoController = TextEditingController();
  String? altura;
  String? largura;
  String? busto;
  Map<String, dynamic>? produtoSelecionado;
  int quantidade = 1;
  String? tipoPersonalizacao;
  DateTime? dataRetirada;
  TimeOfDay? horaRetirada;
  
  double get precoBase {
    if (produtoSelecionado != null && produtoSelecionado!['preco'] != null) {
      String precoStr = produtoSelecionado!['preco'].toString();
      precoStr = precoStr.replaceAll('R\$ ', '').replaceAll(',', '.');
      return double.tryParse(precoStr) ?? 150.0;
    }
    return 150.0;
  }
  
  final Map<String, double> precosPersonalizacao = {
    'Nenhuma': 0.0,
    'Bordado simples': 30.0,
    'Bordado complexo': 80.0,
    'Aplicação': 50.0,
    'Ajuste de tamanho': 25.0,
    'Reforma completa': 120.0,
  };
  
  double get precoTotal => (precoBase + (precosPersonalizacao[tipoPersonalizacao] ?? 0.0)) * quantidade;

  @override
  void initState() {
    super.initState();
    produtoSelecionado = widget.produtos.isNotEmpty ? widget.produtos[0] : null;
    tipoPersonalizacao = 'Nenhuma';
    _carregarMedidasSalvas();
  }
  
  void _carregarMedidasSalvas() {
    if (MedidasService().temMedidas()) {
      final medidas = MedidasService().obterMedidas();
      _alturaController.text = medidas['altura'] ?? '';
      _larguraController.text = medidas['cintura'] ?? '';
      _bustoController.text = medidas['busto'] ?? '';
    }
  }

  void _enviarEncomenda() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      
      // Salvar dados do usuário
      UserService().setUsuario(nome ?? '', telefone ?? '');
      
      // Adicionar encomenda ao serviço
      String personalizacaoFinal = '';
      if (personalizacao != null && personalizacao!.isNotEmpty) {
        personalizacaoFinal = personalizacao!;
      } else if (tipoPersonalizacao != null && tipoPersonalizacao != 'Nenhuma') {
        personalizacaoFinal = tipoPersonalizacao!;
      } else {
        personalizacaoFinal = 'Nenhuma';
      }
      
      final encomenda = {
        'produto': produtoSelecionado?['nome'] ?? 'Produto não selecionado',
        'nome': nome ?? 'Cliente',
        'telefone': telefone ?? '',
        'quantidade': quantidade,
        'altura': _alturaController.text,
        'largura': _larguraController.text,
        'busto': _bustoController.text,
        'personalizacao': personalizacaoFinal,
        'dataRetirada': dataRetirada != null ? '${dataRetirada!.day}/${dataRetirada!.month}/${dataRetirada!.year}' : '',
        'horaRetirada': horaRetirada != null ? '${horaRetirada!.hour.toString().padLeft(2, '0')}:${horaRetirada!.minute.toString().padLeft(2, '0')}' : '',
        'preco': 'R\$ ${precoTotal.toStringAsFixed(2)}',
      };
      
      EncomendaService().adicionarEncomenda(encomenda);
      Navigator.pushNamed(context, '/agradecimento');
    }
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required InputDecoration decoration,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
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
        decoration: decoration,
        style: TextStyle(color: Colors.black87),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[600]),
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
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Nova Encomenda', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black87),
        elevation: 2,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (produtoSelecionado != null)
              Container(
                margin: EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    produtoSelecionado!['imagem'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            _sectionTitle('Informações Pessoais'),
            SizedBox(height: 16),

            _buildTextField(
              decoration: _inputDecoration('Nome'),
              validator: (value) => (value == null || value.isEmpty) ? 'Informe o nome' : null,
              onSaved: (value) => nome = value,
            ),
            SizedBox(height: 16),
            _buildTextField(
              decoration: _inputDecoration('Telefone'),
              keyboardType: TextInputType.phone,
              validator: (value) => (value == null || value.isEmpty) ? 'Informe o telefone' : null,
              onSaved: (value) => telefone = value,
            ),
            SizedBox(height: 24),
            _sectionTitle('Entrega'),
            SizedBox(height: 16),
            Container(
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
                  Icon(Icons.store, size: 40, color: Colors.black87),
                  SizedBox(height: 12),
                  Text(
                    'Retirada no Ateliê',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Sua encomenda ficará pronta para retirada no ateliê.',
                    style: TextStyle(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => LocalizacaoPage()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.black87),
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Ver Localização', style: TextStyle(color: Colors.black87)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _sectionTitle('Medidas (cm)'),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => MedidasPage()));
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.black),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text('Manequim Ajustável', style: TextStyle(color: Colors.black, fontSize: 12)),
                ),
              ],
            ),
            SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildTextFieldWithController(
                    controller: _alturaController,
                    decoration: _inputDecoration('Altura'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Informe a altura';
                      if (double.tryParse(v) == null) return 'Número válido';
                      return null;
                    },
                    onSaved: (v) => altura = v,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildTextFieldWithController(
                    controller: _larguraController,
                    decoration: _inputDecoration('Largura'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Informe a largura';
                      if (double.tryParse(v) == null) return 'Número válido';
                      return null;
                    },
                    onSaved: (v) => largura = v,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildTextFieldWithController(
              controller: _bustoController,
              decoration: _inputDecoration('Busto'),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Informe o busto';
                if (double.tryParse(v) == null) return 'Informe um número válido';
                return null;
              },
              onSaved: (v) => busto = v,
            ),

            SizedBox(height: 24),
            _sectionTitle('Personalização'),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 2))],
              ),
              child: DropdownButtonFormField<String>(
                decoration: _inputDecoration('Tipo de personalização'),
                value: tipoPersonalizacao,
                items: precosPersonalizacao.keys.map((tipo) {
                  return DropdownMenuItem(
                    value: tipo,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(tipo),
                        Text('+R\$ ${precosPersonalizacao[tipo]!.toStringAsFixed(0)}', 
                             style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => tipoPersonalizacao = value),
              ),
            ),
            SizedBox(height: 16),
            _buildTextField(
              decoration: _inputDecoration('Observações (opcional)'),
              maxLines: 3,
              onSaved: (value) => personalizacao = value,
            ),
            SizedBox(height: 16),

            Container(
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
              child: DropdownButtonFormField<Map<String, dynamic>>(
                decoration: _inputDecoration('Produto'),
                value: produtoSelecionado,
                items: widget.produtos.map((produto) {
                  return DropdownMenuItem(value: produto, child: Text(produto['nome']));
                }).toList(),
                onChanged: (value) => setState(() {
                  produtoSelecionado = value;
                }),
                validator: (value) => value == null ? 'Selecione um produto' : null,
                style: TextStyle(color: Colors.black87),
              ),
            ),

            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
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
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Quantidade:',
                      style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (quantidade > 1) setState(() => quantidade--);
                          },
                          icon: Icon(Icons.remove, color: Colors.black87, size: 20),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            quantidade.toString(),
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ),
                        IconButton(
                          onPressed: () => setState(() => quantidade++),
                          icon: Icon(Icons.add, color: Colors.black87, size: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Preço base:', style: TextStyle(fontSize: 16)),
                      Text('R\$ ${precoBase.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  if (tipoPersonalizacao != 'Nenhuma') ...[
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$tipoPersonalizacao:', style: TextStyle(fontSize: 16)),
                        Text('+R\$ ${precosPersonalizacao[tipoPersonalizacao]!.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                  if (quantidade > 1) ...[
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Quantidade ($quantidade):', style: TextStyle(fontSize: 16)),
                        Text('x$quantidade', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                  Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('R\$ ${precoTotal.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            _sectionTitle('Data e Hora para Retirada'),
            SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final data = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(Duration(days: 1)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 30)),
                      );
                      if (data != null) setState(() => dataRetirada = data);
                    },
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
                    onTap: () async {
                      final hora = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(hour: 9, minute: 0),
                      );
                      if (hora != null) setState(() => horaRetirada = hora);
                    },
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
            SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _enviarEncomenda,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(
                  'Enviar Encomenda - R\$ ${precoTotal.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTextFieldWithController({
    required TextEditingController controller,
    required InputDecoration decoration,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
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
        decoration: decoration,
        style: TextStyle(color: Colors.black87),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}