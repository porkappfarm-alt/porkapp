import 'package:flutter/material.dart';

/// AppBar estandarizado para toda la aplicación
/// 
/// Características:
/// - Botón de retroceso automático (si hay navegación previa)
/// - Título centrado
/// - Fondo blanco sin elevación
/// - Estilo consistente en toda la app
class StandardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final VoidCallback? onBackPressed;

  const StandardAppBar({
    super.key,
    required this.title,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: automaticallyImplyLeading
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF2D3250),
              ),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Color(0xFF2D3250),
        ),
      ),
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
