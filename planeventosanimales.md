# 🧠 Plan de Implementación — Eventos por Animal en PorkApp

## 🎯 Objetivo general
Permitir que dentro del **detalle de cada animal**, el usuario pueda:
- Ver los eventos asociados (alimentación, vacunación, control, etc.).
- Agregar, editar y eliminar eventos.
- Mantener la sincronización en tiempo real con Supabase.

---

## ⚙️ Arquitectura base
Se debe mantener la organización modular actual:
```
lib/
 └── features/
      └── animals/
           ├── domain/
           │    └── animal_event.dart
           ├── data/
           │    └── animal_events_repository.dart
           ├── application/
           │    └── animal_events_provider.dart
           └── presentation/
                ├── dialogs/
                │    └── add_event_dialog.dart
                └── views/
                     └── animal_details_view.dart
```

---

## 🧩 Fase 1 — Validar modelo y tabla en Supabase

### Acción:
Verificar que la tabla `animal_events` existe y contiene las siguientes columnas:
| Campo | Tipo | Descripción |
|--------|------|--------------|
| id | uuid (PK) | Identificador del evento |
| animal_id | uuid (FK) | Relación con la tabla `animals` |
| type | text | Tipo de evento (vacunación, control, etc.) |
| description | text | Descripción del evento |
| date | timestamp | Fecha del evento |
| created_at | timestamp | Fecha de registro |

### En el código:
Archivo `lib/features/animals/domain/animal_event.dart`:
```dart
class AnimalEvent {
  final String id;
  final String animalId;
  final String type;
  final String description;
  final DateTime date;

  const AnimalEvent({
    required this.id,
    required this.animalId,
    required this.type,
    required this.description,
    required this.date,
  });

  factory AnimalEvent.fromJson(Map<String, dynamic> json) => AnimalEvent(
        id: json['id'] as String,
        animalId: json['animal_id'] as String,
        type: json['type'] as String,
        description: json['description'] as String,
        date: DateTime.parse(json['date']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'animal_id': animalId,
        'type': type,
        'description': description,
        'date': date.toIso8601String(),
      };
}
```

---

## 🧩 Fase 2 — Repositorio de datos

Archivo: `animal_events_repository.dart`
```dart
class AnimalEventsRepository {
  final SupabaseClient supabase;

  AnimalEventsRepository(this.supabase);

  Future<List<AnimalEvent>> getEventsByAnimal(String animalId) async {
    final response = await supabase
        .from('animal_events')
        .select()
        .eq('animal_id', animalId)
        .order('date', ascending: false);

    return (response as List)
        .map((item) => AnimalEvent.fromJson(item))
        .toList();
  }

  Future<void> addEvent(AnimalEvent event) async {
    await supabase.from('animal_events').insert(event.toJson());
  }

  Future<void> updateEvent(AnimalEvent event) async {
    await supabase
        .from('animal_events')
        .update(event.toJson())
        .eq('id', event.id);
  }

  Future<void> deleteEvent(String eventId) async {
    await supabase.from('animal_events').delete().eq('id', eventId);
  }
}
```

---

## 🧩 Fase 3 — Provider de eventos

Archivo: `animal_events_provider.dart`
```dart
final animalEventsRepositoryProvider =
    Provider<AnimalEventsRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return AnimalEventsRepository(supabase);
});

final animalEventsProvider =
    FutureProvider.family<List<AnimalEvent>, String>((ref, animalId) async {
  final repo = ref.watch(animalEventsRepositoryProvider);
  return repo.getEventsByAnimal(animalId);
});
```

---

## 🧩 Fase 4 — Mostrar eventos en la UI

Archivo: `animal_details_view.dart`
```dart
final eventsAsync = ref.watch(animalEventsProvider(animal.id));

Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const SizedBox(height: 16),
    Text('Eventos', style: Theme.of(context).textTheme.titleMedium),
    const SizedBox(height: 8),
    eventsAsync.when(
      data: (events) => events.isEmpty
          ? Text('No hay eventos registrados.')
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: const Icon(Icons.event_note),
                    title: Text(event.type),
                    subtitle: Text(event.description),
                    trailing: Text(
                      DateFormat('dd/MM/yyyy').format(event.date),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                );
              },
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Error al cargar eventos: $e'),
    ),
  ],
);
```

---

## 🧩 Fase 5 — Diálogo para agregar o editar eventos

Archivo: `add_event_dialog.dart`
```dart
class AddEventDialog extends StatefulWidget {
  final String animalId;

  const AddEventDialog({super.key, required this.animalId});

  @override
  State<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  final _formKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  final _descController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuevo Evento'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(controller: _typeController, decoration: const InputDecoration(labelText: 'Tipo de evento')),
            TextFormField(controller: _descController, decoration: const InputDecoration(labelText: 'Descripción')),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
              icon: const Icon(Icons.calendar_today),
              label: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final repo = context.read(animalEventsRepositoryProvider);
              final newEvent = AnimalEvent(
                id: const Uuid().v4(),
                animalId: widget.animalId,
                type: _typeController.text,
                description: _descController.text,
                date: _selectedDate,
              );
              await repo.addEvent(newEvent);
              Navigator.pop(context);
              context.refresh(animalEventsProvider(widget.animalId));
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
```

---

## 🧩 Fase 6 — Sincronización y actualización
Agregar en `animal_details_view.dart`:
```dart
FloatingActionButton.extended(
  onPressed: () async {
    await showDialog(
      context: context,
      builder: (_) => AddEventDialog(animalId: animal.id),
    );
    ref.refresh(animalEventsProvider(animal.id));
  },
  label: const Text('Agregar Evento'),
  icon: const Icon(Icons.add),
);
```

---

## 🧩 Fase 7 — Optimización y validaciones
- Validar campos antes de guardar eventos.
- Permitir edición o eliminación mediante menú contextual o swipe.
- Asignar íconos o colores según tipo de evento.

---

## 📋 Flujo final
1. Usuario entra al detalle del lote.  
2. Selecciona un animal.  
3. Visualiza los eventos asociados.  
4. Puede **agregar**, **editar** o **eliminar** eventos.  
5. Cambios sincronizados con Supabase.
