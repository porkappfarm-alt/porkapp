import 'package:flutter/material.dart';

class BiometricLoadingState extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? loadingText;
  final Widget? errorWidget;

  const BiometricLoadingState({
    super.key,
    required this.isLoading,
    required this.child,
    this.loadingText,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Contenido principal
        child,

        // Overlay de carga
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      if (loadingText != null) ...[
                        const SizedBox(height: 16.0),
                        Text(
                          loadingText!,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),

        // Widget de error si existe
        if (errorWidget != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: errorWidget!,
          ),
      ],
    );
  }
}
