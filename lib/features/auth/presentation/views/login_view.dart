import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:porkapp/shared/design/app_styles.dart';
import 'package:porkapp/shared/design/app_theme_data.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  late final AnimationController _animationController;
  late final Animation<double> _fadeInAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      try {
        // TODO: Implementar lógica de autenticación
        await Future.delayed(const Duration(seconds: 2)); // Simulación
        if (mounted) {
          context.go('/dashboard');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error: $e',
                style: AppTextStyles.body2.copyWith(color: AppColors.white),
              ),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
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
    final size = MediaQuery.of(context).size;
    final horizontalPadding =
        size.width > 600 ? (size.width - 600) / 2 : AppSpacing.md;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: FadeTransition(
                opacity: _fadeInAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Card(
                    elevation: 8,
                    shadowColor: Colors.black.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Logo
                            Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFEC407A),
                                    Color(0xFFE91E63),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFEC407A)
                                        .withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.pets,
                                  size: 56,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Título
                            Text(
                              'PorkApp',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF5D4037),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),

                            Text(
                              'Criadero San Andrés',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF4CAF50),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),

                            Text(
                              'Bienvenido de nuevo',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF5D4037),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),

                            Text(
                              'Ingresa tus credenciales para continuar',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),

                            // Formulario
                            Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Email label
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Correo electrónico',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF5D4037),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Email field
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[800],
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'tu@email.com',
                                      hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                      ),
                                      prefixIcon: Icon(
                                        Icons.email_outlined,
                                        color: Colors.grey[400],
                                        size: 20,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: Colors.grey[300]!,
                                          width: 2,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: Colors.grey[300]!,
                                          width: 2,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF4CAF50),
                                          width: 2,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFFAFAFA),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 16,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor ingresa tu correo';
                                      }
                                      if (!value.contains('@')) {
                                        return 'Ingresa un correo válido';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),

                                  // Password label
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Contraseña',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF5D4037),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Password field
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[800],
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '••••••••',
                                      hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                      ),
                                      prefixIcon: Icon(
                                        Icons.lock_outline,
                                        color: Colors.grey[400],
                                        size: 20,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: Colors.grey[400],
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword =
                                                !_obscurePassword;
                                          });
                                        },
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: Colors.grey[300]!,
                                          width: 2,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: Colors.grey[300]!,
                                          width: 2,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF4CAF50),
                                          width: 2,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFFAFAFA),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 16,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor ingresa tu contraseña';
                                      }
                                      if (value.length < 6) {
                                        return 'La contraseña debe tener al menos 6 caracteres';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 28),

                                  // Login button
                                  SizedBox(
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed: _isLoading ? null : _onSubmit,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFEC407A),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: _isLoading
                                          ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Colors.white,
                                                ),
                                              ),
                                            )
                                          : Text(
                                              'Entrar',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Footer links
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.help_outline,
                                        size: 16,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '¿Necesitas ayuda?',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),

                                  // Footer note
                                  Container(
                                    padding: const EdgeInsets.only(top: 24),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: Colors.grey[200]!,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Gestión integral para tu criadero porcino',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[400],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          color: const Color(0xFFF5F5F5),
          child: Text(
            'Criadero San Andrés © 2025',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
