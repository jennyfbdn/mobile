class Usuario {
  final int? id;
  final String nome;
  final String? telefone;
  final String email;
  final String? senha;
  final String? nivelAcesso;
  final String? statusUsuario;
  final DateTime? dataCadastro;

  Usuario({
    this.id,
    required this.nome,
    this.telefone,
    required this.email,
    this.senha,
    this.nivelAcesso,
    this.statusUsuario,
    this.dataCadastro,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome: json['nome'],
      telefone: json['telefone'],
      email: json['email'],
      senha: json['senha'],
      nivelAcesso: json['nivelAcesso'],
      statusUsuario: json['statusUsuario'],
      dataCadastro: json['dataCadastro'] != null 
          ? DateTime.parse(json['dataCadastro']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'senha': senha,
      'nivelAcesso': nivelAcesso,
      'statusUsuario': statusUsuario,
      'dataCadastro': dataCadastro?.toIso8601String(),
    };
  }
}