import 'package:flutter/material.dart';

class AppTheme {
  // Cores principais
  static const Color primaryColor = Color(0xFF2C3E50);      // Azul escuro elegante
  static const Color secondaryColor = Color(0xFF34495E);    // Azul acinzentado
  static const Color accentColor = Color(0xFF3498DB);       // Azul claro
  static const Color successColor = Color(0xFF27AE60);      // Verde
  static const Color warningColor = Color(0xFFF39C12);      // Laranja
  static const Color errorColor = Color(0xFFE74C3C);        // Vermelho
  
  // Cores neutras
  static const Color backgroundColor = Color(0xFFF8F9FA);   // Cinza muito claro
  static const Color surfaceColor = Colors.white;
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color dividerColor = Color(0xFFECF0F1);
  
  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Sombras
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];
  
  // Estilos de botão
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 0,
  );
  
  // Decorações de container
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: surfaceColor,
    borderRadius: BorderRadius.circular(16),
    boxShadow: cardShadow,
  );
}