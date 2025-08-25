import 'package:flutter/material.dart';
import 'agendamento_service.dart';
import 'profile_page.dart';
import 'produtos_page.dart';

class AgendamentosPage extends StatefulWidget {
  @override
  _AgendamentosPageState createState() => _AgendamentosPageState();
}

class _AgendamentosPageState extends State<AgendamentosPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
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
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final agendamentos = AgendamentoService().obterAgendamentos();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Retirada de Materiais',
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
      body: agendamentos.isEmpty
          ? FadeTransition(
              opacity: _fadeAnimation,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 1000),
                      tween: Tween(begin: 0.0, end: 1.0),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(Icons.calendar_today, size: 64, color: Colors.blue[400]),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Nenhuma retirada agendada',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Agende a retirada dos seus materiais',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ProdutosPage()),
                        );
                      },
                      icon: Icon(Icons.shopping_bag),
                      label: Text('Ver Materiais'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                // Header com botão para produtos
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
                              'Materiais Disponíveis',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Agende sua retirada',
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
                            MaterialPageRoute(builder: (_) => ProdutosPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text('Ver Materiais'),
                      ),
                    ],
                  ),
                ),
                
                // Lista de agendamentos
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: agendamentos.length,
                    itemBuilder: (context, index) {
                      final agendamento = agendamentos[index];
                      return TweenAnimationBuilder<double>(
                        duration: Duration(milliseconds: 600 + (index * 100)),
                        tween: Tween(begin: 0.0, end: 1.0),
                        curve: Curves.easeOutBack,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 16),
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
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          agendamento['nome'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: agendamento['status'] == 'Confirmado'
                                                ? Colors.green[100]
                                                : Colors.orange[100],
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            agendamento['status'],
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: agendamento['status'] == 'Confirmado'
                                                  ? Colors.green[700]
                                                  : Colors.orange[700],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                                        SizedBox(width: 8),
                                        Text(
                                          agendamento['telefone'],
                                          style: TextStyle(color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                                        SizedBox(width: 8),
                                        Text(
                                          agendamento['data'],
                                          style: TextStyle(color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.inventory, size: 16, color: Colors.grey[600]),
                                        SizedBox(width: 8),
                                        Text(
                                          agendamento['material'] ?? 'Material não especificado',
                                          style: TextStyle(color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                                        SizedBox(width: 8),
                                        Text(
                                          'Horário: ${agendamento['horaRetirada'] ?? 'A definir'}',
                                          style: TextStyle(color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
                  MaterialPageRoute(builder: (_) => ProdutosPage()),
                );
              },
              backgroundColor: Colors.black87,
              child: Icon(Icons.schedule, color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}