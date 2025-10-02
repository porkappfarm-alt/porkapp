import 'package:freezed_annotation/freezed_annotation.dart';

part 'animal_filters.freezed.dart';
part 'animal_filters.g.dart';

@JsonSerializable(explicitToJson: true)
class AnimalTypeConverter implements JsonConverter<AnimalType, String> {
  const AnimalTypeConverter();

  @override
  AnimalType fromJson(String json) {
    switch (json) {
      case 'piglet':
        return const AnimalType.piglet();
      case 'sow':
        return const AnimalType.sow();
      case 'boar':
        return const AnimalType.boar();
      case 'fattening':
        return const AnimalType.fattening();
      default:
        throw Exception('Unknown AnimalType: $json');
    }
  }

  @override
  String toJson(AnimalType type) => type.when(
    piglet: () => 'piglet',
    sow: () => 'sow',
    boar: () => 'boar',
    fattening: () => 'fattening',
  );
}

@JsonSerializable(explicitToJson: true)
class AnimalStatusConverter implements JsonConverter<AnimalStatus, String> {
  const AnimalStatusConverter();

  @override
  AnimalStatus fromJson(String json) {
    switch (json) {
      case 'active':
        return const AnimalStatus.active();
      case 'sold':
        return const AnimalStatus.sold();
      case 'dead':
        return const AnimalStatus.dead();
      case 'transferred':
        return const AnimalStatus.transferred();
      default:
        throw Exception('Unknown AnimalStatus: $json');
    }
  }

  @override
  String toJson(AnimalStatus status) => status.when(
    active: () => 'active',
    sold: () => 'sold',
    dead: () => 'dead',
    transferred: () => 'transferred',
  );
}

@JsonSerializable(explicitToJson: true)
class AnimalEventTypeConverter
    implements JsonConverter<AnimalEventType, String> {
  const AnimalEventTypeConverter();

  @override
  AnimalEventType fromJson(String json) {
    switch (json) {
      case 'weighing':
        return const AnimalEventType.weighing();
      case 'treatment':
        return const AnimalEventType.treatment();
      case 'death':
        return const AnimalEventType.death();
      case 'sale':
        return const AnimalEventType.sale();
      case 'transfer':
        return const AnimalEventType.transfer();
      case 'vaccination':
        return const AnimalEventType.vaccination();
      default:
        throw Exception('Unknown AnimalEventType: $json');
    }
  }

  @override
  String toJson(AnimalEventType type) => type.when(
    weighing: () => 'weighing',
    treatment: () => 'treatment',
    death: () => 'death',
    sale: () => 'sale',
    transfer: () => 'transfer',
    vaccination: () => 'vaccination',
  );
}

@freezed
class AnimalFilters with _$AnimalFilters {
  const factory AnimalFilters({
    // Tipo de animal
    @AnimalTypeConverter() AnimalType? type,

    // Estado del animal
    @AnimalStatusConverter() AnimalStatus? status,

    // Rango de fechas
    DateTime? dateFrom,
    DateTime? dateTo,

    // Filtros adicionales
    String? batchId,
    String? corralId,
    double? minWeight,
    double? maxWeight,
    bool? isMale,
    String? searchQuery,
  }) = _AnimalFilters;

  factory AnimalFilters.fromJson(Map<String, dynamic> json) =>
      _$AnimalFiltersFromJson(json);
}

/// Tipo/categoría del animal
@freezed
sealed class AnimalType with _$AnimalType {
  const factory AnimalType.piglet() = AnimalTypePiglet; // Lechón
  const factory AnimalType.sow() = AnimalTypeSow; // Reproductora
  const factory AnimalType.boar() = AnimalTypeBoar; // Padrillo
  const factory AnimalType.fattening() = AnimalTypeFattening; // Engorde
}

/// Estado del animal
@freezed
sealed class AnimalStatus with _$AnimalStatus {
  const factory AnimalStatus.active() = AnimalStatusActive; // Activo
  const factory AnimalStatus.sold() = AnimalStatusSold; // Vendido
  const factory AnimalStatus.dead() = AnimalStatusDead; // Muerto
  const factory AnimalStatus.transferred() =
      AnimalStatusTransferred; // Transferido
}

/// Tipo de evento relacionado al animal
@freezed
sealed class AnimalEventType with _$AnimalEventType {
  const factory AnimalEventType.weighing() = AnimalEventTypeWeighing; // Pesaje
  const factory AnimalEventType.treatment() =
      AnimalEventTypeTreatment; // Tratamiento
  const factory AnimalEventType.death() = AnimalEventTypeDeath; // Baja/Muerte
  const factory AnimalEventType.sale() = AnimalEventTypeSale; // Venta
  const factory AnimalEventType.transfer() =
      AnimalEventTypeTransfer; // Transferencia
  const factory AnimalEventType.vaccination() =
      AnimalEventTypeVaccination; // Vacunación
}
