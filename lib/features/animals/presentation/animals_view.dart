import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/animals/presentation/animal_details_view.dart';
import 'package:porkapp/features/animals/presentation/animals_controller.dart';
import 'package:porkapp/features/animals/presentation/create_animal_view.dart';
import 'package:porkapp/shared/widgets/main_bottom_navigation_bar.dart';

class AnimalsView extends ConsumerWidget {
  final String batchId;
  final String batchName;

  const AnimalsView({
    super.key,
    required this.batchId,
    required this.batchName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animalsState = ref.watch(animalsControllerProvider);
    final theme = Theme.of(context);

    // Load animals for this batch
    ref.read(animalsControllerProvider.notifier).loadAnimals(batchId);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Animales'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.background.withOpacity(0.8),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              batchName,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: animalsState.when(
              data: (animals) => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: animals.length,
                itemBuilder: (context, index) {
                  final animal = animals[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                AnimalDetailsView(animal: animal),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  _getAnimalEmoji(animal.status),
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '#${animal.identifier}',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${animal.breed} - ${animal.weight}kg',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateAnimalView(batchId: batchId),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Añadir Animal'),
        backgroundColor: theme.colorScheme.primary,
      ),
      bottomNavigationBar: const MainBottomNavigationBar(currentIndex: 2),
    );
  }

  String _getAnimalEmoji(String status) {
    switch (status) {
      case 'active':
        return '🐷';
      case 'sold':
        return '🏷️';
      case 'deceased':
        return '💀';
      case 'removed':
        return '📤';
      default:
        return '🐷';
    }
  }
}
