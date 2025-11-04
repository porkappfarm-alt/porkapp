// ignore_for_file: invalid_annotation_target
import 'package:porkapp/features/animals/domain/animal.dart';

class Batch {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime? entryDate;
  final DateTime? birthDate;
  final int headcountStart;
  final String? corralId;
  final double? initialAvgWeight;
  final String status;
  final String? notes;
  final String? imageUrl;
  final List<Animal> animals;

  const Batch({
    required this.id,
    required this.name,
    required this.createdAt,
    this.entryDate,
    this.birthDate,
    this.headcountStart = 0,
    this.corralId,
    this.initialAvgWeight,
    this.status = 'active',
    this.notes,
    this.imageUrl,
    this.animals = const [],
  });

  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      entryDate: json['entry_date'] != null
          ? DateTime.parse(json['entry_date'] as String)
          : null,
      birthDate: json['birth_date'] != null
          ? DateTime.parse(json['birth_date'] as String)
          : null,
      headcountStart: (json['headcount_start'] as num?)?.toInt() ?? 0,
      corralId: json['corral_id'] as String?,
      initialAvgWeight: (json['initial_avg_weight'] as num?)?.toDouble(),
      status: json['status'] as String? ?? 'active',
      notes: json['notes'] as String?,
      imageUrl: json['image_url'] as String?,
      animals: _animalsFromJson(json['animals'] as List<dynamic>?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'entry_date': entryDate?.toIso8601String(),
      'birth_date': birthDate?.toIso8601String(),
      'headcount_start': headcountStart,
      'corral_id': corralId,
      'initial_avg_weight': initialAvgWeight,
      'status': status,
      'notes': notes,
      'image_url': imageUrl,
      'animals': _animalsToJson(animals),
    };
  }

  static List<Animal> _animalsFromJson(List<dynamic>? json) {
    if (json == null) return [];
    return json
        .map((x) {
          try {
            return Animal.fromJson(x as Map<String, dynamic>);
          } catch (e) {
            print('Error al convertir animal: $e');
            return null;
          }
        })
        .whereType<Animal>()
        .toList();
  }

  static List<Map<String, dynamic>> _animalsToJson(List<Animal> animals) {
    // TODO: Implementar cuando Animal tenga toJson
    return [];
    // return animals.map((x) => x.toJson()).toList();
  }

  Batch copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? entryDate,
    DateTime? birthDate,
    int? headcountStart,
    String? corralId,
    double? initialAvgWeight,
    String? status,
    String? notes,
    String? imageUrl,
    List<Animal>? animals,
  }) {
    return Batch(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      entryDate: entryDate ?? this.entryDate,
      birthDate: birthDate ?? this.birthDate,
      headcountStart: headcountStart ?? this.headcountStart,
      corralId: corralId ?? this.corralId,
      initialAvgWeight: initialAvgWeight ?? this.initialAvgWeight,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
      animals: animals ?? this.animals,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Batch && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  /// Calcula los días de vida del lote desde la fecha de nacimiento
  int get daysOld {
    if (birthDate == null) return 0;
    return DateTime.now().difference(birthDate!).inDays;
  }

  /// Calcula las semanas de vida del lote
  double get weeksOld {
    return daysOld / 7.0;
  }

  /// Retorna una descripción legible de la edad del lote
  String get ageDescription {
    if (birthDate == null) return 'Sin fecha de nacimiento';
    if (daysOld == 0) return 'Hoy';
    if (daysOld == 1) return '1 día';
    if (daysOld < 7) return '$daysOld días';
    final weeks = weeksOld.floor();
    if (weeks == 1) return '1 semana';
    return '$weeks semanas ($daysOld días)';
  }
}
