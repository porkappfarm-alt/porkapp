/// Tipo/categoría del animal
enum AnimalType {
  piglet, // Lechón
  sow, // Reproductora
  boar, // Padrillo
  fattening; // Engorde

  String toJson() {
    switch (this) {
      case AnimalType.piglet:
        return 'piglet';
      case AnimalType.sow:
        return 'sow';
      case AnimalType.boar:
        return 'boar';
      case AnimalType.fattening:
        return 'fattening';
    }
  }

  static AnimalType fromJson(String json) {
    switch (json) {
      case 'piglet':
        return AnimalType.piglet;
      case 'sow':
        return AnimalType.sow;
      case 'boar':
        return AnimalType.boar;
      case 'fattening':
        return AnimalType.fattening;
      default:
        throw Exception('Unknown AnimalType: $json');
    }
  }
}

/// Estado del animal
enum AnimalStatus {
  active, // Activo
  sold, // Vendido
  dead, // Muerto
  transferred; // Transferido

  String toJson() {
    switch (this) {
      case AnimalStatus.active:
        return 'active';
      case AnimalStatus.sold:
        return 'sold';
      case AnimalStatus.dead:
        return 'dead';
      case AnimalStatus.transferred:
        return 'transferred';
    }
  }

  static AnimalStatus fromJson(String json) {
    switch (json) {
      case 'active':
        return AnimalStatus.active;
      case 'sold':
        return AnimalStatus.sold;
      case 'dead':
        return AnimalStatus.dead;
      case 'transferred':
        return AnimalStatus.transferred;
      default:
        throw Exception('Unknown AnimalStatus: $json');
    }
  }
}

/// Tipo de evento relacionado al animal
enum AnimalEventType {
  weighing, // Pesaje
  treatment, // Tratamiento
  death, // Baja/Muerte
  sale, // Venta
  transfer, // Transferencia
  vaccination; // Vacunación

  String toJson() {
    switch (this) {
      case AnimalEventType.weighing:
        return 'weighing';
      case AnimalEventType.treatment:
        return 'treatment';
      case AnimalEventType.death:
        return 'death';
      case AnimalEventType.sale:
        return 'sale';
      case AnimalEventType.transfer:
        return 'transfer';
      case AnimalEventType.vaccination:
        return 'vaccination';
    }
  }

  static AnimalEventType fromJson(String json) {
    switch (json) {
      case 'weighing':
        return AnimalEventType.weighing;
      case 'treatment':
        return AnimalEventType.treatment;
      case 'death':
        return AnimalEventType.death;
      case 'sale':
        return AnimalEventType.sale;
      case 'transfer':
        return AnimalEventType.transfer;
      case 'vaccination':
        return AnimalEventType.vaccination;
      default:
        throw Exception('Unknown AnimalEventType: $json');
    }
  }
}

/// Modelo de AnimalFilters - Convertido de freezed a clase plana
class AnimalFilters {
  final AnimalType? type;
  final AnimalStatus? status;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? batchId;
  final String? corralId;
  final double? minWeight;
  final double? maxWeight;
  final bool? isMale;
  final String? searchQuery;

  const AnimalFilters({
    this.type,
    this.status,
    this.dateFrom,
    this.dateTo,
    this.batchId,
    this.corralId,
    this.minWeight,
    this.maxWeight,
    this.isMale,
    this.searchQuery,
  });

  factory AnimalFilters.fromJson(Map<String, dynamic> json) {
    return AnimalFilters(
      type: json['type'] != null
          ? AnimalType.fromJson(json['type'] as String)
          : null,
      status: json['status'] != null
          ? AnimalStatus.fromJson(json['status'] as String)
          : null,
      dateFrom: json['date_from'] != null
          ? DateTime.parse(json['date_from'] as String)
          : null,
      dateTo: json['date_to'] != null
          ? DateTime.parse(json['date_to'] as String)
          : null,
      batchId: json['batch_id'] as String?,
      corralId: json['corral_id'] as String?,
      minWeight: (json['min_weight'] as num?)?.toDouble(),
      maxWeight: (json['max_weight'] as num?)?.toDouble(),
      isMale: json['is_male'] as bool?,
      searchQuery: json['search_query'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type?.toJson(),
      'status': status?.toJson(),
      'date_from': dateFrom?.toIso8601String(),
      'date_to': dateTo?.toIso8601String(),
      'batch_id': batchId,
      'corral_id': corralId,
      'min_weight': minWeight,
      'max_weight': maxWeight,
      'is_male': isMale,
      'search_query': searchQuery,
    };
  }

  AnimalFilters copyWith({
    AnimalType? type,
    AnimalStatus? status,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? batchId,
    String? corralId,
    double? minWeight,
    double? maxWeight,
    bool? isMale,
    String? searchQuery,
  }) {
    return AnimalFilters(
      type: type ?? this.type,
      status: status ?? this.status,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      batchId: batchId ?? this.batchId,
      corralId: corralId ?? this.corralId,
      minWeight: minWeight ?? this.minWeight,
      maxWeight: maxWeight ?? this.maxWeight,
      isMale: isMale ?? this.isMale,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
