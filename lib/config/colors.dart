import 'package:flutter/material.dart';

/// Configuração global de cores do app - Tema Elegante
class AppColors {
  // Cores primárias
  static const Color primary = Color(0xFFF4DDD4); // Bege rosado suave
  static const Color secondary = Color(0xFF2C2C2C); // Cinza escuro elegante
  static const Color accent = Color(0xFFE8C4B8); // Tom mais escuro do bege
  
  // Cores de fundo
  static const Color background = Color(0xFFFAFAFA); // Branco suave
  static const Color surface = Colors.white;
  static const Color cardBackground = Colors.white;
  
  // Cores de texto
  static const Color textPrimary = Color(0xFF2C2C2C);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textLight = Color(0xFF9E9E9E);
  
  // Cores de estado
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Cores de borda e divisores
  static const Color border = Color(0xFFE8E8E8);
  static const Color divider = Color(0xFFF0F0F0);
  
  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFF4DDD4), Color(0xFFE8C4B8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF2C2C2C), Color(0xFF424242)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Sombras
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];
  
  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: Color(0xFFF4DDD4).withOpacity(0.25),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];
}