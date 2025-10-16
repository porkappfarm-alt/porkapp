import 'package:flutter/material.dart';

abstract class AppColors {
  // Colores principales
  static const verdeField = Color(0xFF5CB85C);
  static const pigPink = Color(0xFFFCD8D4);
  static const coral = Color(0xFFE94C5D);
  static const burgundy = Color(0xFF3B1D2D);
  static const beigeLight = Color(0xFFFDF6F3);
  static const white = Colors.white;

  // Variantes y estados
  static const successLight = Color(0xFF86C886);
  static const successDark = Color(0xFF449944);
  static const error = Color(0xFFDC3545);
  static const warning = Color(0xFFFFC107);

  // Textos
  static const textPrimary = burgundy;
  static const textSecondary = Color(0xFF6C757D);
  static const textDisabled = Color(0xFFADB5BD);

  // Fondos
  static const backgroundPrimary = beigeLight;
  static const backgroundSecondary = pigPink;
  static const surfacePrimary = white;

  // Bordes
  static const borderLight = Color(0xFFE9ECEF);
  static const borderDark = Color(0xFFDEE2E6);
}

abstract class AppRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
}

abstract class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

abstract class AppElevation {
  static const List<BoxShadow> sm = [
    BoxShadow(color: Color(0x0F000000), blurRadius: 4, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> lg = [
    BoxShadow(color: Color(0x24000000), blurRadius: 15, offset: Offset(0, 6)),
  ];
}

abstract class AppGradients {
  static const LinearGradient primaryButton = LinearGradient(
    colors: [AppColors.coral, Color(0xFFE73140)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successButton = LinearGradient(
    colors: [AppColors.verdeField, AppColors.successDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
