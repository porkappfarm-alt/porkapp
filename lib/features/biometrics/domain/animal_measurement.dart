import '../data/local/biometric_local_models.dart';

/// Modelo de AnimalMeasurement - Convertido de freezed a clase plana
class AnimalMeasurement {
  final String id;
  final String batchMeasurementId;
  final String animalId;
  final double weight;
  final double? previousWeight;
  final double? weightGain;
  final int? daysSinceLast;
  final double? adg;
  final String? notes;
  final DateTime createdAt;

  const AnimalMeasurement({
    required this.id,
    required this.batchMeasurementId,
    required this.animalId,
    required this.weight,
    this.previousWeight,
    this.weightGain,
    this.daysSinceLast,
    this.adg,
    this.notes,
    required this.createdAt,
  });

  factory AnimalMeasurement.fromJson(Map<String, dynamic> json) {
    return AnimalMeasurement(
      id: json['id'] as String,
      batchMeasurementId: json['batch_measurement_id'] as String,
      animalId: json['animal_id'] as String,
      weight: (json['weight'] as num).toDouble(),
      previousWeight: (json['previous_weight'] as num?)?.toDouble(),
      weightGain: (json['weight_gain'] as num?)?.toDouble(),
      daysSinceLast: json['days_since_last'] as int?,
      adg: (json['adg'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'batch_measurement_id': batchMeasurementId,
      'animal_id': animalId,
      'weight': weight,
      'previous_weight': previousWeight,
      'weight_gain': weightGain,
      'days_since_last': daysSinceLast,
      'adg': adg,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  AnimalMeasurement copyWith({
    String? id,
    String? batchMeasurementId,
    String? animalId,
    double? weight,
    double? previousWeight,
    double? weightGain,
    int? daysSinceLast,
    double? adg,
    String? notes,
    DateTime? createdAt,
  }) {
    return AnimalMeasurement(
      id: id ?? this.id,
      batchMeasurementId: batchMeasurementId ?? this.batchMeasurementId,
      animalId: animalId ?? this.animalId,
      weight: weight ?? this.weight,
      previousWeight: previousWeight ?? this.previousWeight,
      weightGain: weightGain ?? this.weightGain,
      daysSinceLast: daysSinceLast ?? this.daysSinceLast,
      adg: adg ?? this.adg,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnimalMeasurement && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

extension AnimalMeasurementLocalExtension on AnimalMeasurement {
  LocalAnimalMeasurement toLocal() {
    final local = LocalAnimalMeasurement()
      ..remoteId = id
      ..animalId = animalId
      ..weight = weight
      ..previousWeight = previousWeight
      ..weightGain = weightGain
      ..daysSinceLast = daysSinceLast
      ..adg = adg
      ..notes = notes
      ..createdAt = createdAt
      ..syncStatus = SyncStatus.pending;
    return local;
  }
}
