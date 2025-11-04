import 'package:flutter/material.dart';

/// Paleta de colores oficial de PorkApp
class PorkAppColors {
  // Colores Primarios
  static const primary = Color(0xFFFF5A6E); // Rosa Cerdito Natural - Más vibrante
  static const secondary = Color(0xFF4CAF50); // Verde Agro - Más intenso
  static const titleText = Color(0xFF6B5E55); // Gris Taupe Moderno
  static const background =
      Color(0xFFFAFAFA); // Blanco Suave - Fondo Claro Base
  static const cardBackground = Color(0xFFFFF5EC); // Crema Pastel
  static const border = Color(0xFFE9E9E9); // Gris Claro
  static const mainText = Color(0xFF3E3E3E); // Gris Oscuro
  static const secondaryText = Color(0xFF7B7B7B); // Gris Medio

  // Estados
  static const success = Color(0xFF66BB6A); // Verde Claro - Más vivo
  static const warning = Color(0xFFFFA726); // Amarillo/Naranja - Más llamativo
  static const error = Color(0xFFEF5350); // Rojo Suave - Más intenso
  static const inactive = Color(0xFFC7C7C7); // Gris Neutro

  // Interacción
  static const buttonHover = Color(0xFFE75E63); // Rosa Oscuro
  static const buttonSecondary = Color(0xFFF9D2D2); // Rosa Claro
  static const navbarInactive = Color(0xFFBDBDBD); // Íconos inactivos

  // Colores Naturales de Apoyo
  static const grassGreen = Color(0xFFA8D5BA); // Verde Pasto
  static const earthBeige = Color(0xFFEBD5B3); // Beige Tierra
  static const lightPink = Color(0xFFFFDADA); // Rosado Claro
  static const mossGreen = Color(0xFF4F7D63); // Verde Musgo
  static const sandGrey = Color(0xFFDCD6D0); // Gris Arena

  // Gradientes
  static const gradientPrimary = LinearGradient(
    colors: [Color(0xFFF68A8A), Color(0xFFF07281)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientNature = LinearGradient(
    colors: [Color(0xFF7DBB95), Color(0xFF5DA271)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientBackground = LinearGradient(
    colors: [Color(0xFFFFF5EC), Color(0xFFFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Sombras
  static BoxShadow get defaultShadow => BoxShadow(
        color: const Color(0xFF000000).withOpacity(0.15),
        blurRadius: 12,
        offset: const Offset(0, 4),
      );

  static BoxShadow get primaryShadow => BoxShadow(
        color: primary.withOpacity(0.15),
        blurRadius: 12,
        offset: const Offset(0, 4),
      );
}
