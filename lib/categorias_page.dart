import 'package:flutter/material.dart';
import 'models/categoria_model.dart';
import 'services/categoria_service.dart';
import 'produtos_page.dart';

class CategoriasPage extends StatefulWidget {
  @override
  _CategoriasPageState createState() => _CategoriasPageState();
}

class _CategoriasPageState extends State<CategoriasPage> {
  List<Categoria> categorias = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarCategorias();
  }

  Future<void> _carregarCategorias() async {
    try {
      final categoriasCarregadas = await CategoriaService.getCategorias();
      setState(() {
        categorias = categoriasCarregadas;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar categorias: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorias'),
        backgroundColor: Color(0xFFD4A574),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : categorias.isEmpty
              ? Center(child: Text('Nenhuma categoria encontrada'))
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: categorias.length,
                  itemBuilder: (context, index) {
                    final categoria = categorias[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(
                          categoria.nome,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: categoria.descricao.isNotEmpty
                            ? Text(categoria.descricao)
                            : null,
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProdutosPage(
                                categoriaId: categoria.id,
                                categoriaNome: categoria.nome,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}