class MedidasService {
  static final MedidasService _instance = MedidasService._internal();
  factory MedidasService() => _instance;
  MedidasService._internal();

  Map<String, String> _medidas = {};

  void salvarMedidas(Map<String, String> medidas) {
    _medidas = Map.from(medidas);
  }

  Map<String, String> obterMedidas() {
    return Map.from(_medidas);
  }

  bool temMedidas() {
    return _medidas.isNotEmpty && _medidas.values.any((v) => v.isNotEmpty);
  }
}