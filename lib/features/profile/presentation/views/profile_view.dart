import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:porkapp/core/widgets/standard_app_bar.dart';
import 'package:porkapp/features/auth/providers/auth_provider.dart';
import 'package:porkapp/features/users/domain/user_profile.dart';
import 'package:porkapp/supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show UserAttributes;

const _primaryPink = Color(0xFFFF5A6E);
const _primaryPinkDark = Color(0xFFE91E63);
const _secondaryGreen = Color(0xFF4CAF50);
const _taupe = Color(0xFF6B5E55);
const _cream = Color(0xFFFFF5EC);
const _borderGray = Color(0xFFE9E9E9);
const _lightPink = Color(0xFFFFCDD2);
const _errorRed = Color(0xFFEF5350);

// Provider para obtener el perfil del usuario actual
final currentUserProfileProvider = FutureProvider<UserProfile?>((ref) async {
  // Observar el estado de autenticación para reiniciar cuando cambie el usuario
  ref.watch(authStateProvider);

  final user = supabase.auth.currentUser;
  if (user == null) return null;

  final response =
      await supabase.from('profiles').select().eq('id', user.id).single();

  return UserProfile.fromJson(response);
});

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _identificationController = TextEditingController();
  final _whatsappController = TextEditingController();

  bool _isEditing = false;
  bool _isLoading = false;
  bool _dataLoaded = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _identificationController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  void _loadUserData(UserProfile user) {
    if (!_dataLoaded) {
      _fullNameController.text = user.fullName ?? '';
      _identificationController.text = user.identificationNumber ?? '';
      _whatsappController.text = user.whatsappNumber ?? '';
      _dataLoaded = true;
    }
  }

  Future<void> _saveChanges(UserProfile currentUser) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      print('🔄 Actualizando perfil...');
      print('User ID: ${currentUser.id}');
      print('Full Name: ${_fullNameController.text.trim()}');
      print('Identification: ${_identificationController.text.trim()}');
      print('WhatsApp: ${_whatsappController.text.trim()}');

      // 1. Actualizar el metadata del usuario en auth.users
      await supabase.auth.updateUser(
        UserAttributes(
          data: {
            'full_name': _fullNameController.text.trim(),
            'identification_number':
                _identificationController.text.trim().isEmpty
                    ? null
                    : _identificationController.text.trim(),
            'whatsapp_number': _whatsappController.text.trim().isEmpty
                ? null
                : _whatsappController.text.trim(),
          },
        ),
      );

      print('✅ Metadata de auth.users actualizado');

      // 2. Actualizar la tabla profiles (el trigger sincronizará full_name desde auth.users)
      final response = await supabase
          .from('profiles')
          .update({
            'identification_number':
                _identificationController.text.trim().isEmpty
                    ? null
                    : _identificationController.text.trim(),
            'whatsapp_number': _whatsappController.text.trim().isEmpty
                ? null
                : _whatsappController.text.trim(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', currentUser.id)
          .select();

      print('✅ Respuesta de Supabase profiles: $response');

      // Invalidar el provider para recargar los datos
      ref.invalidate(currentUserProfileProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil actualizado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() => _isEditing = false);
      }
    } catch (e, stackTrace) {
      print('❌ Error al actualizar perfil: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar perfil: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        // Mostrar indicador de carga
        setState(() => _isLoading = true);

        print('ProfileView: Calling signOut...');
        await ref.read(authStateProvider.notifier).signOut();
        print('ProfileView: signOut completed');

        // El router listener se encargará de la navegación
      } catch (e) {
        print('ProfileView: Error during signOut: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al cerrar sesión: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProfileProvider);
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
    final helperStyle = theme.textTheme.bodySmall?.copyWith(
      color: _taupe.withOpacity(0.6),
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
      overlayColor: MaterialStateProperty.resolveWith(
        (states) => states.contains(MaterialState.pressed)
            ? _primaryPinkDark.withOpacity(0.12)
            : null,
      ),
    );
    final outlinedPrimaryStyle = OutlinedButton.styleFrom(
      padding: const EdgeInsets.all(16),
      backgroundColor: _lightPink.withOpacity(0.35),
      foregroundColor: _primaryPink,
      side: const BorderSide(color: _primaryPink, width: 1.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      textStyle: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
    final outlinedDangerStyle = OutlinedButton.styleFrom(
      padding: const EdgeInsets.all(16),
      foregroundColor: _errorRed,
      side: const BorderSide(color: _errorRed, width: 1.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      textStyle: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: StandardAppBar(
        title: 'Mi Perfil',
        automaticallyImplyLeading: false,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
              tooltip: 'Editar perfil',
            )
          else
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isEditing = false;
                  _dataLoaded = false;
                });
                // Recargar datos originales
                userAsync.whenData((user) {
                  if (user != null) _loadUserData(user);
                });
              },
              tooltip: 'Cancelar',
            ),
        ],
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text('No se pudo cargar la información del usuario'),
            );
          }

          // Cargar datos iniciales
          _loadUserData(user);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar y nombre
                  Center(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _lightPink.withOpacity(0.3),
                            Colors.white,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: _primaryPink.withOpacity(0.15),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _primaryPink.withOpacity(0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _primaryPink.withOpacity(0.3),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 52,
                              backgroundColor: _primaryPink,
                              child: Text(
                                (user.fullName ?? user.email)
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            user.fullName ?? 'Sin nombre',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: _taupe,
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: (user.isAdmin
                                      ? _primaryPink
                                      : _secondaryGreen)
                                  .withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: user.isAdmin
                                    ? _primaryPink
                                    : _secondaryGreen,
                              ),
                            ),
                            child: Text(
                              user.isAdmin ? 'Administrador' : 'Usuario',
                              style: TextStyle(
                                color: user.isAdmin
                                    ? _primaryPink
                                    : _secondaryGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Email (no editable)
                  Text('Correo electrónico', style: labelStyle),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: user.email,
                    enabled: false,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _taupe,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: _buildInputDecoration(
                      context,
                      icon: Icons.email,
                      helperText: 'El correo no puede ser modificado',
                      helperStyle: helperStyle,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Nombre completo
                  Text('Nombre completo', style: labelStyle),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _fullNameController,
                    enabled: _isEditing,
                    decoration: _buildInputDecoration(
                      context,
                      icon: Icons.person,
                      hintText: 'Ingresa tu nombre completo',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El nombre es requerido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Número de identificación
                  Text('Número de identificación', style: labelStyle),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _identificationController,
                    enabled: _isEditing,
                    keyboardType: TextInputType.number,
                    decoration: _buildInputDecoration(
                      context,
                      icon: Icons.badge,
                      hintText: 'Ingresa tu número de identificación',
                    ),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (!RegExp(r'^\d+$').hasMatch(value)) {
                          return 'Solo se permiten números';
                        }
                        if (value.length < 6) {
                          return 'Mínimo 6 dígitos';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // WhatsApp
                  Text('Número de WhatsApp', style: labelStyle),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _whatsappController,
                    enabled: _isEditing,
                    keyboardType: TextInputType.phone,
                    decoration: _buildInputDecoration(
                      context,
                      icon: Icons.phone,
                      hintText: 'Ej: 3001234567',
                    ),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final cleaned = value.replaceAll(RegExp(r'[^\d]'), '');
                        if (cleaned.length < 10 || cleaned.length > 15) {
                          return 'Número inválido (10-15 dígitos)';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Botón guardar cambios (solo visible en modo edición)
                  if (_isEditing)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : () => _saveChanges(user),
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.save),
                        label: Text(
                            _isLoading ? 'Guardando...' : 'Guardar cambios'),
                        style: saveButtonStyle,
                      ),
                    ),

                  if (_isEditing) const SizedBox(height: 16),

                  // Botón cambiar contraseña
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/update-password'),
                      icon: const Icon(Icons.lock),
                      label: const Text('Cambiar contraseña'),
                      style: outlinedPrimaryStyle,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Botón cerrar sesión
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _confirmLogout,
                      icon: const Icon(Icons.logout),
                      label: const Text('Cerrar sesión'),
                      style: outlinedDangerStyle,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Información adicional
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _borderGray,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Información de la cuenta',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: _taupe,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow('Estado', _getStatusText(user.status)),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          'Fecha de creación',
                          _formatDate(user.createdAt),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'active':
        return 'Activo';
      case 'pending':
        return 'Pendiente';
      case 'inactive':
        return 'Inactivo';
      default:
        return status;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  InputDecoration _buildInputDecoration(
    BuildContext context, {
    required IconData icon,
    String? hintText,
    String? helperText,
    TextStyle? helperStyle,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: _cream.withOpacity(0.4),
      hintText: hintText,
      helperText: helperText,
      helperStyle: helperStyle,
      prefixIcon: Icon(icon, color: _primaryPink, size: 22),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: _primaryPink.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: _borderGray.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: _primaryPink,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: _errorRed,
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: _errorRed,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),
    );
  }
}
