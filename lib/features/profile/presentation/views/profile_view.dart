import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:porkapp/features/auth/providers/auth_provider.dart';
import 'package:porkapp/features/users/domain/user_profile.dart';
import 'package:porkapp/supabase/supabase.dart';

// Provider para obtener el perfil del usuario actual
final currentUserProfileProvider = FutureProvider<UserProfile?>((ref) async {
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
      // Actualizar directamente en Supabase
      await supabase.from('profiles').update({
        'full_name': _fullNameController.text.trim(),
        'identification_number': _identificationController.text.trim().isEmpty
            ? null
            : _identificationController.text.trim(),
        'whatsapp_number': _whatsappController.text.trim().isEmpty
            ? null
            : _whatsappController.text.trim(),
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', currentUser.id);

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
    } catch (e) {
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
      await ref.read(authStateProvider.notifier).signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
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
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar y nombre
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            (user.fullName ?? user.email)
                                .substring(0, 1)
                                .toUpperCase(),
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.fullName ?? 'Sin nombre',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: user.isAdmin ? Colors.purple : Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            user.isAdmin ? 'Administrador' : 'Usuario',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Email (no editable)
                  const Text(
                    'Correo electrónico',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: user.email,
                    enabled: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                      helperText: 'El correo no puede ser modificado',
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Nombre completo
                  const Text(
                    'Nombre completo',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _fullNameController,
                    enabled: _isEditing,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
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
                  const Text(
                    'Número de identificación',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _identificationController,
                    enabled: _isEditing,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.badge),
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
                  const Text(
                    'Número de WhatsApp',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _whatsappController,
                    enabled: _isEditing,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
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
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),

                  if (_isEditing) const SizedBox(height: 16),

                  // Botón cambiar contraseña
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/change-password'),
                      icon: const Icon(Icons.lock),
                      label: const Text('Cambiar contraseña'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
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
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Información adicional
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Información de la cuenta',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow('Estado', _getStatusText(user.status)),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            'Fecha de creación',
                            _formatDate(user.createdAt),
                          ),
                        ],
                      ),
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
}
