import 'package:flutter/material.dart';

abstract class DesignSystem {
  static final colors = _Colors();
}

class _Colors {
  final Color primary = const Color(0xFFEA4D57);

  final Color backgroundLight = const Color(0xFFF8F6F6);
  final Color backgroundDark = const Color(0xFF211112);

  final Color surfaceLight = Colors.white;
  final Color surfaceDark = const Color(0xFF2C1D1E);

  final Color textLight = const Color(0xFF181112);
  final Color textDark = const Color(0xFFF8F6F6);

  final Color textSubtleLight = const Color(0xFF886365);
  final Color textSubtleDark = const Color(0xFFA18A8B);

  final Color borderLight = const Color(0xFFE5E0E0);
  final Color borderDark = const Color(0xFF4A3A3B);
}
