import 'package:flutter/material.dart';
import 'agendamento_service.dart';
import 'user_service.dart';
import 'theme/app_theme.dart';
import 'services/servico_service.dart';

class PersonalizacaoPage extends StatefulWidget {
  @override
  _PersonalizacaoPageState createState() => _PersonalizacaoPageState();
}

class _PersonalizacaoPageState extends State<PersonalizacaoPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _descricaoController = TextEditingController();
  String _tipoPeca = 'Vestido';
  String _tipoPersonalizacao = 'Ajuste de tamanho';
  List<dynamic> servicos = [];
  bool isLoadingServicos = true;
  DateTime? _dataAgendamento;
  TimeOfDay? _horaAgendamento;
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
  
  final List<String> _tamanhosDisponiveis = ['PP', 'P', 'M', 'G', 'GG'];
  
  final Map<String, double> _precosPeca = {
    'Vestido': 80.0,
    'Blusa': 60.0,
    'Saia': 50.0,
    'Calça': 70.0,
    'Outro': 65.0,
  };
  
  final Map<String, double> _multiplicadorTamanho = {
    'PP': 0.9,
    'P': 0.95,
    'M': 1.0,
    'G': 1.1,
    'GG': 1.2,
  };
  
  final Map<String, double> _precosServico = {
    'Ajuste de tamanho': 25.0,
    'Bordado': 50.0,
    'Aplicação': 40.0,
    'Reforma': 60.0,
    'Outro': 35.0,
  };
  
  double get _valorTotal {
    double precoPeca = _precosPeca[_tipoPeca] ?? 65.0;
    double multiplicador = _multiplicadorTamanho[_tamanhoSelecionado] ?? 1.0;
    double precoServico = _precosServico[_tipoPersonalizacao] ?? 35.0;
    return (precoPeca * multiplicador) + precoServico;
  }

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
    _carregarDadosUsuario();
    _carregarServicos();
  }

  Future<void> _carregarDadosUsuario() async {
    final userService = UserService();
    await userService.carregarDados();
    if (userService.nomeUsuario != null) {
      _nomeController.text = userService.nomeUsuario!;
    }
    if (userService.telefoneUsuario != null) {
      _telefoneController.text = userService.telefoneUsuario!;
    }
  }

  Future<void> _carregarServicos() async {
    try {
      final result = await ServicoService.getServicos();
      setState(() {
        if (result['success']) {
          servicos = result['servicos'];
          if (servicos.isNotEmpty) {
            _tipoPersonalizacao = servicos[0]['nome'];
          }
        }
        isLoadingServicos = false;
      });
    } catch (e) {
      setState(() {
        isLoadingServicos = false;
      });
    }
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
                  _buildTextField(_descricaoController, 'Descrição do produto desejado', Icons.description_outlined),
                  SizedBox(height: 16),
                  _buildTipoPecaSelector(),
                  SizedBox(height: 16),
                  _buildTamanhoSelector(),
                  SizedBox(height: 16),
                  isLoadingServicos 
                    ? Center(child: CircularProgressIndicator())
                    : _buildDropdown('Tipo de personalização', _tipoPersonalizacao, 
                        servicos.isNotEmpty 
                          ? servicos.map((s) => s['nome'].toString()).toList()
                          : ['Ajuste de tamanho', 'Bordado', 'Aplicação', 'Reforma', 'Outro'], 
                        (v) => setState(() => _tipoPersonalizacao = v!)),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildDateSelector()),
                      SizedBox(width: 16),
                      Expanded(child: _buildTimeSelector()),
                    ],
                  ),
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
                          child: Text('Agendar Personalização', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, '/agendamentos'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[700],
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
                colors: [Colors.blue.withOpacity(0.3), Colors.blue.withOpacity(0.1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.withOpacity(0.5), width: 2),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _iconsPecas[_tipoPeca],
                    size: 60,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '$_tipoPeca - Tamanho $_tamanhoSelecionado',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    _tipoPersonalizacao,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Valor: R\$ ${_valorTotal.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
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

  Widget _buildTimeSelector() {
    return InkWell(
      onTap: () async {
        final hora = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: 9, minute: 0),
        );
        if (hora != null) setState(() => _horaAgendamento = hora);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[400]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time, color: Colors.grey[600]),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Horário', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  Text(_horaAgendamento != null ? '${_horaAgendamento!.hour.toString().padLeft(2, '0')}:${_horaAgendamento!.minute.toString().padLeft(2, '0')}' : 'Selecionar hora', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
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

  void _agendar() async {
    if (_formKey.currentState!.validate() && _dataAgendamento != null && _horaAgendamento != null) {
      final agendamento = {
        'nome': _nomeController.text,
        'telefone': _telefoneController.text,
        'tipoPeca': _tipoPeca,
        'tamanho': _tamanhoSelecionado,
        'tipoPersonalizacao': _tipoPersonalizacao,
        'descricao': _descricaoController.text.isNotEmpty ? _descricaoController.text : '$_tipoPeca com $_tipoPersonalizacao',
        'data': '${_dataAgendamento!.day}/${_dataAgendamento!.month}/${_dataAgendamento!.year}',
        'hora': '${_horaAgendamento!.hour.toString().padLeft(2, '0')}:${_horaAgendamento!.minute.toString().padLeft(2, '0')}',
        'status': 'Pendente',
      };
      
      final result = await AgendamentoService().adicionarAgendamento(agendamento);
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Agendamento Confirmado', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text('Sua visita foi agendada para ${_dataAgendamento!.day}/${_dataAgendamento!.month}/${_dataAgendamento!.year} às ${_horaAgendamento!.hour.toString().padLeft(2, '0')}:${_horaAgendamento!.minute.toString().padLeft(2, '0')}.\n\nValor estimado: R\$ ${_valorTotal.toStringAsFixed(2)}\n\n${result['message']}'),
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
    } else {
      String mensagem = '';
      if (_dataAgendamento == null) mensagem = 'Selecione uma data';
      else if (_horaAgendamento == null) mensagem = 'Selecione um horário';
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem)),
      );
    }
  }
}