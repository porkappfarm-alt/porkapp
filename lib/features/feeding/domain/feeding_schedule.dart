/// Tipos de alimento disponibles
enum FeedType {
  preStarter('pre_starter'),
  starter('starter'),
  grower('grower'),
  fattening('fattening'),
  finisher('finisher');

  final String value;
  const FeedType(this.value);

  String get label {
    switch (this) {
      case FeedType.preStarter:
        return 'Preiniciador';
      case FeedType.starter:
        return 'Iniciador';
      case FeedType.grower:
        return 'Levante';
      case FeedType.fattening:
        return 'Engorde';
      case FeedType.finisher:
        return 'Finalizador';
    }
  }

  static FeedType fromString(String value) {
    return FeedType.values.firstWhere((e) => e.value == value);
  }
}

/// Tareas adicionales disponibles
enum FeedingTask {
  vitamin('vitamin'),
  deworm('deworm');

  final String value;
  const FeedingTask(this.value);

  String get label {
    switch (this) {
      case FeedingTask.vitamin:
        return 'Vitaminar';
      case FeedingTask.deworm:
        return 'Desparasitar';
    }
  }

  static FeedingTask fromString(String value) {
    return FeedingTask.values.firstWhere((e) => e.value == value);
  }
}

/// Modelo de datos para el plan de alimentación
class FeedingSchedule {
  final String id;
  final int daysOld;
  final double weeksOld;
  final double averageWeightKg;
  final double dailyFeedKg;
  final double weeklyFeedKg;
  final FeedType feedType;
  final List<FeedingTask> tasks;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FeedingSchedule({
    required this.id,
    required this.daysOld,
    required this.weeksOld,
    required this.averageWeightKg,
    required this.dailyFeedKg,
    required this.weeklyFeedKg,
    required this.feedType,
    required this.tasks,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FeedingSchedule.fromJson(Map<String, dynamic> json) {
    return FeedingSchedule(
      id: json['id'] as String,
      daysOld: json['daysOld'] as int,
      weeksOld: (json['weeksOld'] as num).toDouble(),
      averageWeightKg: (json['averageWeightKg'] as num).toDouble(),
      dailyFeedKg: (json['dailyFeedKg'] as num).toDouble(),
      weeklyFeedKg: (json['weeklyFeedKg'] as num).toDouble(),
      feedType: FeedType.fromString(json['feedType'] as String),
      tasks: (json['tasks'] as List<dynamic>)
          .map((e) => FeedingTask.fromString(e as String))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'daysOld': daysOld,
      'weeksOld': weeksOld,
      'averageWeightKg': averageWeightKg,
      'dailyFeedKg': dailyFeedKg,
      'weeklyFeedKg': weeklyFeedKg,
      'feedType': feedType.value,
      'tasks': tasks.map((e) => e.value).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  FeedingSchedule copyWith({
    String? id,
    int? daysOld,
    double? weeksOld,
    double? averageWeightKg,
    double? dailyFeedKg,
    double? weeklyFeedKg,
    FeedType? feedType,
    List<FeedingTask>? tasks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FeedingSchedule(
      id: id ?? this.id,
      daysOld: daysOld ?? this.daysOld,
      weeksOld: weeksOld ?? this.weeksOld,
      averageWeightKg: averageWeightKg ?? this.averageWeightKg,
      dailyFeedKg: dailyFeedKg ?? this.dailyFeedKg,
      weeklyFeedKg: weeklyFeedKg ?? this.weeklyFeedKg,
      feedType: feedType ?? this.feedType,
      tasks: tasks ?? this.tasks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
