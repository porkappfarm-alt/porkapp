import 'package:freezed_annotation/freezed_annotation.dart';

part 'corral.freezed.dart';
part 'corral.g.dart';

@freezed
class Corral with _$Corral {
  factory Corral({
    required String id,
    required String name,
    String? location,
    int? capacity,
    String? notes,
    String? imageUrl,
    required DateTime createdAt,
    required String createdBy,
    required DateTime updatedAt,
    @Default(0) int activeBatchCount,
  }) = _Corral;

  factory Corral.fromJson(Map<String, dynamic> json) => _$CorralFromJson({
    ...json,
    'createdAt': json['created_at'],
    'createdBy': json['created_by'],
    'updatedAt': json['updated_at'],
  });
}
