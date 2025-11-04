import 'package:porkapp/features/batches/domain/batch.dart';

enum CorralStatus { disponible, ocupado, mantenimiento }

class Corral {
  final String id;
  final String name;
  final String? location;
  final int? capacity;
  final String? notes;
  final String? imageUrl;
  final DateTime createdAt;
  final String createdBy;
  final DateTime updatedAt;
  final int activeBatchCount;
  final CorralStatus status;
  final String? activeBatchName;
  final DateTime? activeBatchEntryDate;
  final double? lastBiometryAvgWeight;
  final List<Batch>? batches;
  final String? activeBatchId;

  const Corral({
    required this.id,
    required this.name,
    this.location,
    this.capacity,
    this.notes,
    this.imageUrl,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    this.activeBatchCount = 0,
    this.status = CorralStatus.disponible,
    this.activeBatchName,
    this.activeBatchEntryDate,
    this.lastBiometryAvgWeight,
    this.batches,
    this.activeBatchId,
  });

  factory Corral.fromJson(Map<String, dynamic> json) {
    return Corral(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String?,
      capacity: json['capacity'] as int?,
      notes: json['notes'] as String?,
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      createdBy: json['created_by'] as String,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      activeBatchCount: (json['active_batch_count'] as num?)?.toInt() ?? 0,
      status: _statusFromString(json['status'] as String?),
      activeBatchName: json['active_batch_name'] as String?,
      activeBatchEntryDate: json['active_batch_entry_date'] != null
          ? DateTime.parse(json['active_batch_entry_date'] as String)
          : null,
      lastBiometryAvgWeight:
          (json['last_biometry_avg_weight'] as num?)?.toDouble(),
      batches: _batchesFromJson(json['batches'] as List<dynamic>?),
      activeBatchId: json['active_batch_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'capacity': capacity,
      'notes': notes,
      'imageUrl': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'created_by': createdBy,
      'updated_at': updatedAt.toIso8601String(),
      'active_batch_count': activeBatchCount,
      'status': _statusToString(status),
      'active_batch_name': activeBatchName,
      'active_batch_entry_date': activeBatchEntryDate?.toIso8601String(),
      'last_biometry_avg_weight': lastBiometryAvgWeight,
      'batches': _batchesToJson(batches),
      'active_batch_id': activeBatchId,
    };
  }

  static CorralStatus _statusFromString(String? status) {
    switch (status) {
      case 'disponible':
        return CorralStatus.disponible;
      case 'ocupado':
        return CorralStatus.ocupado;
      case 'mantenimiento':
        return CorralStatus.mantenimiento;
      default:
        return CorralStatus.disponible;
    }
  }

  static String _statusToString(CorralStatus status) {
    switch (status) {
      case CorralStatus.disponible:
        return 'disponible';
      case CorralStatus.ocupado:
        return 'ocupado';
      case CorralStatus.mantenimiento:
        return 'mantenimiento';
    }
  }

  static List<Batch> _batchesFromJson(List<dynamic>? json) {
    if (json == null) return [];
    return json
        .map((x) {
          try {
            return Batch.fromJson(x as Map<String, dynamic>);
          } catch (e) {
            print('Error al convertir batch: $e');
            return null;
          }
        })
        .whereType<Batch>()
        .toList();
  }

  static List<Map<String, dynamic>> _batchesToJson(List<Batch>? batches) {
    if (batches == null) return [];
    return batches.map((x) => x.toJson()).toList();
  }

  Corral copyWith({
    String? id,
    String? name,
    String? location,
    int? capacity,
    String? notes,
    String? imageUrl,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    int? activeBatchCount,
    CorralStatus? status,
    String? activeBatchName,
    DateTime? activeBatchEntryDate,
    double? lastBiometryAvgWeight,
    List<Batch>? batches,
    String? activeBatchId,
  }) {
    return Corral(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      capacity: capacity ?? this.capacity,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      activeBatchCount: activeBatchCount ?? this.activeBatchCount,
      status: status ?? this.status,
      activeBatchName: activeBatchName ?? this.activeBatchName,
      activeBatchEntryDate: activeBatchEntryDate ?? this.activeBatchEntryDate,
      lastBiometryAvgWeight:
          lastBiometryAvgWeight ?? this.lastBiometryAvgWeight,
      batches: batches ?? this.batches,
      activeBatchId: activeBatchId ?? this.activeBatchId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Corral && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
