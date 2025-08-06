class AgendamentoService {
  static final AgendamentoService _instance = AgendamentoService._internal();
  factory AgendamentoService() => _instance;
  AgendamentoService._internal();

  final List<Map<String, dynamic>> _agendamentos = [
    {
      'nome': 'Maria Silva',
      'telefone': '(11) 99999-9999',
      'tipoPeca': 'Vestido',
      'tipoPersonalizacao': 'Ajuste de tamanho',
      'data': '25/12/2024',
      'status': 'Confirmado',
    },
    {
      'nome': 'João Santos',
      'telefone': '(11) 88888-8888',
      'tipoPeca': 'Calça',
      'tipoPersonalizacao': 'Reforma',
      'data': '28/12/2024',
      'status': 'Pendente',
    },
  ];

  List<Map<String, dynamic>> obterAgendamentos() => List.from(_agendamentos);

  void adicionarAgendamento(Map<String, dynamic> agendamento) {
    _agendamentos.add(agendamento);
  }
}