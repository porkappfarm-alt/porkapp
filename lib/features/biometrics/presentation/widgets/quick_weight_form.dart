import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuickWeightForm extends ConsumerStatefulWidget {
  final String? batchId;

  const QuickWeightForm({
    super.key,
    this.batchId,
  });

  @override
  ConsumerState<QuickWeightForm> createState() => _QuickWeightFormState();
}

class _QuickWeightFormState extends ConsumerState<QuickWeightForm> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // TODO: Implementar campos del formulario
          TextFormField(
            controller: _weightController,
            decoration: const InputDecoration(
              labelText: 'Peso (kg)',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese un peso';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // TODO: Implementar guardado
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
