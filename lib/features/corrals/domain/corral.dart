import 'package:freezed_annotation/freezed_annotation.dart';

part 'corral.freezed.dart';
part 'corral.g.dart';

@JsonEnum(fieldRename: FieldRename.none)
enum CorralStatus {
  @JsonValue('disponible')
  disponible,
  @JsonValue('ocupado')
  ocupado,
  @JsonValue('mantenimiento')
  mantenimiento
}

@freezed
class Corral with _$Corral {
  const factory Corral({
    required String id,
    required String name,
    String? location,
    int? capacity,
    String? notes,
    String? imageUrl,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'created_by') required String createdBy,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'active_batch_count') @Default(0) int activeBatchCount,
    @Default(CorralStatus.disponible) CorralStatus status,
  }) = _Corral;

  factory Corral.fromJson(Map<String, dynamic> json) => _$CorralFromJson(json);
}
