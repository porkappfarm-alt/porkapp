import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:porkapp/core/widgets/standard_app_bar.dart';
import 'package:porkapp/shared/design/colors.dart';
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
    builder: (context) => ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Scaffold(
          backgroundColor: PorkAppColors.background,
          appBar: StandardAppBar(
            title: userToEdit != null ? 'Editar Usuario' : 'Invitar Usuario',
            automaticallyImplyLeading: false,
            centerTitle: false,
            backgroundColor: PorkAppColors.background,
            surfaceTintColor: PorkAppColors.background,
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          body: UserForm(
            scrollController: scrollController,
            userToEdit: userToEdit,
          ),
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
        Expanded(
          child: Form(
            key: _formKey,
            child: ListView(
              controller: widget.scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              children: [
                _buildHeaderCard(),
                const SizedBox(height: 24),
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
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCard() {
    final primaryColor = _isEditMode ? PorkAppColors.primary : PorkAppColors.secondary;
    final icon = _isEditMode ? Icons.edit_note_rounded : Icons.person_add_alt_1_rounded;
    final subtitle = _isEditMode
        ? 'Actualiza la información del usuario'
        : 'Completa los datos para enviar la invitación';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor.withOpacity(0.18), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primaryColor.withOpacity(0.25), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEditMode ? 'Editar Usuario' : 'Invitar Usuario',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
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
        _buildSectionTitle(
          icon: Icons.email,
          title: 'Correo Electrónico',
          color: PorkAppColors.primary,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _emailController,
          enabled: !_isEditMode, // Email no se puede editar
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'usuario@ejemplo.com',
            prefixIcon: Icon(Icons.alternate_email,
                color: _isEditMode ? Colors.grey[500] : PorkAppColors.primary),
            filled: true,
            fillColor:
                _isEditMode ? Colors.grey[100] : PorkAppColors.cardBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _isEditMode
                    ? Colors.grey[300]!
                    : PorkAppColors.primary.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _isEditMode
                    ? Colors.grey[300]!
                    : PorkAppColors.primary.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: PorkAppColors.primary, width: 2),
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
        _buildSectionTitle(
          icon: Icons.person,
          title: 'Nombre Completo',
          color: PorkAppColors.secondary,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _fullNameController,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Juan Pérez',
            prefixIcon: const Icon(Icons.badge, color: PorkAppColors.secondary),
            filled: true,
            fillColor: PorkAppColors.cardBackground,
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
        _buildSectionTitle(
          icon: Icons.badge,
          title: 'Número de Identificación',
          color: PorkAppColors.primary,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _identificationController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '12345678',
            prefixIcon: const Icon(Icons.credit_card, color: PorkAppColors.primary),
            filled: true,
            fillColor: PorkAppColors.cardBackground,
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
        _buildSectionTitle(
          icon: Icons.phone_android,
          title: 'Número de WhatsApp',
          color: PorkAppColors.secondary,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _whatsappController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: '3001234567',
            prefixIcon: const Icon(Icons.phone_android, color: PorkAppColors.secondary),
            filled: true,
            fillColor: PorkAppColors.cardBackground,
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
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: PorkAppColors.primary.withOpacity(0.25)),
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey[50]!],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              _buildRoleOption(
                value: 'user',
                title: 'Usuario',
                subtitle: 'Acceso estándar al sistema',
                icon: Icons.person,
                color: PorkAppColors.secondary,
              ),
              Divider(height: 1, color: Colors.grey[300]),
              _buildRoleOption(
                value: 'admin',
                title: 'Administrador',
                subtitle: 'Acceso completo y gestión de usuarios',
                icon: Icons.admin_panel_settings,
                color: PorkAppColors.primary,
              ),
            ],
          ),
        ),
      ],
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
              backgroundColor:
                  _isEditMode ? PorkAppColors.primary : PorkAppColors.secondary,
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
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
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
              foregroundColor: PorkAppColors.primary,
              side: BorderSide(color: PorkAppColors.primary.withOpacity(0.25)),
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
