import 'package:freezed_annotation/freezed_annotation.dart';

part 'animal_event.freezed.dart';
part 'animal_event.g.dart';

@freezed
class AnimalEvent with _$AnimalEvent {
  const factory AnimalEvent({
    required String id,
    required String animalId,
    required DateTime date,
    required String type, // weighing, treatment, mortality
    required Map<String, dynamic> data,
    String? notes,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _AnimalEvent;

  factory AnimalEvent.fromJson(Map<String, dynamic> json) =>
      _$AnimalEventFromJson(json);
}

// Helpers para crear diferentes tipos de eventos
extension AnimalEventHelpers on AnimalEvent {
  static AnimalEvent createWeighing({
    required String animalId,
    required DateTime date,
    required double weight,
    String? notes,
  }) {
    return AnimalEvent(
      id: DateTime.now().millisecondsSinceEpoch
          .toString(), // Temporal, se reemplazará en el backend
      animalId: animalId,
      date: date,
      type: 'weighing',
      data: {'weight': weight},
      notes: notes,
      createdAt: DateTime.now(),
    );
  }

  static AnimalEvent createTreatment({
    required String animalId,
    required DateTime date,
    required String treatmentType, // vaccine, deworming, medication
    required String description,
    String? notes,
  }) {
    return AnimalEvent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      animalId: animalId,
      date: date,
      type: 'treatment',
      data: {'treatmentType': treatmentType, 'description': description},
      notes: notes,
      createdAt: DateTime.now(),
    );
  }

  static AnimalEvent createMortality({
    required String animalId,
    required DateTime date,
    required String cause,
    String? notes,
  }) {
    return AnimalEvent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      animalId: animalId,
      date: date,
      type: 'mortality',
      data: {'cause': cause},
      notes: notes,
      createdAt: DateTime.now(),
    );
  }
}
