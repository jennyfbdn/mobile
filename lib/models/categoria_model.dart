class Categoria {
  final int id;
  final String nome;
  final String descricao;
  final String statusCategoria;

  Categoria({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.statusCategoria,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      descricao: json['descricao'] ?? '',
      statusCategoria: json['statusCategoria'] ?? 'ATIVO',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'statusCategoria': statusCategoria,
    };
  }
}