import 'package:flutter/material.dart';
import '../widgets/feedback/biometric_feedback.dart';

extension BiometricErrorHandling on BuildContext {
  void showBiometricError(String message, {VoidCallback? onRetry}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: BiometricFeedback(
          message: message,
          type: BiometricFeedbackType.error,
          onAction: onRetry,
          actionLabel: onRetry != null ? 'Reintentar' : null,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  void showBiometricSuccess(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: BiometricFeedback(
          message: message,
          type: BiometricFeedbackType.success,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  void showBiometricWarning(String message,
      {VoidCallback? onAction, String? actionLabel}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: BiometricFeedback(
          message: message,
          type: BiometricFeedbackType.warning,
          onAction: onAction,
          actionLabel: actionLabel,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}

extension BiometricErrorMessages on Exception {
  String getErrorMessage() {
    // Personalizar mensajes de error según el tipo
    if (this is FormatException) {
      return 'El formato de los datos no es válido';
    } else if (this is TimeoutException) {
      return 'La operación tardó demasiado tiempo. Por favor, inténtalo de nuevo';
    } else if (this is NetworkException) {
      return 'Error de conexión. Verifica tu conexión a internet';
    } else {
      return 'Ha ocurrido un error inesperado';
    }
  }
}

class TimeoutException implements Exception {}

class NetworkException implements Exception {}

extension BiometricAccessibility on Widget {
  Widget withSemantics({
    String? label,
    String? hint,
    bool? enabled,
    bool? checked,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      enabled: enabled,
      checked: checked,
      child: this,
    );
  }

  Widget withTooltip(String message) {
    return Tooltip(
      message: message,
      child: this,
    );
  }

  Widget withLoadingState({
    required bool isLoading,
    String? loadingText,
  }) {
    return IgnorePointer(
      ignoring: isLoading,
      child: Opacity(
        opacity: isLoading ? 0.5 : 1.0,
        child: this,
      ),
    );
  }
}
