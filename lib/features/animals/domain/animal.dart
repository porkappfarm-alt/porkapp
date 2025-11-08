/// Modelo de Animal - Convertido de freezed a clase plana
class Animal {
  final String id;
  final String batchId;
  final String identifier;
  final DateTime? birthDate;
  final String? sex;
  final double?
      weight; // Peso inicial - calculado automáticamente desde primera biometría
  final String breed;
  final DateTime? entryDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String gender;
  final String status;
  final String? notes;
  final double? targetWeight;
  final int? parityNumber;
  final int? serviceCount;

  const Animal({
    required this.id,
    required this.batchId,
    required this.identifier,
    this.birthDate,
    this.sex,
    this.weight,
    required this.breed,
    this.entryDate,
    this.createdAt,
    this.updatedAt,
    this.gender = 'unknown',
    this.status = 'active',
    this.notes,
    this.targetWeight,
    this.parityNumber,
    this.serviceCount,
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      id: json['id'] as String,
      batchId: json['batch_id'] as String,
      identifier: json['identifier'] as String,
      birthDate: json['birth_date'] != null
          ? DateTime.parse(json['birth_date'] as String)
          : null,
      sex: json['sex'] as String?,
      weight: (json['weight_at_entry'] as num?)?.toDouble(),
      breed: json['breed'] as String,
      entryDate: json['entry_date'] != null
          ? DateTime.parse(json['entry_date'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      gender: json['gender'] as String? ?? 'unknown',
      status: json['status'] as String? ?? 'active',
      notes: json['notes'] as String?,
      targetWeight: (json['target_weight'] as num?)?.toDouble(),
      parityNumber: json['parity_number'] as int?,
      serviceCount: json['service_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'batch_id': batchId,
      'identifier': identifier,
      'birth_date': birthDate?.toIso8601String(),
      'sex': sex,
      'weight_at_entry': weight,
      'breed': breed,
      'entry_date': entryDate?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'gender': gender,
      'status': status,
      'notes': notes,
      'target_weight': targetWeight,
      'parity_number': parityNumber,
      'service_count': serviceCount,
    };
  }

  Animal copyWith({
    String? id,
    String? batchId,
    String? identifier,
    DateTime? birthDate,
    String? sex,
    double? weight,
    String? breed,
    DateTime? entryDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? gender,
    String? status,
    String? notes,
    double? targetWeight,
    int? parityNumber,
    int? serviceCount,
  }) {
    return Animal(
      id: id ?? this.id,
      batchId: batchId ?? this.batchId,
      identifier: identifier ?? this.identifier,
      birthDate: birthDate ?? this.birthDate,
      sex: sex ?? this.sex,
      weight: weight ?? this.weight,
      breed: breed ?? this.breed,
      entryDate: entryDate ?? this.entryDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      gender: gender ?? this.gender,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      targetWeight: targetWeight ?? this.targetWeight,
      parityNumber: parityNumber ?? this.parityNumber,
      serviceCount: serviceCount ?? this.serviceCount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Animal && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
