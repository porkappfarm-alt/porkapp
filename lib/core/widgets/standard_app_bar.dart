import 'package:flutter/material.dart';
import 'package:porkapp/shared/design/colors.dart';

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
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? surfaceTintColor;
  final double? elevation;
  final double? scrolledUnderElevation;

  const StandardAppBar({
    super.key,
    required this.title,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.onBackPressed,
    this.centerTitle = true,
    this.backgroundColor,
    this.surfaceTintColor,
    this.elevation,
    this.scrolledUnderElevation,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation ?? 0,
      scrolledUnderElevation: scrolledUnderElevation ?? 0,
      backgroundColor: backgroundColor ?? Colors.white,
      surfaceTintColor: surfaceTintColor ?? Colors.white,
      iconTheme: const IconThemeData(color: PorkAppColors.titleText),
      centerTitle: centerTitle,
      leadingWidth: automaticallyImplyLeading ? 56 : 0,
      leading: automaticallyImplyLeading
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                size: 24,
              ),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Colors.black87,
        ),
      ),
      actions: actions != null
          ? [
              ...actions!,
              const SizedBox(width: 8), // Padding al final
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
