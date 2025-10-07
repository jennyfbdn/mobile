class ApiConfig {
  // Use o IP da sua máquina ao invés de localhost para funcionar no dispositivo móvel
  static const String baseUrl = 'http://localhost:8080'; // Para emulador Android
  // static const String baseUrl = 'http://192.168.1.XXX:8080'; // Para dispositivo físico - substitua XXX pelo seu IP
  static const String usuarioEndpoint = '$baseUrl/usuario';
}