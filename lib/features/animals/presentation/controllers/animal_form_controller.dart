import 'package:flutter/material.dart';
import 'package:porkapp/features/animals/domain/animal.dart';

class AnimalFormController {
  // Estado del formulario
  bool _isDirty = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  bool get isDirty => _isDirty;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Valores originales para comparar cambios
  final Map<String, dynamic> _originalValues = {};
  final Map<String, dynamic> _currentValues = {};

  void initForm(Animal? animal) {
    if (animal != null) {
      _originalValues.addAll({
        'identifier': animal.identifier,
        'type': animal.type,
        'weight': animal.weight,
        'breed': animal.breed,
        'status': animal.status,
        'birth_date': animal.birthDate,
        'notes': animal.notes,
      });
      _currentValues.addAll(_originalValues);
    }
    _isDirty = false;
    _errorMessage = null;
  }

  void updateField(String field, dynamic value) {
    _currentValues[field] = value;
    _checkDirty();
  }

  void _checkDirty() {
    bool isDirty = false;
    _originalValues.forEach((key, value) {
      if (_currentValues[key] != value) {
        isDirty = true;
      }
    });
    _isDirty = isDirty;
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    _errorMessage = null;
  }

  void setError(String message) {
    _errorMessage = message;
    _isLoading = false;
  }

  Future<bool> shouldPop(BuildContext context) async {
    if (!_isDirty) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Descartar cambios?'),
        content: const Text('Los cambios no guardados se perderán.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Descartar'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  void dispose() {
    _originalValues.clear();
    _currentValues.clear();
    _isDirty = false;
    _isLoading = false;
    _errorMessage = null;
  }
}
