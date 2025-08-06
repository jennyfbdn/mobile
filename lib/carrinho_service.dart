import 'package:flutter/foundation.dart';

class CarrinhoService extends ChangeNotifier {
  static final CarrinhoService _instance = CarrinhoService._internal();
  factory CarrinhoService() => _instance;
  CarrinhoService._internal();

  final List<Map<String, dynamic>> _itens = [];

  List<Map<String, dynamic>> get itens => List.unmodifiable(_itens);

  int get totalItens => _itens.fold(0, (total, item) => total + (item['quantidade'] as int));

  double get valorTotal {
    return _itens.fold(0.0, (total, item) {
      String precoStr = item['preco'].toString().replaceAll('R\$ ', '').replaceAll(',', '.');
      double preco = double.tryParse(precoStr) ?? 0.0;
      return total + (preco * item['quantidade']);
    });
  }

  void adicionarItem(Map<String, dynamic> produto) {
    final index = _itens.indexWhere((item) => item['nome'] == produto['nome']);
    
    if (index >= 0) {
      _itens[index]['quantidade']++;
    } else {
      _itens.add({
        ...produto,
        'quantidade': 1,
      });
    }
    notifyListeners();
  }

  void removerItem(String nomeProduto) {
    _itens.removeWhere((item) => item['nome'] == nomeProduto);
    notifyListeners();
  }

  void atualizarQuantidade(String nomeProduto, int novaQuantidade) {
    if (novaQuantidade <= 0) {
      removerItem(nomeProduto);
      return;
    }
    
    final index = _itens.indexWhere((item) => item['nome'] == nomeProduto);
    if (index >= 0) {
      _itens[index]['quantidade'] = novaQuantidade;
      notifyListeners();
    }
  }

  void limparCarrinho() {
    _itens.clear();
    notifyListeners();
  }
}