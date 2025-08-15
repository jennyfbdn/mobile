import 'package:flutter/material.dart';
import 'agendamento_service.dart';

class PersonalizacaoPage extends StatefulWidget {
  @override
  _PersonalizacaoPageState createState() => _PersonalizacaoPageState();
}

class _PersonalizacaoPageState extends State<PersonalizacaoPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  String _tipoPeca = 'Vestido';
  String _tipoPersonalizacao = 'Ajuste de tamanho';
  DateTime? _dataAgendamento;
  Color _corSelecionada = Colors.blue;
  String _tamanhoSelecionado = 'M';
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  final Map<String, IconData> _iconsPecas = {
    'Vestido': Icons.checkroom,
    'Blusa': Icons.dry_cleaning,
    'Saia': Icons.woman,
    'Calça': Icons.man,
    'Outro': Icons.category,
  };
  
  final List<Color> _coresDisponiveis = [
    Colors.blue, Colors.red, Colors.green, Colors.purple,
    Colors.orange, Colors.pink, Colors.teal, Colors.brown,
  ];
  
  final List<String> _tamanhosDisponiveis = ['PP', 'P', 'M', 'G', 'GG'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
                  Text('Personalize sua Peça',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                  SizedBox(height: 8),
                  Text('Crie algo único com nossos especialistas',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                  SizedBox(height: 24),
                  
                  // Preview da peça
                  _buildPreviewSection(),
                  SizedBox(height: 24),
            
                  _buildTextField(_nomeController, 'Nome completo', Icons.person_outline),
                  SizedBox(height: 16),
                  _buildTextField(_telefoneController, 'Telefone', Icons.phone_outlined, TextInputType.phone),
                  SizedBox(height: 16),
                  _buildTipoPecaSelector(),
                  SizedBox(height: 16),
                  _buildCorSelector(),
                  SizedBox(height: 16),
                  _buildTamanhoSelector(),
                  SizedBox(height: 16),
                  _buildDropdown('Tipo de personalização', _tipoPersonalizacao, ['Ajuste de tamanho', 'Bordado', 'Aplicação', 'Reforma', 'Outro'], (v) => setState(() => _tipoPersonalizacao = v!)),
                  SizedBox(height: 16),
                  _buildDateSelector(),
                  SizedBox(height: 32),
            
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _agendar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 2,
                          ),
                          child: Text('Agendar Visita', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, '/agendamentos'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 2,
                          ),
                          child: Text('Ver Agendamentos', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewSection() {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_corSelecionada.withOpacity(0.3), _corSelecionada.withOpacity(0.1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _corSelecionada.withOpacity(0.5), width: 2),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _iconsPecas[_tipoPeca],
                    size: 80,
                    color: _corSelecionada,
                  ),
                  SizedBox(height: 12),
                  Text(
                    '$_tipoPeca - Tamanho $_tamanhoSelecionado',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _corSelecionada,
                    ),
                  ),
                  Text(
                    _tipoPersonalizacao,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTipoPecaSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tipo da Peça', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _iconsPecas.keys.map((tipo) {
            bool isSelected = _tipoPeca == tipo;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _tipoPeca = tipo;
                });
                _animationController.reset();
                _animationController.forward();
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black87 : Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected ? Colors.black87 : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _iconsPecas[tipo],
                      size: 18,
                      color: isSelected ? Colors.white : Colors.grey[600],
                    ),
                    SizedBox(width: 8),
                    Text(
                      tipo,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[600],
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Cor Preferida', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        Wrap(
          spacing: 12,
          children: _coresDisponiveis.map((cor) {
            bool isSelected = _corSelecionada == cor;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _corSelecionada = cor;
                });
                _animationController.reset();
                _animationController.forward();
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: cor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.black87 : Colors.grey[300]!,
                    width: isSelected ? 3 : 1,
                  ),
                ),
                child: isSelected
                    ? Icon(Icons.check, color: Colors.white, size: 20)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTamanhoSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tamanho', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        Row(
          children: _tamanhosDisponiveis.map((tamanho) {
            bool isSelected = _tamanhoSelecionado == tamanho;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _tamanhoSelecionado = tamanho;
                  });
                  _animationController.reset();
                  _animationController.forward();
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: 8),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black87 : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? Colors.black87 : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    tamanho,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[600],
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
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
      final agendamento = {
        'nome': _nomeController.text,
        'telefone': _telefoneController.text,
        'tipoPeca': _tipoPeca,
        'tipoPersonalizacao': _tipoPersonalizacao,
        'data': '${_dataAgendamento!.day}/${_dataAgendamento!.month}/${_dataAgendamento!.year}',
        'status': 'Pendente',
      };
      
      AgendamentoService().adicionarAgendamento(agendamento);
      
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