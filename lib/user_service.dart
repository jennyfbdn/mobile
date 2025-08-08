class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  String? _nomeUsuario;
  String? _telefoneUsuario;

  String? get nomeUsuario => _nomeUsuario;
  String? get telefoneUsuario => _telefoneUsuario;

  void setUsuario(String nome, String telefone) {
    _nomeUsuario = nome;
    _telefoneUsuario = telefone;
  }

  bool get temUsuario => _nomeUsuario != null && _nomeUsuario!.isNotEmpty;
}