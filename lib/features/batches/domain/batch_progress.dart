/// Estado del progreso del lote
enum ProgressStatus {
  /// El lote está dentro del rango esperado (90-110%)
  onTrack,

  /// El lote está por debajo del peso esperado (<90%)
  belowTarget,

  /// El lote está por encima del peso esperado (>110%)
  aboveTarget,

  /// No se puede calcular (falta información)
  unknown,
}

/// Modelo que representa el progreso de un lote
class BatchProgress {
  final String batchId;
  final int daysOld;
  final double weeksOld;
  final double currentWeight;
  final double referenceWeight;
  final double progressPercentage;
  final ProgressStatus status;
  final DateTime? lastBiometryDate;
  final String? currentFeedType;
  final List<String> pendingTasks;
  final DateTime lastUpdated;

  const BatchProgress({
    required this.batchId,
    required this.daysOld,
    required this.weeksOld,
    required this.currentWeight,
    required this.referenceWeight,
    required this.progressPercentage,
    required this.status,
    this.lastBiometryDate,
    this.currentFeedType,
    this.pendingTasks = const [],
    required this.lastUpdated,
  });

  factory BatchProgress.fromJson(Map<String, dynamic> json) {
    return BatchProgress(
      batchId: json['batch_id'] as String,
      daysOld: json['days_old'] as int,
      weeksOld: (json['weeks_old'] as num).toDouble(),
      currentWeight: (json['current_weight'] as num).toDouble(),
      referenceWeight: (json['reference_weight'] as num).toDouble(),
      progressPercentage: (json['progress_percentage'] as num).toDouble(),
      status: ProgressStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ProgressStatus.unknown,
      ),
      lastBiometryDate: json['last_biometry_date'] != null
          ? DateTime.parse(json['last_biometry_date'] as String)
          : null,
      currentFeedType: json['current_feed_type'] as String?,
      pendingTasks: (json['pending_tasks'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'batch_id': batchId,
      'days_old': daysOld,
      'weeks_old': weeksOld,
      'current_weight': currentWeight,
      'reference_weight': referenceWeight,
      'progress_percentage': progressPercentage,
      'status': status.name,
      'last_biometry_date': lastBiometryDate?.toIso8601String(),
      'current_feed_type': currentFeedType,
      'pending_tasks': pendingTasks,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  BatchProgress copyWith({
    String? batchId,
    int? daysOld,
    double? weeksOld,
    double? currentWeight,
    double? referenceWeight,
    double? progressPercentage,
    ProgressStatus? status,
    DateTime? lastBiometryDate,
    String? currentFeedType,
    List<String>? pendingTasks,
    DateTime? lastUpdated,
  }) {
    return BatchProgress(
      batchId: batchId ?? this.batchId,
      daysOld: daysOld ?? this.daysOld,
      weeksOld: weeksOld ?? this.weeksOld,
      currentWeight: currentWeight ?? this.currentWeight,
      referenceWeight: referenceWeight ?? this.referenceWeight,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      status: status ?? this.status,
      lastBiometryDate: lastBiometryDate ?? this.lastBiometryDate,
      currentFeedType: currentFeedType ?? this.currentFeedType,
      pendingTasks: pendingTasks ?? this.pendingTasks,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BatchProgress && other.batchId == batchId;
  }

  @override
  int get hashCode => batchId.hashCode;

  /// Retorna el color asociado al estado del progreso
  String get statusColor {
    switch (status) {
      case ProgressStatus.onTrack:
        return '#4CAF50'; // Verde
      case ProgressStatus.belowTarget:
        return '#FFC107'; // Amarillo
      case ProgressStatus.aboveTarget:
        return '#2196F3'; // Azul
      case ProgressStatus.unknown:
        return '#9E9E9E'; // Gris
    }
  }

  /// Retorna el icono asociado al estado del progreso
  String get statusIcon {
    switch (status) {
      case ProgressStatus.onTrack:
        return '🟢';
      case ProgressStatus.belowTarget:
        return '🟡';
      case ProgressStatus.aboveTarget:
        return '🔵';
      case ProgressStatus.unknown:
        return '⚪';
    }
  }

  /// Retorna una descripción del estado
  String get statusDescription {
    switch (status) {
      case ProgressStatus.onTrack:
        return 'En objetivo';
      case ProgressStatus.belowTarget:
        return 'Por debajo del objetivo';
      case ProgressStatus.aboveTarget:
        return 'Por encima del objetivo';
      case ProgressStatus.unknown:
        return 'Sin información suficiente';
    }
  }

  /// Diferencia en kg respecto al peso de referencia
  double get weightDifference {
    return currentWeight - referenceWeight;
  }

  /// Retorna true si hay tareas pendientes
  bool get hasPendingTasks {
    return pendingTasks.isNotEmpty;
  }
}
