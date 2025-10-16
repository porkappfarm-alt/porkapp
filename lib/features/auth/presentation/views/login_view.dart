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
    final horizontalPadding = size.width > 600
        ? (size.width - 600) / 2
        : AppSpacing.md;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.beigeLight,
              AppColors.pigPink.withOpacity(0.6),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: FadeTransition(
                  opacity: _fadeInAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Card(
                      elevation: 4,
                      shadowColor: AppColors.burgundy.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                      ),
                      color: AppColors.surfacePrimary,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                              // Logo
                              Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.pigPink,
                                      AppColors.pigPink.withOpacity(0.7),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: AppElevation.md,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.pets,
                                    size: 80,
                                    color: AppColors.coral,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xl),

                              // Título
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    AppColors.burgundy,
                                    AppColors.coral,
                                  ],
                                ).createShader(bounds),
                                child: Text(
                                  'Bienvenido',
                                  style: AppTextStyles.h1,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),

                              Text(
                                'Ingresa tus credenciales para continuar',
                                style: AppTextStyles.body1.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            const SizedBox(height: AppSpacing.xl),

                            // Formulario
                            Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Email field with enhanced design
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(AppRadius.md),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.borderLight.withOpacity(0.5),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      style: AppTextStyles.body1,
                                      decoration: InputDecoration(
                                        labelText: 'Correo electrónico',
                                        labelStyle: AppTextStyles.body2.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                        hintText: 'ejemplo@correo.com',
                                        hintStyle: AppTextStyles.body2.copyWith(
                                          color: AppColors.textDisabled,
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.email_outlined,
                                          color: AppColors.coral,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(AppRadius.md),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        fillColor: AppColors.white,
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: AppSpacing.md,
                                          vertical: AppSpacing.md,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(AppRadius.md),
                                          borderSide: const BorderSide(
                                            color: AppColors.coral,
                                            width: 2,
                                          ),
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
                                  ),
                                  const SizedBox(height: AppSpacing.md),

                                  // Password field with enhanced design
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(AppRadius.md),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.borderLight.withOpacity(0.5),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: _passwordController,
                                      obscureText: _obscurePassword,
                                      style: AppTextStyles.body1,
                                      decoration: InputDecoration(
                                        labelText: 'Contraseña',
                                        labelStyle: AppTextStyles.body2.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                        hintText: '••••••',
                                        hintStyle: AppTextStyles.body2.copyWith(
                                          color: AppColors.textDisabled,
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.lock_outline,
                                          color: AppColors.coral,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: AppColors.textSecondary,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscurePassword = !_obscurePassword;
                                            });
                                          },
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(AppRadius.md),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        fillColor: AppColors.white,
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: AppSpacing.md,
                                          vertical: AppSpacing.md,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(AppRadius.md),
                                          borderSide: const BorderSide(
                                            color: AppColors.coral,
                                            width: 2,
                                          ),
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
                                  ),
                                  
                                  // Remember password option
                                  Padding(
                                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                                    child: Row(
                                      children: [
                                        Transform.scale(
                                          scale: 0.8,
                                          child: Checkbox(
                                            value: false,
                                            onChanged: (_) {},
                                            activeColor: AppColors.coral,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Recordar contraseña',
                                          style: AppTextStyles.caption,
                                        ),
                                        const Spacer(),
                                        TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            '¿Olvidaste tu contraseña?',
                                            style: AppTextStyles.caption.copyWith(
                                              color: AppColors.coral,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  const SizedBox(height: AppSpacing.lg),

                                  // Enhanced login button with gradient
                                  SizedBox(
                                    height: 52,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: AppGradients.primaryButton,
                                        borderRadius: BorderRadius.circular(AppRadius.md),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.coral.withOpacity(0.3),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                        transform: Matrix4.identity()
                                          ..scale(_isLoading ? 0.95 : 1.0),
                                        child: ElevatedButton(
                                          onPressed: _isLoading ? null : _onSubmit,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            foregroundColor: AppColors.white,
                                            shadowColor: Colors.transparent,
                                            elevation: 0,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: AppSpacing.lg,
                                              vertical: AppSpacing.md,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(AppRadius.md),
                                            ),
                                          ),
                                          child: AnimatedSwitcher(
                                            duration: const Duration(milliseconds: 200),
                                            child: _isLoading
                                                ? const SizedBox(
                                                    width: 24,
                                                    height: 24,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor: AlwaysStoppedAnimation<Color>(
                                                        AppColors.white,
                                                      ),
                                                    ),
                                                  )
                                                : Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        'INICIAR SESIÓN',
                                                        style: AppTextStyles.button,
                                                      ),
                                                      const SizedBox(width: AppSpacing.sm),
                                                      const Icon(
                                                        Icons.arrow_forward,
                                                        size: 18,
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  // Register option
                                  Padding(
                                    padding: const EdgeInsets.only(top: AppSpacing.lg),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '¿No tienes una cuenta?',
                                          style: AppTextStyles.caption,
                                        ),
                                        TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            'Regístrate',
                                            style: AppTextStyles.caption.copyWith(
                                              color: AppColors.coral,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
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
      ),
    );
  }
}
