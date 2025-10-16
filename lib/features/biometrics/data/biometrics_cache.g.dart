// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biometrics_cache.dart';

// ignore_for_file: type=lint
class $CachedBiometricStatsTable extends CachedBiometricStats
    with TableInfo<$CachedBiometricStatsTable, CachedBiometricStat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedBiometricStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _batchIdMeta =
      const VerificationMeta('batchId');
  @override
  late final GeneratedColumn<String> batchId = GeneratedColumn<String>(
      'batch_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _adgMeta = const VerificationMeta('adg');
  @override
  late final GeneratedColumn<double> adg = GeneratedColumn<double>(
      'adg', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _fcrMeta = const VerificationMeta('fcr');
  @override
  late final GeneratedColumn<double> fcr = GeneratedColumn<double>(
      'fcr', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _mortalityRateMeta =
      const VerificationMeta('mortalityRate');
  @override
  late final GeneratedColumn<double> mortalityRate = GeneratedColumn<double>(
      'mortality_rate', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _rawDataMeta =
      const VerificationMeta('rawData');
  @override
  late final GeneratedColumn<String> rawData = GeneratedColumn<String>(
      'raw_data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [batchId, adg, fcr, mortalityRate, rawData, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_biometric_stats';
  @override
  VerificationContext validateIntegrity(
      Insertable<CachedBiometricStat> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('batch_id')) {
      context.handle(_batchIdMeta,
          batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta));
    } else if (isInserting) {
      context.missing(_batchIdMeta);
    }
    if (data.containsKey('adg')) {
      context.handle(
          _adgMeta, adg.isAcceptableOrUnknown(data['adg']!, _adgMeta));
    } else if (isInserting) {
      context.missing(_adgMeta);
    }
    if (data.containsKey('fcr')) {
      context.handle(
          _fcrMeta, fcr.isAcceptableOrUnknown(data['fcr']!, _fcrMeta));
    } else if (isInserting) {
      context.missing(_fcrMeta);
    }
    if (data.containsKey('mortality_rate')) {
      context.handle(
          _mortalityRateMeta,
          mortalityRate.isAcceptableOrUnknown(
              data['mortality_rate']!, _mortalityRateMeta));
    } else if (isInserting) {
      context.missing(_mortalityRateMeta);
    }
    if (data.containsKey('raw_data')) {
      context.handle(_rawDataMeta,
          rawData.isAcceptableOrUnknown(data['raw_data']!, _rawDataMeta));
    } else if (isInserting) {
      context.missing(_rawDataMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {batchId};
  @override
  CachedBiometricStat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedBiometricStat(
      batchId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}batch_id'])!,
      adg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}adg'])!,
      fcr: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fcr'])!,
      mortalityRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}mortality_rate'])!,
      rawData: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}raw_data'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CachedBiometricStatsTable createAlias(String alias) {
    return $CachedBiometricStatsTable(attachedDatabase, alias);
  }
}

class CachedBiometricStat extends DataClass
    implements Insertable<CachedBiometricStat> {
  final String batchId;
  final double adg;
  final double fcr;
  final double mortalityRate;
  final String rawData;
  final DateTime updatedAt;
  const CachedBiometricStat(
      {required this.batchId,
      required this.adg,
      required this.fcr,
      required this.mortalityRate,
      required this.rawData,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['batch_id'] = Variable<String>(batchId);
    map['adg'] = Variable<double>(adg);
    map['fcr'] = Variable<double>(fcr);
    map['mortality_rate'] = Variable<double>(mortalityRate);
    map['raw_data'] = Variable<String>(rawData);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CachedBiometricStatsCompanion toCompanion(bool nullToAbsent) {
    return CachedBiometricStatsCompanion(
      batchId: Value(batchId),
      adg: Value(adg),
      fcr: Value(fcr),
      mortalityRate: Value(mortalityRate),
      rawData: Value(rawData),
      updatedAt: Value(updatedAt),
    );
  }

  factory CachedBiometricStat.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedBiometricStat(
      batchId: serializer.fromJson<String>(json['batchId']),
      adg: serializer.fromJson<double>(json['adg']),
      fcr: serializer.fromJson<double>(json['fcr']),
      mortalityRate: serializer.fromJson<double>(json['mortalityRate']),
      rawData: serializer.fromJson<String>(json['rawData']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'batchId': serializer.toJson<String>(batchId),
      'adg': serializer.toJson<double>(adg),
      'fcr': serializer.toJson<double>(fcr),
      'mortalityRate': serializer.toJson<double>(mortalityRate),
      'rawData': serializer.toJson<String>(rawData),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CachedBiometricStat copyWith(
          {String? batchId,
          double? adg,
          double? fcr,
          double? mortalityRate,
          String? rawData,
          DateTime? updatedAt}) =>
      CachedBiometricStat(
        batchId: batchId ?? this.batchId,
        adg: adg ?? this.adg,
        fcr: fcr ?? this.fcr,
        mortalityRate: mortalityRate ?? this.mortalityRate,
        rawData: rawData ?? this.rawData,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('CachedBiometricStat(')
          ..write('batchId: $batchId, ')
          ..write('adg: $adg, ')
          ..write('fcr: $fcr, ')
          ..write('mortalityRate: $mortalityRate, ')
          ..write('rawData: $rawData, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(batchId, adg, fcr, mortalityRate, rawData, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedBiometricStat &&
          other.batchId == this.batchId &&
          other.adg == this.adg &&
          other.fcr == this.fcr &&
          other.mortalityRate == this.mortalityRate &&
          other.rawData == this.rawData &&
          other.updatedAt == this.updatedAt);
}

class CachedBiometricStatsCompanion
    extends UpdateCompanion<CachedBiometricStat> {
  final Value<String> batchId;
  final Value<double> adg;
  final Value<double> fcr;
  final Value<double> mortalityRate;
  final Value<String> rawData;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CachedBiometricStatsCompanion({
    this.batchId = const Value.absent(),
    this.adg = const Value.absent(),
    this.fcr = const Value.absent(),
    this.mortalityRate = const Value.absent(),
    this.rawData = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedBiometricStatsCompanion.insert({
    required String batchId,
    required double adg,
    required double fcr,
    required double mortalityRate,
    required String rawData,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : batchId = Value(batchId),
        adg = Value(adg),
        fcr = Value(fcr),
        mortalityRate = Value(mortalityRate),
        rawData = Value(rawData),
        updatedAt = Value(updatedAt);
  static Insertable<CachedBiometricStat> custom({
    Expression<String>? batchId,
    Expression<double>? adg,
    Expression<double>? fcr,
    Expression<double>? mortalityRate,
    Expression<String>? rawData,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (batchId != null) 'batch_id': batchId,
      if (adg != null) 'adg': adg,
      if (fcr != null) 'fcr': fcr,
      if (mortalityRate != null) 'mortality_rate': mortalityRate,
      if (rawData != null) 'raw_data': rawData,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedBiometricStatsCompanion copyWith(
      {Value<String>? batchId,
      Value<double>? adg,
      Value<double>? fcr,
      Value<double>? mortalityRate,
      Value<String>? rawData,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return CachedBiometricStatsCompanion(
      batchId: batchId ?? this.batchId,
      adg: adg ?? this.adg,
      fcr: fcr ?? this.fcr,
      mortalityRate: mortalityRate ?? this.mortalityRate,
      rawData: rawData ?? this.rawData,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (batchId.present) {
      map['batch_id'] = Variable<String>(batchId.value);
    }
    if (adg.present) {
      map['adg'] = Variable<double>(adg.value);
    }
    if (fcr.present) {
      map['fcr'] = Variable<double>(fcr.value);
    }
    if (mortalityRate.present) {
      map['mortality_rate'] = Variable<double>(mortalityRate.value);
    }
    if (rawData.present) {
      map['raw_data'] = Variable<String>(rawData.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedBiometricStatsCompanion(')
          ..write('batchId: $batchId, ')
          ..write('adg: $adg, ')
          ..write('fcr: $fcr, ')
          ..write('mortalityRate: $mortalityRate, ')
          ..write('rawData: $rawData, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$BiometricsCache extends GeneratedDatabase {
  _$BiometricsCache(QueryExecutor e) : super(e);
  late final $CachedBiometricStatsTable cachedBiometricStats =
      $CachedBiometricStatsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cachedBiometricStats];
}
