class ApiConfig {
  // Use o IP da sua máquina ao invés de localhost para funcionar no dispositivo móvel
  static const String baseUrl = 'http://localhost:8080'; // Para desenvolvimento local
  // static const String baseUrl = 'http://10.0.2.2:8080'; // Para emulador Android
  // static const String baseUrl = 'http://172.19.1.197:8080'; // Para dispositivo físico
  static const String usuarioEndpoint = '$baseUrl/usuario';
  
  // Configuração para desenvolvimento (ignorar SSL)
  static const bool allowSelfSignedCertificates = true;
}