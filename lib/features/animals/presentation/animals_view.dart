import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/features/animals/presentation/views/batch_animals_manager_view.dart';
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Animales - $batchName'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface.withOpacity(0.8),
      ),
      body: BatchAnimalsManagerView(batchId: batchId),
      bottomNavigationBar: const MainBottomNavigationBar(currentIndex: 2),
    );
  }
}
