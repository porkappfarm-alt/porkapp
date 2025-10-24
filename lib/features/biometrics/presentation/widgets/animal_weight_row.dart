import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/biometric_form_provider.dart';

class AnimalWeightRow extends ConsumerWidget {
  final String animalId;
  final String identifier;
  final double? initialWeight;
  final TextEditingController controller;
  final bool isSaving;
  final VoidCallback? onSaved;

  const AnimalWeightRow({
    Key? key,
    required this.animalId,
    required this.identifier,
    this.initialWeight,
    required this.controller,
    required this.isSaving,
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(biometricFormStateProvider);
    final fieldState = formState[animalId];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#$identifier',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (initialWeight != null)
                  Text(
                    'Peso inicial: ${initialWeight?.toStringAsFixed(1)} kg',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 120,
            height: 48,
            decoration: BoxDecoration(
              color: fieldState?.isSaved == true
                  ? Colors.green.withOpacity(0.1)
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextFormField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              enabled: !isSaving && !(fieldState?.isSaved ?? false),
              decoration: InputDecoration(
                hintText: 'Peso',
                suffixText: 'kg',
                suffixIcon: fieldState?.isSaved == true
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onFieldSubmitted: (value) async {
                if (value.isEmpty) return;

                await ref
                    .read(biometricFormStateProvider.notifier)
                    .saveWeight(animalId, value);

                final currentState =
                    ref.read(biometricFormStateProvider)[animalId];
                if (currentState?.isSaved ?? false) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.white),
                            const SizedBox(width: 8),
                            Text('Peso guardado: ${currentState?.weight} kg'),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(8),
                      ),
                    );
                    onSaved?.call();
                  }
                } else if (currentState?.hasError ?? false) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            currentState?.errorMessage ?? 'Error desconocido'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(8),
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
