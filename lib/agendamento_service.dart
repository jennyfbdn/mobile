class AgendamentoService {
  static final AgendamentoService _instance = AgendamentoService._internal();
  factory AgendamentoService() => _instance;
  AgendamentoService._internal();

  final List<Map<String, dynamic>> _agendamentos = [];

  List<Map<String, dynamic>> obterAgendamentos() => List.from(_agendamentos);

  void adicionarAgendamento(Map<String, dynamic> agendamento) {
    _agendamentos.add(agendamento);
  }
}