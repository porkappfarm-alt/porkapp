import 'package:flutter/material.dart';
import 'package:porkapp/features/users/domain/user_profile.dart';
import 'package:porkapp/shared/design/colors.dart';

/// Card para mostrar un usuario del sistema
class UserCard extends StatelessWidget {
  final UserProfile user;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleStatus;
  final VoidCallback? onSendWhatsApp;

  const UserCard({
    super.key,
    required this.user,
    required this.onTap,
    this.onEdit,
    this.onDelete,
    this.onToggleStatus,
    this.onSendWhatsApp,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: user.isInactive ? 0.6 : 1.0,
      child: Card(
        elevation: 2,
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: _getRoleColor(user.role).withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              // Header con rol
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getRoleColor(user.role),
                      _getRoleColor(user.role).withOpacity(0.8),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(
                      _getRoleIcon(user.role),
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getRoleLabel(user.role),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    // Badge de status
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getStatusIcon(user.status),
                            size: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getStatusLabel(user.status),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (onEdit != null ||
                        onDelete != null ||
                        onToggleStatus != null)
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onSelected: (value) {
                          if (value == 'edit' && onEdit != null) {
                            onEdit!();
                          } else if (value == 'delete' && onDelete != null) {
                            _showDeleteConfirmation(context);
                          } else if (value == 'activate' &&
                              onToggleStatus != null) {
                            onToggleStatus!();
                          } else if (value == 'deactivate' &&
                              onToggleStatus != null) {
                            _showDeactivateConfirmation(context);
                          } else if (value == 'resend' &&
                              onToggleStatus != null) {
                            onToggleStatus!();
                          } else if (value == 'whatsapp' &&
                              onSendWhatsApp != null) {
                            onSendWhatsApp!();
                          }
                        },
                        itemBuilder: (context) => [
                          if (onEdit != null)
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 20),
                                  SizedBox(width: 8),
                                  Text('Editar'),
                                ],
                              ),
                            ),
                          // Opción de reenviar invitación para usuarios pendientes
                          if (onToggleStatus != null && user.isPending)
                            const PopupMenuItem(
                              value: 'resend',
                              child: Row(
                                children: [
                                  Icon(Icons.email,
                                      size: 20, color: PorkAppColors.secondary),
                                  SizedBox(width: 8),
                                  Text('Reenviar Invitación'),
                                ],
                              ),
                            ),
                          // Opción de enviar por WhatsApp para usuarios pendientes
                          if (onSendWhatsApp != null && user.isPending)
                            const PopupMenuItem(
                              value: 'whatsapp',
                              child: Row(
                                children: [
                                  Icon(Icons.send,
                                      size: 20, color: Color(0xFF25D366)),
                                  SizedBox(width: 8),
                                  Text('Enviar por WhatsApp'),
                                ],
                              ),
                            ),
                          // Opción de activar para usuarios inactivos (no pendientes)
                          if (onToggleStatus != null &&
                              !user.isActive &&
                              !user.isPending)
                            const PopupMenuItem(
                              value: 'activate',
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle,
                                      size: 20, color: PorkAppColors.success),
                                  SizedBox(width: 8),
                                  Text('Activar'),
                                ],
                              ),
                            ),
                          if (onToggleStatus != null && user.isActive)
                            const PopupMenuItem(
                              value: 'deactivate',
                              child: Row(
                                children: [
                                  Icon(Icons.block,
                                      size: 20, color: PorkAppColors.warning),
                                  SizedBox(width: 8),
                                  Text('Desactivar'),
                                ],
                              ),
                            ),
                          if (onDelete != null)
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete,
                                      size: 20, color: PorkAppColors.error),
                                  SizedBox(width: 8),
                                  Text('Eliminar',
                                      style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),

              // Contenido
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar y nombre
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor:
                              _getRoleColor(user.role).withOpacity(0.15),
                          child: Text(
                            _getInitials(user.fullName ?? user.email),
                            style: TextStyle(
                              color: _getRoleColor(user.role),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.fullName ?? 'Sin nombre',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.email,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 12),

                    // Información adicional
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            context,
                            icon: Icons.calendar_today,
                            label: 'Fecha de registro',
                            value: _formatDate(user.createdAt),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return PorkAppColors.primary;
      case 'user':
      default:
        return PorkAppColors.secondary;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'admin':
        return Icons.admin_panel_settings;
      case 'user':
      default:
        return Icons.person;
    }
  }

  String _getRoleLabel(String role) {
    switch (role) {
      case 'admin':
        return 'Administrador';
      case 'user':
      default:
        return 'Usuario';
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'active':
        return Icons.check_circle;
      case 'inactive':
        return Icons.block;
      case 'pending':
      default:
        return Icons.schedule;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'active':
        return 'Activo';
      case 'inactive':
        return 'Inactivo';
      case 'pending':
      default:
        return 'Pendiente';
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '?';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
          '¿Estás seguro de que deseas eliminar a ${user.fullName ?? user.email}?\n\nEsta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onDelete != null) onDelete!();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: PorkAppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showDeactivateConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar desactivación'),
        content: Text(
          '¿Estás seguro de que deseas desactivar a ${user.fullName ?? user.email}?\n\nEl usuario no podrá acceder al sistema.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onToggleStatus != null) onToggleStatus!();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: PorkAppColors.warning,
              foregroundColor: Colors.white,
            ),
            child: const Text('Desactivar'),
          ),
        ],
      ),
    );
  }
}
