import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:porkapp/features/users/domain/user_profile.dart';
import 'package:porkapp/features/users/providers/user_provider.dart';
import 'package:porkapp/features/users/presentation/widgets/user_card.dart';
import 'package:porkapp/features/users/presentation/widgets/user_form.dart';

class UserManagementView extends ConsumerStatefulWidget {
  const UserManagementView({super.key});

  @override
  ConsumerState<UserManagementView> createState() => _UserManagementViewState();
}

class _UserManagementViewState extends ConsumerState<UserManagementView> {
  String? _roleFilter;
  String? _statusFilter;

  @override
  Widget build(BuildContext context) {
    ref.watch(userRoleFilterProvider.notifier).state = _roleFilter;
    ref.watch(userStatusFilterProvider.notifier).state = _statusFilter;
    final usersAsync = ref.watch(filteredUsersProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Gestión de Usuarios',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Filtro por rol
          PopupMenuButton<String?>(
            icon: Icon(
              Icons.filter_alt,
              color: _roleFilter != null ? Colors.purple : Colors.black87,
            ),
            tooltip: 'Filtrar por rol',
            onSelected: (value) {
              setState(() => _roleFilter = value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: null,
                child: Text('Todos los roles'),
              ),
              const PopupMenuItem(
                value: 'admin',
                child: Row(
                  children: [
                    Icon(Icons.admin_panel_settings,
                        size: 18, color: Colors.purple),
                    SizedBox(width: 8),
                    Text('Administradores'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'user',
                child: Row(
                  children: [
                    Icon(Icons.person, size: 18, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Usuarios'),
                  ],
                ),
              ),
            ],
          ),
          // Filtro por status
          PopupMenuButton<String?>(
            icon: Icon(
              Icons.filter_list,
              color: _statusFilter != null ? Colors.orange : Colors.black87,
            ),
            tooltip: 'Filtrar por estado',
            onSelected: (value) {
              setState(() => _statusFilter = value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: null,
                child: Text('Todos los estados'),
              ),
              const PopupMenuItem(
                value: 'active',
                child: Row(
                  children: [
                    Icon(Icons.check_circle, size: 18, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Activos'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'pending',
                child: Row(
                  children: [
                    Icon(Icons.schedule, size: 18, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Pendientes'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'inactive',
                child: Row(
                  children: [
                    Icon(Icons.block, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Inactivos'),
                  ],
                ),
              ),
            ],
          ),
          // Botón agregar
          Container(
            margin: const EdgeInsets.only(right: 12, left: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.purple, Colors.deepPurple],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.person_add, color: Colors.white),
              tooltip: 'Invitar usuario',
              onPressed: () => showUserFormBottomSheet(context, ref),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(usersListProvider);
        },
        child: usersAsync.when(
          data: (userList) {
            if (userList.isEmpty) {
              return _buildEmptyState();
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: userList.length,
              itemBuilder: (context, index) {
                final user = userList[index];
                return UserCard(
                  user: user,
                  onTap: () => showUserFormBottomSheet(
                    context,
                    ref,
                    userToEdit: user,
                  ),
                  onEdit: () => showUserFormBottomSheet(
                    context,
                    ref,
                    userToEdit: user,
                  ),
                  onDelete: () => _deleteUser(user),
                  onToggleStatus: () => _toggleUserStatus(user),
                  onSendWhatsApp: user.isPending && user.whatsappNumber != null
                      ? () => _sendWhatsAppToUser(user)
                      : null,
                );
              },
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: Colors.purple,
            ),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar usuarios',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: TextStyle(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(usersListProvider);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_outline,
              size: 64,
              color: Colors.purple.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _roleFilter != null || _statusFilter != null
                ? 'No hay usuarios con estos filtros'
                : 'No hay usuarios registrados',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _roleFilter != null || _statusFilter != null
                ? 'Intenta ajustar los filtros'
                : 'Invita un nuevo usuario para comenzar',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          if (_roleFilter == null && _statusFilter == null) ...[
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.deepPurple],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => showUserFormBottomSheet(context, ref),
                  borderRadius: BorderRadius.circular(16),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_add, color: Colors.white),
                        SizedBox(width: 12),
                        Text(
                          'Invitar Usuario',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _deleteUser(UserProfile user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
          '¿Estás seguro de que deseas eliminar a ${user.fullName ?? user.email}?\n\nEsta acción no se puede deshacer.',
        ),
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
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(userNotifierProvider.notifier).deleteUser(user.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Usuario eliminado correctamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al eliminar: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _toggleUserStatus(UserProfile user) async {
    try {
      if (user.isPending) {
        // Reenviar invitación para usuarios pendientes
        final temporaryPassword = await ref
            .read(userNotifierProvider.notifier)
            .resendInvitation(user.id);

        if (mounted) {
          // Mostrar diálogo con la contraseña temporal
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text('Contraseña Temporal'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Usuario: ${user.email}'),
                  const SizedBox(height: 16),
                  const Text(
                    'Contraseña temporal:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[400]!),
                    ),
                    child: SelectableText(
                      temporaryPassword,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Comparte esta contraseña con el usuario de forma segura. '
                    'Deberá cambiarla en su primer inicio de sesión.',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cerrar'),
                ),
              ],
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invitación reenviada a ${user.email}'),
              backgroundColor: Colors.blue,
            ),
          );
        }
      } else if (user.isActive) {
        // Desactivar
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirmar desactivación'),
            content: Text(
              '¿Estás seguro de que deseas desactivar a ${user.fullName ?? user.email}?\n\nEl usuario no podrá acceder al sistema.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Desactivar'),
              ),
            ],
          ),
        );

        if (confirmed == true && mounted) {
          await ref.read(userNotifierProvider.notifier).deactivateUser(user.id);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Usuario desactivado correctamente'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      } else {
        // Activar (solo para usuarios inactivos, no pendientes)
        await ref.read(userNotifierProvider.notifier).activateUser(user.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Usuario activado correctamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _sendWhatsAppToUser(UserProfile user) async {
    if (user.whatsappNumber == null || user.identificationNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se puede enviar WhatsApp: datos incompletos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Limpiar el número de teléfono (eliminar espacios, guiones, paréntesis)
    String cleanPhoneNumber =
        user.whatsappNumber!.replaceAll(RegExp(r'[^\d+]'), '');

    // Si el número no tiene código de país, agregar +57 (Colombia)
    if (!cleanPhoneNumber.startsWith('+')) {
      cleanPhoneNumber = '+57$cleanPhoneNumber';
    }

    final message = '''
¡Hola! Has sido invitado a PorkApp - Criadero San Andrés

Tus credenciales de acceso son:

📧 Usuario: ${user.email}
🔑 Contraseña: ${user.identificationNumber}

⚠️ Por seguridad, deberás cambiar tu contraseña en el primer inicio de sesión.

Descarga la aplicación e inicia sesión con estas credenciales.
''';

    final encodedMessage = Uri.encodeComponent(message);

    // Intentar con diferentes esquemas de URL
    final urls = [
      'whatsapp://send?phone=$cleanPhoneNumber&text=$encodedMessage',
      'https://wa.me/$cleanPhoneNumber?text=$encodedMessage',
      'https://api.whatsapp.com/send?phone=$cleanPhoneNumber&text=$encodedMessage',
    ];

    bool success = false;

    for (final urlString in urls) {
      try {
        final uri = Uri.parse(urlString);

        // Intentar lanzar directamente sin verificar primero
        // (canLaunchUrl puede fallar en algunas plataformas)
        try {
          final launched = await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );

          if (launched) {
            success = true;
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Abriendo WhatsApp...'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            }
            break;
          }
        } catch (e) {
          // Si falla, continuar con el siguiente URL
          print('Error intentando $urlString: $e');
          continue;
        }
      } catch (e) {
        print('Error parseando URL: $e');
        continue;
      }
    }

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'No se pudo abrir WhatsApp',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text('Número: $cleanPhoneNumber'),
              const Text('Verifica que WhatsApp esté instalado'),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }
}
