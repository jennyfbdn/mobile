class Produto {
  final int id;
  final String nome;
  final String tipo;
  final String descricao;
  final String codigoBarras;
  final String fotoUrl; // Supondo que a foto seja uma URL
  final double preco;
  final String statusProduto;

  Produto({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.descricao,
    required this.codigoBarras,
    required this.fotoUrl,
    required this.preco,
    required this.statusProduto,
  });

  // Construtor que trata valores nulos, como fotoUrl
  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      tipo: json['tipo'] ?? '',
      descricao: json['descricao'] ?? '',
      codigoBarras: json['codigoBarras'] ?? '',
      fotoUrl: json['fotoUrl'] ?? '',
      preco: (json['preco'] as num?)?.toDouble() ?? 0.0,
      statusProduto: json['statusProduto'] ?? '',
    );
  }
}
