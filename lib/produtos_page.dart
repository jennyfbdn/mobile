import 'package:flutter/material.dart';
import 'encomenda_service.dart';
import 'profile_page.dart';
import 'produto_detalhes_page.dart';
import 'user_service.dart';

class ProdutosPage extends StatelessWidget {
  final List<Map<String, dynamic>> produtos = [
    {
      'nome': 'Linha de Algodão',
      'preco': 'R\$ 3,50',
      'descricao': 'Linha 100% algodão, ideal para costuras delicadas',
      'cor': Colors.blue[100],
      'imagem': 'assets/images/blusa_bege.jpg',
      'icone': Icons.colorize,
    },
    {
      'nome': 'Linha de Poliéster',
      'preco': 'R\$ 2,80',
      'descricao': 'Linha resistente para costuras pesadas',
      'cor': Colors.green[100],
      'imagem': 'assets/images/blusa_verde.jpg',
      'icone': Icons.colorize,
    },
    {
      'nome': 'Agulhas Sortidas',
      'preco': 'R\$ 12,00',
      'descricao': 'Kit com 20 agulhas de diversos tamanhos',
      'cor': Colors.orange[100],
      'imagem': null,
      'icone': Icons.push_pin,
    },
    {
      'nome': 'Tesoura de Costura',
      'preco': 'R\$ 25,00',
      'descricao': 'Tesoura profissional afiada',
      'cor': Colors.purple[100],
      'imagem': null,
      'icone': Icons.content_cut,
    },
    {
      'nome': 'Fita Métrica',
      'preco': 'R\$ 8,50',
      'descricao': 'Fita métrica flexível 150cm',
      'cor': Colors.pink[100],
      'imagem': null,
      'icone': Icons.straighten,
    },
    {
      'nome': 'Botões Variados',
      'preco': 'R\$ 15,00',
      'descricao': 'Conjunto com 50 botões diversos',
      'cor': Colors.cyan[100],
      'imagem': 'assets/images/vestido_floral.jpg',
      'icone': Icons.radio_button_unchecked,
    },
  ];

  void _adicionarEncomenda(BuildContext context, Map<String, dynamic> produto) {
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
              onPressed: () {
                String nome = nomeController.text.trim();
                String telefone = telefoneController.text.trim();
                
                if (nome.isNotEmpty && dataSelecionada != null && horaSelecionada != null) {
                  Map<String, dynamic> encomenda = {
                    'produto': produto['nome'],
                    'nome': nome,
                    'telefone': telefone,
                    'quantidade': 1,
                    'preco': produto['preco'],
                    'personalizacao': 'Produto de costura',
                    'dataRetirada': '${dataSelecionada!.day}/${dataSelecionada!.month}/${dataSelecionada!.year}',
                    'horaRetirada': '${horaSelecionada!.hour.toString().padLeft(2, '0')}:${horaSelecionada!.minute.toString().padLeft(2, '0')}',
                  };
                  
                  EncomendaService().adicionarEncomenda(encomenda);
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Encomenda criada com sucesso!'),
                      backgroundColor: Colors.green,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Produtos de Costura',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
        centerTitle: true,
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline, color: Colors.black87),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: produtos.length,
        itemBuilder: (context, index) {
          final produto = produtos[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: Offset(0, 4),
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
                    color: produto['cor'],
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: produto['imagem'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.asset(
                            produto['imagem'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 120,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(
                                  produto['icone'],
                                  size: 48,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Icon(
                            produto['icone'],
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
                          produto['nome'],
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
                          produto['descricao'],
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
                              produto['preco'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => _adicionarEncomenda(context, produto),
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.green[600],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(
                                      Icons.add_shopping_cart,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ProdutoDetalhesPage(produto: produto),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.black87,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(
                                      Icons.visibility,
                                      color: Colors.white,
                                      size: 14,
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
          );
        },
      ),
    );
  }
}