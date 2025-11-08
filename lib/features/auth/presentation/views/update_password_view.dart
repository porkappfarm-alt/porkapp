import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:porkapp/core/widgets/standard_app_bar.dart';
import 'package:porkapp/features/auth/data/auth_repository.dart';

// Colores coherentes con el resto de la aplicación
const _primaryPink = Color(0xFFFF5A6E);
const _primaryPinkDark = Color(0xFFE91E63);
const _secondaryGreen = Color(0xFF4CAF50);
const _taupe = Color(0xFF6B5E55);
const _cream = Color(0xFFFFF5EC);
const _borderGray = Color(0xFFE9E9E9);
const _lightPink = Color(0xFFFFCDD2);
const _errorRed = Color(0xFFEF5350);

class UpdatePasswordView extends ConsumerStatefulWidget {
  const UpdatePasswordView({super.key});

  @override
  ConsumerState<UpdatePasswordView> createState() => _UpdatePasswordViewState();
}

class _UpdatePasswordViewState extends ConsumerState<UpdatePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      print('🔄 Actualizando contraseña...');

      await ref
          .read(authRepositoryProvider)
          .changePassword(newPassword: _newPasswordController.text);

      print('✅ Contraseña actualizada exitosamente');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contraseña actualizada exitosamente'),
            backgroundColor: _secondaryGreen,
            duration: Duration(seconds: 2),
          ),
        );

        // Esperar un momento para que el usuario vea el mensaje
        await Future.delayed(const Duration(milliseconds: 500));

        // Volver a la pantalla anterior
        if (mounted) {
          context.pop();
        }
      }
    } catch (e) {
      print('❌ Error al actualizar contraseña: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: _errorRed,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final labelStyle = theme.textTheme.labelMedium?.copyWith(
          color: _taupe.withOpacity(0.65),
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ) ??
        const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _taupe,
        );

    final saveButtonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(16),
      backgroundColor: _primaryPink,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: _primaryPinkDark.withOpacity(0.35),
    ).copyWith(
      overlayColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.pressed)
            ? _primaryPinkDark.withOpacity(0.12)
            : null,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const StandardAppBar(title: 'Actualizar Contraseña'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Icono decorativo
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _cream,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.lock_reset, size: 64, color: _primaryPink),
                ),
                const SizedBox(height: 32),

                // Título
                Text(
                  'Actualizar tu Contraseña',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _taupe,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Descripción
                Text(
                  'Establece una nueva contraseña segura para tu cuenta.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: _taupe.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Requisitos de contraseña
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _lightPink.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _primaryPink.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: _primaryPink,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Requisitos de la contraseña:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _primaryPinkDark,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildRequirement('• Mínimo 8 caracteres'),
                      _buildRequirement('• Al menos una letra'),
                      _buildRequirement('• Al menos un número'),
                      _buildRequirement(
                          '• Solo letras y números (sin símbolos)'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Campo: Nueva contraseña
                Text('Nueva Contraseña', style: labelStyle),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _obscureNewPassword,
                  decoration: InputDecoration(
                    hintText: 'Ingresa tu nueva contraseña',
                    hintStyle: TextStyle(color: _taupe.withOpacity(0.4)),
                    filled: true,
                    fillColor: _cream,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: _borderGray),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: _borderGray),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: _primaryPink, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: _errorRed),
                    ),
                    prefixIcon: Icon(Icons.lock, color: _taupe),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNewPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: _taupe,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una contraseña';
                    }
                    if (value.length < 8) {
                      return 'La contraseña debe tener al menos 8 caracteres';
                    }
                    if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
                      return 'Debe contener al menos una letra';
                    }
                    if (!RegExp(r'[0-9]').hasMatch(value)) {
                      return 'Debe contener al menos un número';
                    }
                    // Validar que NO contenga caracteres especiales
                    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                      return 'Solo se permiten letras y números (sin caracteres especiales)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Campo: Confirmar contraseña
                Text('Confirmar Nueva Contraseña', style: labelStyle),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    hintText: 'Confirma tu nueva contraseña',
                    hintStyle: TextStyle(color: _taupe.withOpacity(0.4)),
                    filled: true,
                    fillColor: _cream,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: _borderGray),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: _borderGray),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: _primaryPink, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: _errorRed),
                    ),
                    prefixIcon: Icon(Icons.lock_clock, color: _taupe),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: _taupe,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor confirma tu contraseña';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Botón de actualizar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updatePassword,
                    style: saveButtonStyle,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            'Actualizar Contraseña',
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: _primaryPinkDark.withOpacity(0.8),
        ),
      ),
    );
  }
}
