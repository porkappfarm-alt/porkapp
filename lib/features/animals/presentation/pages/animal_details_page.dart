import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/animals/domain/animal.dart';
import 'package:porkapp/features/animals/presentation/widgets/animal_form_dialog.dart';

class AnimalDetailsPage extends ConsumerWidget {
  final Animal animal;

  const AnimalDetailsPage({
    super.key,
    required this.animal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Animal #${animal.identifier}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => AnimalFormDialog(animal: animal),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta de información principal
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información General',
                      style: theme.textTheme.titleLarge,
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildInfoRow('Identificador:', animal.identifier),
                    _buildInfoRow('Tipo:', animal.type),
                    _buildInfoRow('Estado:', animal.status),
                    _buildInfoRow('Género:',
                        animal.gender == 'male' ? 'Macho' : 'Hembra'),
                    _buildInfoRow('Raza/Genética:', animal.breed),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tarjeta de datos específicos
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Datos Específicos',
                      style: theme.textTheme.titleLarge,
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildInfoRow('Peso inicial:',
                        animal.weight != null ? '${animal.weight} kg' : 'N/A'),
                    _buildInfoRow(
                      'Fecha de nacimiento:',
                      animal.birthDate != null
                          ? '${animal.birthDate!.day}/${animal.birthDate!.month}/${animal.birthDate!.year}'
                          : 'N/A',
                    ),
                    _buildInfoRow(
                      'Fecha de ingreso:',
                      animal.entryDate != null
                          ? '${animal.entryDate!.day}/${animal.entryDate!.month}/${animal.entryDate!.year}'
                          : 'N/A',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Notas (si existen)
            if (animal.notes != null && animal.notes!.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notas',
                        style: theme.textTheme.titleLarge,
                      ),
                      const Divider(),
                      const SizedBox(height: 8),
                      Text(animal.notes!),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
