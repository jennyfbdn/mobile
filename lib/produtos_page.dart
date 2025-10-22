import 'package:flutter/material.dart';
import 'dart:convert';
import 'encomenda_service.dart';
import 'profile_page.dart';
import 'produto_detalhes_page.dart';
import 'user_service.dart';
import 'agendamentos_page.dart';
import 'produto_service.dart';

class ProdutosPage extends StatefulWidget {
  final int? categoriaId;
  final String? categoriaNome;

  const ProdutosPage({Key? key, this.categoriaId, this.categoriaNome}) : super(key: key);

  @override
  _ProdutosPageState createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final ProdutoService _produtoService = ProdutoService();
  List<dynamic> produtos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
    _carregarProdutos();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _carregarProdutos() async {
    final result = widget.categoriaId != null 
        ? await _produtoService.listarProdutosPorCategoria(widget.categoriaId!)
        : await _produtoService.listarProdutos();
    setState(() {
      if (result['success']) {
        produtos = result['produtos'];
      } else {
        // Se falhar, usar dados mock
        produtos = materiais;
      }
      isLoading = false;
    });
  }
  final List<Map<String, dynamic>> materiais = [
    {
      'nome': 'Agulhas Sortidas',
      'preco': 'R\$ 12,00',
      'descricao': 'Kit com 20 agulhas de diversos tamanhos',
      'cor': Colors.grey[300],
      'imagem': 'assets/images/agulha.jpg',
      'icone': Icons.push_pin,
    },
    {
      'nome': 'Linhas de Algodão',
      'preco': 'R\$ 3,50',
      'descricao': 'Linha 100% algodão, ideal para costuras delicadas',
      'cor': Colors.blue[100],
      'imagem': 'assets/images/linha.jpg',
      'icone': Icons.colorize,
    },
  ];

  void _adicionarEncomenda(BuildContext context, Map<String, dynamic> material) {
    final nomeController = TextEditingController();
    final telefoneController = TextEditingController();
    DateTime? dataSelecionada;
    TimeOfDay? horaSelecionada;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Dados para Encomenda'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Seu nome'),
              ),
              TextField(
                controller: telefoneController,
                decoration: InputDecoration(labelText: 'Seu telefone'),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final data = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                        );
                        if (data != null) {
                          setState(() {
                            dataSelecionada = data;
                          });
                        }
                      },
                      child: Text(
                        dataSelecionada != null
                            ? '${dataSelecionada!.day}/${dataSelecionada!.month}/${dataSelecionada!.year}'
                            : 'Selecionar Data',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final hora = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (hora != null) {
                          setState(() {
                            horaSelecionada = hora;
                          });
                        }
                      },
                      child: Text(
                        horaSelecionada != null
                            ? '${horaSelecionada!.hour.toString().padLeft(2, '0')}:${horaSelecionada!.minute.toString().padLeft(2, '0')}'
                            : 'Selecionar Hora',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                String nome = nomeController.text.trim();
                String telefone = telefoneController.text.trim();
                
                if (nome.isNotEmpty && dataSelecionada != null && horaSelecionada != null) {
                  Map<String, dynamic> encomenda = {
                    'produto': material['nome'],
                    'nome': nome,
                    'telefone': telefone,
                    'quantidade': 1,
                    'preco': material['preco'],
                    'personalizacao': 'Material de costura',
                    'dataRetirada': '${dataSelecionada!.day}/${dataSelecionada!.month}/${dataSelecionada!.year}',
                    'horaRetirada': '${horaSelecionada!.hour.toString().padLeft(2, '0')}:${horaSelecionada!.minute.toString().padLeft(2, '0')}',
                  };
                  
                  final result = await EncomendaService().adicionarEncomenda(encomenda);
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result['success'] ? 'Encomenda criada com sucesso!' : result['message']),
                      backgroundColor: result['success'] ? Colors.green : Colors.orange,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Preencha todos os campos e selecione data/hora'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Confirmar'),
            ),
          ],
        ),
      ),
    );
  }

  String _convertImageToBase64(dynamic imageData) {
    if (imageData == null) return null;
    
    try {
      if (imageData is String) {
        return imageData;
      } else if (imageData is List) {
        final bytes = List<int>.from(imageData);
        final base64String = base64Encode(bytes);
        return base64String;
      }
    } catch (e) {
      print('Erro ao converter imagem: $e');
    }
    
    return null;
  }

  Map<String, dynamic> _formatarProduto(dynamic produto) {
    return {
      'nome': produto['nome'] ?? 'Produto',
      'preco': 'R\$ ${produto['preco']?.toStringAsFixed(2) ?? '0,00'}',
      'descricao': produto['descricao'] ?? 'Descrição não disponível',
      'cor': Colors.grey[200],
      'imagem': _convertImageToBase64(produto['foto']),
      'icone': Icons.shopping_bag,
    };
  }

  Widget _buildProductImage(String? imagePath) {
    if (imagePath == null) {
      return Container(
        width: double.infinity,
        height: 120,
        color: Colors.grey[200],
        child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey[400]),
      );
    }
    
    try {
      return Image.memory(
        base64Decode(imagePath),
        fit: BoxFit.cover,
        width: double.infinity,
        height: 120,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 120,
            color: Colors.grey[200],
            child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey[400]),
          );
        },
      );
    } catch (e) {
      return Container(
        width: double.infinity,
        height: 120,
        color: Colors.grey[200],
        child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey[400]),
      );
    }
  }

  Widget _buildLoadingCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: double.infinity,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: 100,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.categoriaNome ?? 'Materiais de Costura',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
        centerTitle: true,
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline, color: Colors.black87),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black87, Colors.black54],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Já tem agendamentos?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Veja seus compromissos',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AgendamentosPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text('Agendamentos'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: isLoading ? 6 : produtos.length,
                itemBuilder: (context, index) {
                  if (isLoading) {
                    return _buildLoadingCard();
                  }
                  final produto = produtos[index];
                  final material = _formatarProduto(produto);
                  return TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 600 + (index * 100)),
                    tween: Tween(begin: 0.0, end: 1.0),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 120,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: material['cor'],
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                child: material['imagem'] != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                        child: Stack(
                                          children: [
                                            _buildProductImage(material['imagem']),
                                            Positioned(
                                              top: 8,
                                              right: 8,
                                              child: Container(
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withOpacity(0.9),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Icon(
                                                  Icons.shopping_cart,
                                                  size: 16,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Center(
                                        child: Icon(
                                          material['icone'],
                                          size: 48,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        material['nome'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        material['descricao'],
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[600],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Spacer(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            material['preco'],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () => _adicionarEncomenda(context, material),
                                                child: Container(
                                                  padding: EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black87,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Icon(
                                                    Icons.add_shopping_cart,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: TweenAnimationBuilder<double>(
        duration: Duration(milliseconds: 1200),
        tween: Tween(begin: 0.0, end: 1.0),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AgendamentosPage()),
                );
              },
              backgroundColor: Colors.black87,
              child: Icon(Icons.calendar_today, color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}