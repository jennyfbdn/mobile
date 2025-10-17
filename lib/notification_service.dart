import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'config/api_config.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Criar notificação no servidor
  Future<bool> criarNotificacao({
    required int usuarioId,
    required String titulo,
    required String mensagem,
    required String tipo, // 'ENCOMENDA', 'AGENDAMENTO', 'GERAL'
    int? referenciaId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/notificacao/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usuarioId': usuarioId,
          'titulo': titulo,
          'mensagem': mensagem,
          'tipo': tipo,
          'referenciaId': referenciaId,
          'lida': false,
          'dataEnvio': DateTime.now().toIso8601String(),
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Erro ao criar notificação: $e');
      return false;
    }
  }

  // Buscar notificações do usuário
  Future<List<Map<String, dynamic>>> buscarNotificacoes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      
      if (userId == null) return [];

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/notificacao/usuario/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Map<String, dynamic>.from(item)).toList();
      }
    } catch (e) {
      print('Erro ao buscar notificações: $e');
    }
    
    return [];
  }

  // Marcar notificação como lida
  Future<bool> marcarComoLida(int notificacaoId) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/notificacao/$notificacaoId/lida'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Erro ao marcar notificação como lida: $e');
      return false;
    }
  }

  // Contar notificações não lidas
  Future<int> contarNaoLidas() async {
    try {
      final notificacoes = await buscarNotificacoes();
      return notificacoes.where((n) => n['lida'] == false).length;
    } catch (e) {
      print('Erro ao contar notificações não lidas: $e');
      return 0;
    }
  }

  // Notificar cliente sobre encomenda pronta
  Future<bool> notificarEncomendaPronta(int usuarioId, int encomendaId, String nomeCliente) async {
    return await criarNotificacao(
      usuarioId: usuarioId,
      titulo: 'Encomenda Pronta! 🎉',
      mensagem: 'Olá $nomeCliente! Sua encomenda está pronta para retirada. Venha buscar quando puder!',
      tipo: 'ENCOMENDA',
      referenciaId: encomendaId,
    );
  }

  // Notificar cliente sobre agendamento confirmado
  Future<bool> notificarAgendamentoConfirmado(int usuarioId, int agendamentoId, String nomeCliente, String dataHora) async {
    return await criarNotificacao(
      usuarioId: usuarioId,
      titulo: 'Agendamento Confirmado ✅',
      mensagem: 'Olá $nomeCliente! Seu agendamento para $dataHora foi confirmado. Te esperamos!',
      tipo: 'AGENDAMENTO',
      referenciaId: agendamentoId,
    );
  }

  // Notificar cliente sobre agendamento próximo
  Future<bool> notificarAgendamentoProximo(int usuarioId, int agendamentoId, String nomeCliente, String dataHora) async {
    return await criarNotificacao(
      usuarioId: usuarioId,
      titulo: 'Lembrete de Agendamento ⏰',
      mensagem: 'Olá $nomeCliente! Lembrando que você tem um agendamento hoje às $dataHora. Te esperamos!',
      tipo: 'AGENDAMENTO',
      referenciaId: agendamentoId,
    );
  }
}