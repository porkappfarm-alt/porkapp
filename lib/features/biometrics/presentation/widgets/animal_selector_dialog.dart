import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/help/biometric_help.dart';
import '../widgets/loading/biometric_loading_state.dart';
import '../utils/biometric_extensions.dart';

class AnimalSelectorDialog extends ConsumerWidget {
  final String batchId;

  const AnimalSelectorDialog({
    super.key,
    required this.batchId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BiometricLoadingState(
      isLoading: false, // TODO: Implementar estado de carga real
      loadingText: 'Cargando animales...',
      child: AlertDialog(
        title: BiometricHelp(
          title: 'Selección de Animal',
          content: 'Selecciona el animal al que deseas registrar el peso',
          child: const Text('Seleccionar Animal'),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Buscar animal...',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  // TODO: Implementar búsqueda
                },
              ).withSemantics(
                label: 'Buscar animal por número o identificador',
              ),
              const SizedBox(height: 8),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // TODO: Cargar lista de animales del lote
                    ListTile(
                      leading: const Icon(Icons.pets),
                      title: const Text('Animal de prueba'),
                      subtitle: const Text('Último peso: N/A'),
                      onTap: () {
                        Navigator.of(context).pop({
                          'id': 'test-animal-id',
                          'number': '001',
                        });
                      },
                    ).withSemantics(
                      label: 'Animal de prueba, número 001',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ).withSemantics(
            label: 'Cancelar selección',
          ),
        ],
      ),
    );
  }
}
