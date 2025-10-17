class ApiConfig {
  // Configuração para diferentes ambientes
  // static const String baseUrl = 'http://10.0.2.2:8080'; // Para emulador Android
  static const String baseUrl = 'http://localhost:8080'; // Para desenvolvimento web
  // static const String baseUrl = 'http://172.19.2.101:8080'; // Para dispositivo físico na mesma rede
  
  static const String usuarioEndpoint = '$baseUrl/usuario';
  static const String agendamentoEndpoint = '$baseUrl/agendamento';
  static const String encomendaEndpoint = '$baseUrl/encomenda';
  static const String produtoEndpoint = '$baseUrl/produto';
  static const String mensagemEndpoint = '$baseUrl/mensagem';
  
  // Configuração para desenvolvimento (ignorar SSL)
  static const bool allowSelfSignedCertificates = true;
}