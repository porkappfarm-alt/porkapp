import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/simple_biometric_provider.dart';

class BiometricFilters extends ConsumerWidget {
  const BiometricFilters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchFilter = ref.watch(biometricSearchFilterProvider);
    final dateFilter = ref.watch(biometricDateFilterProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Buscar por lote',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      ref.read(biometricSearchFilterProvider.notifier).state =
                          value;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: dateFilter ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      ref.read(biometricDateFilterProvider.notifier).state =
                          date;
                    }
                  },
                ),
                if (dateFilter != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      ref.read(biometricDateFilterProvider.notifier).state =
                          null;
                    },
                  ),
              ],
            ),
            if (dateFilter != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Chip(
                  label: Text(
                    'Fecha: ${dateFilter.day}/${dateFilter.month}/${dateFilter.year}',
                  ),
                  onDeleted: () {
                    ref.read(biometricDateFilterProvider.notifier).state = null;
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
