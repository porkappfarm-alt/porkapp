import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:porkapp/features/animals/domain/animal_event.dart';
import 'package:porkapp/features/animals/presentation/dialogs/add_event_dialog.dart';
import 'package:porkapp/features/animals/presentation/views/animal_events_view.dart';
import 'package:porkapp/features/animals/presentation/create_animal_view.dart';
import 'package:porkapp/features/animals/providers/animal_events_provider.dart';
import 'package:porkapp/features/animals/providers/animal_provider.dart';

class AnimalDetailsView extends ConsumerWidget {
  final String animalId;

  const AnimalDetailsView({super.key, required this.animalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('yyyy-MM-dd');
    final animalAsync = ref.watch(animalProvider(animalId));

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Detalles del Animal'),
        centerTitle: true,
      ),
      body: animalAsync.when(
        data: (animal) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Detalles del animal #${animal.identifier}',
                  style: theme.textTheme.headlineMedium,
                ),
              ),
              Consumer(
                builder: (context, ref, _) {
                  final eventsAsync = ref.watch(animalEventsProvider(animalId));
                  
                  return eventsAsync.when(
                    data: (events) => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return ListTile(
                          title: Text(event.type),
                          subtitle: Text(dateFormat.format(event.date)),
                        );
                      },
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(child: Text('Error: $err')),
                  );
                },
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}