import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:porkapp/features/users/domain/user_profile.dart';
import 'package:porkapp/features/users/providers/user_provider.dart';

/// Muestra el bottom sheet con el formulario
void showUserFormBottomSheet(
  BuildContext context,
  WidgetRef ref, {
  UserProfile? userToEdit,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: UserForm(
          scrollController: scrollController,
          userToEdit: userToEdit,
        ),
      ),
    ),
  );
}

/// Formulario para crear/editar usuarios
class UserForm extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  final UserProfile? userToEdit;

  const UserForm({
    super.key,
    required this.scrollController,
    this.userToEdit,
  });

  @override
  ConsumerState<UserForm> createState() => _UserFormState();
}

class _UserFormState extends ConsumerState<UserForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _fullNameController;
  late TextEditingController _identificationController;
  late TextEditingController _whatsappController;
  String _selectedRole = 'user';
  String? _selectedStatus;
  bool _isLoading = false;

  bool get _isEditMode => widget.userToEdit != null;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(
      text: widget.userToEdit?.email ?? '',
    );
    _fullNameController = TextEditingController(
      text: widget.userToEdit?.fullName ?? '',
    );
    _identificationController = TextEditingController(
      text: widget.userToEdit?.identificationNumber ?? '',
    );
    _whatsappController = TextEditingController(
      text: widget.userToEdit?.whatsappNumber ?? '',
    );
    _selectedRole = widget.userToEdit?.role ?? 'user';
    _selectedStatus = widget.userToEdit?.status;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _identificationController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Handle del bottom sheet
        Container(
          margin: const EdgeInsets.only(top: 12),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        // Header
        _buildHeader(),

        // Contenido del formulario
        Expanded(
          child: Form(
            key: _formKey,
            child: ListView(
              controller: widget.scrollController,
              padding: const EdgeInsets.all(24),
              children: [
                _buildEmailSection(),
                const SizedBox(height: 20),
                _buildFullNameSection(),
                if (!_isEditMode) ...[
                  const SizedBox(height: 20),
                  _buildIdentificationSection(),
                  const SizedBox(height: 20),
                  _buildWhatsAppSection(),
                ],
                const SizedBox(height: 20),
                _buildRoleSection(),
                if (_isEditMode) ...[
                  const SizedBox(height: 20),
                  _buildStatusSection(),
                ],
                const SizedBox(height: 32),
                _buildActionButtons(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color:
                  (_isEditMode ? Colors.blue : Colors.purple).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _isEditMode ? Icons.edit : Icons.person_add,
              color: _isEditMode ? Colors.blue : Colors.purple,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEditMode ? 'Editar Usuario' : 'Invitar Usuario',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isEditMode
                      ? 'Actualiza la información del usuario'
                      : 'Envía una invitación por email',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.email, size: 20, color: Colors.grey[700]),
            const SizedBox(width: 8),
            const Text(
              'Correo Electrónico',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _emailController,
          enabled: !_isEditMode, // Email no se puede editar
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'usuario@ejemplo.com',
            prefixIcon: const Icon(Icons.alternate_email),
            filled: true,
            fillColor: _isEditMode ? Colors.grey[100] : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.purple, width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El correo electrónico es requerido';
            }
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value)) {
              return 'Ingresa un correo electrónico válido';
            }
            return null;
          },
        ),
        if (_isEditMode)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Text(
              'El correo electrónico no se puede modificar',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFullNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.person, size: 20, color: Colors.grey[700]),
            const SizedBox(width: 8),
            const Text(
              'Nombre Completo',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _fullNameController,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Juan Pérez',
            prefixIcon: const Icon(Icons.badge),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.purple, width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El nombre completo es requerido';
            }
            if (value.trim().length < 3) {
              return 'El nombre debe tener al menos 3 caracteres';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildIdentificationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.badge, size: 20, color: Colors.grey[700]),
            const SizedBox(width: 8),
            const Text(
              'Número de Identificación',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _identificationController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '12345678',
            prefixIcon: const Icon(Icons.credit_card),
            filled: true,
            fillColor: Colors.white,
            helperText: 'Este será usado como contraseña temporal',
            helperStyle: TextStyle(
              fontSize: 12,
              color: Colors.blue[700],
              fontWeight: FontWeight.w500,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.purple, width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El número de identificación es requerido';
            }
            if (!RegExp(r'^\d+$').hasMatch(value)) {
              return 'Debe contener solo números';
            }
            if (value.length < 6) {
              return 'Debe tener al menos 6 dígitos';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildWhatsAppSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.phone_android, size: 20, color: Colors.grey[700]),
            const SizedBox(width: 8),
            const Text(
              'Número de WhatsApp',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _whatsappController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: '3001234567',
            prefixIcon: const Icon(Icons.phone_android),
            filled: true,
            fillColor: Colors.white,
            helperText: 'Número para enviar las credenciales',
            helperStyle: TextStyle(
              fontSize: 12,
              color: Colors.green[700],
              fontWeight: FontWeight.w500,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.purple, width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El número de WhatsApp es requerido';
            }
            if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
              return 'Debe tener entre 10 y 15 dígitos';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRoleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.admin_panel_settings, size: 20, color: Colors.grey[700]),
            const SizedBox(width: 8),
            const Text(
              'Rol del Usuario',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildRoleOption(
                value: 'user',
                title: 'Usuario',
                subtitle: 'Acceso estándar al sistema',
                icon: Icons.person,
                color: Colors.blue,
              ),
              Divider(height: 1, color: Colors.grey[300]),
              _buildRoleOption(
                value: 'admin',
                title: 'Administrador',
                subtitle: 'Acceso completo y gestión de usuarios',
                icon: Icons.admin_panel_settings,
                color: Colors.purple,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoleOption({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _selectedRole == value;
    return InkWell(
      onTap: () => setState(() => _selectedRole = value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: const Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedRole,
              onChanged: (val) => setState(() => _selectedRole = val!),
              activeColor: color,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.info_outline, size: 20, color: Colors.grey[700]),
            const SizedBox(width: 8),
            const Text(
              'Estado del Usuario',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_selectedStatus == 'pending')
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              border: Border.all(color: Colors.orange[200]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.schedule, color: Colors.orange[700], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'El usuario aún no ha aceptado la invitación',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.orange[900],
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildStatusOption(
                  value: 'active',
                  title: 'Activo',
                  subtitle: 'El usuario puede acceder al sistema',
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
                Divider(height: 1, color: Colors.grey[300]),
                _buildStatusOption(
                  value: 'inactive',
                  title: 'Inactivo',
                  subtitle: 'El usuario no puede acceder al sistema',
                  icon: Icons.block,
                  color: Colors.red,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildStatusOption({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _selectedStatus == value;
    return InkWell(
      onTap: () => setState(() => _selectedStatus = value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: const Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedStatus,
              onChanged: (val) => setState(() => _selectedStatus = val),
              activeColor: color,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isEditMode ? Colors.blue : Colors.purple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_isEditMode ? Icons.save : Icons.send, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        _isEditMode ? 'Guardar Cambios' : 'Enviar Invitación',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              side: BorderSide(color: Colors.grey[300]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Cancelar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final notifier = ref.read(userNotifierProvider.notifier);

      if (_isEditMode) {
        // Editar usuario existente
        await notifier.updateUser(
          userId: widget.userToEdit!.id,
          fullName: _fullNameController.text.trim(),
          role: _selectedRole,
          status: _selectedStatus,
        );

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Usuario actualizado correctamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Invitar nuevo usuario
        final temporaryPassword = await notifier.inviteUser(
          email: _emailController.text.trim(),
          fullName: _fullNameController.text.trim(),
          role: _selectedRole,
          identificationNumber: _identificationController.text.trim(),
          whatsappNumber: _whatsappController.text.trim(),
        );

        if (mounted) {
          Navigator.of(context).pop();

          // Mostrar diálogo con la contraseña temporal
          await _showTemporaryPasswordDialog(
            context,
            _emailController.text.trim(),
            temporaryPassword,
            _whatsappController.text.trim(),
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
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Muestra un BottomSheet con la contraseña temporal generada
  Future<void> _showTemporaryPasswordDialog(
    BuildContext context,
    String email,
    String temporaryPassword,
    String whatsappNumber,
  ) async {
    return showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.only(top: 60),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 32),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Usuario creado exitosamente',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'El usuario ha sido creado y se le ha asignado una contraseña temporal.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 24),
                    // Email
                    const Text(
                      'Usuario:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      email,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    // WhatsApp
                    Text(
                      'WhatsApp: $whatsappNumber',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    // Contraseña temporal
                    const Text(
                      'Contraseña temporal:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: SelectableText(
                        temporaryPassword,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Warning
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange[200]!),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.orange,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'El usuario deberá cambiar esta contraseña en su primer inicio de sesión.',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  top: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cerrar'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _sendWhatsAppMessage(
                        whatsappNumber,
                        email,
                        temporaryPassword,
                      );
                    },
                    icon: const Icon(Icons.send),
                    label: const Text('Enviar por WhatsApp'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendWhatsAppMessage(
    String phoneNumber,
    String email,
    String password,
  ) async {
    // Limpiar el número de teléfono (eliminar espacios, guiones, paréntesis)
    String cleanPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

    // Si el número no tiene código de país, agregar +57 (Colombia)
    if (!cleanPhoneNumber.startsWith('+')) {
      cleanPhoneNumber = '+57$cleanPhoneNumber';
    }

    final message = '''
¡Hola! Has sido invitado a PorkApp - Criadero San Andrés

Tus credenciales de acceso son:

📧 Usuario: $email
🔑 Contraseña: $password

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
