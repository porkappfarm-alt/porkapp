class BatchMeasurement {
  final String id;
  final String batchId;
  final DateTime measurementDate;
  final double averageWeight;
  final int animalCount;
  final String status;
  final String? measurementName;
  final DateTime createdAt;
  final DateTime? updatedAt;

  BatchMeasurement({
    required this.id,
    required this.batchId,
    required this.measurementDate,
    required this.averageWeight,
    required this.animalCount,
    required this.status,
    this.measurementName,
    required this.createdAt,
    this.updatedAt,
  });

  factory BatchMeasurement.fromJson(Map<String, dynamic> json) {
    return BatchMeasurement(
      id: json['id'].toString(),
      batchId: json['batch_id'].toString(),
      measurementDate: DateTime.parse(json['measurement_date']),
      averageWeight: json['average_weight']?.toDouble() ?? 0.0,
      animalCount: json['animal_count'] ?? 0,
      status: json['status'] ?? 'pending',
      measurementName: json['measurement_name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'batch_id': batchId,
      'measurement_date': measurementDate.toIso8601String(),
      'average_weight': averageWeight,
      'animal_count': animalCount,
      'status': status,
      'measurement_name': measurementName,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}